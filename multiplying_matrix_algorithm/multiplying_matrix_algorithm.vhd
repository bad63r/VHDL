library ieee;
use ieee.std_logic_1164.all;
use numeric_std.all;

entity multiplying_matrix_algorithm is
  
  generic (
    WIDTH : natural := 8;               -- width of elemtens of matrix
    SIZE  : natural := 3);              -- dimension of matrix

  port (
    clk      : in  std_logic;
    start    : in  std_logic;
    reset    : in  std_logic;
    ready    : out std_logic;
    --Matrix A
    a_addr_o : out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);  -- addresses for the first memory where matrix A is stored
    a_data_i : in  std_logic_vector(WIDTH-1 downto 0);  -- data which represents value of elemnts of matrix A
    a_we_o   : out std_logic;  -- write enable for memory 1, where matrix A is stored
    --Matrix B
    b_addr_o : out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);  -- addresses for the second memory where matrix B is stored
    b_data_i : in  std_logic_vector(WIDTH-1 downto 0);  -- data which represents value of elemnts of matrix B
    b_we_o   : out std_logic;
    --Matrix C
    c_addr_o : out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);  -- addresses for the third memory where matrix C is stored
    c_data_o : out std_logic_vector(log2c(2*WIDTH + SIZE) - 1 downto 0);  -- data which represents value of elements of matrix C
    c_we_o   : out std_logic);

end entity multiplying_matrix_algorithm;

architecture rtl of multiplying_matrix_algorithm is

  type states is (idle, i1, i2, i3, i2e, i3e);
  signal current_state, next_state : states;
  signal i_reg, j_reg, k_reg : unsigned(log2c(SIZE)-1 downto 0);
  signal i_next, j_next, k_next : unsigned(log2c(SIZE)-1 downto 0);
  signal temp_reg, temp_next : unsigned(log2c(2*WIDTH + SIZE)-1 downto 0);
  constant matrix_width : unsigned(log2c(SIZE)-1 downto 0) := SIZE;
begin  -- architecture rtl

  --control path: state register
  process (clk, reset) is
  begin  -- process
    if reset = '1' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  --control path: next-state logic
 process (current_state, start, comp1, comp2, comp3) is
  begin  -- process
    case current_state is
      when idle =>
        if start = '1' then
          next_state <= i1;
        else
          next_state <= idle;
        end if;
      when i1 =>
        next_state <= i2;
      when i2 =>
        next_state <= i3;
      when i3 =>
        if comp1 = '1' then
          next_state <= i3e;
        else
          next_state <= i3;
        end if;
      when i3e =>
        if comp2 = '1' then
          next_state <= i2e;
        else
          next_state <= i2;
        end if;
      when i2e =>
        if comp3 = '1' then
          next_state <= idle;
        else
          next_state <= i1;
        end if;
      when others => null;
    end case;
  end process; 

  --datapath: data registers
  process (clk, reset) is
  begin  -- process
    if reset = '1' then
      i_reg    <= (others => '0');
      j_reg    <= (others => '0');
      k_reg    <= (others => '0');
      temp_reg <= (others => '0');
    elsif rising_edge(clk) then
      i_reg    <= i_next;
      j_reg    <= j_next;
      k_reg    <= k_next;
      temp_reg <= temp_next;
    end if;
  end process;

  --datapath: routhing network
  process (current_state, a_data_i, b_data_i, i_reg, j_reg, k_reg, i_next, j_next, k_next) is
  begin  -- process
    i_next     <= i_reg;
    j_next     <= j_reg;
    k_next     <= k_reg;
    temp_next  <= temp_reg;
    a_addr_o   <= (others => '0');
    a_we_o     <= '0';
    b_addr_o   <= (others => '0');
    b_we_o     <= '0';
    c_addr_o   <= (others => '0');
    c_data_o   <= (others => '0');
    ready      <= '0';
    
    case current_state is
      when idle =>
        ready <= '1';
      when i1 =>
        j_next     <= (others => '0');
      when i2 =>
        k_next     <= (others => '0');
        temp_next  <= (others => '0');
        a_addr_o   <= (i_reg * matrix_width + k_next);
        a_we_o     <= '1';
        b_addr_o   <= (k_next * matrix_width + j_reg);
        b_we_o     <= '1';
      when i3 =>
        temp_next <= temp_reg + unsigned(a_data_i) + unsigned(b_data_i);
        k_next    <= k_reg + 1;
        a_addr_o  <= (i_reg * matrix_width + k_next);
        a_we_o    <= '1';
        b_addr_o  <= (k_next * matrix_width + j_reg);
        b_we_o    <= '1';2
      when i3e =>
        c_addr_o <= (i_reg * matrix_width + j_reg);
        c_we_o   <= '1';
        c_data_o <= std_logic_vector(temp_reg);
        j_next <= j_reg + 1;
      when i2e =>
        i_next <= i_reg + 1;
      when others => null;
    end case;
  end process;

  --datapath: status signals
  comp1 <= '1' when k_next = matrix_width else '0';
  comp2 <= '1' when j_next = matrix_width else '0';
  comp3 <= '1' when i_next = matrix_width else '0';
           
end architecture rtl;
