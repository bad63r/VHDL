library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utils_pkg.all;

entity multiplaying_matrix_algorithm is

  generic (
    WIDTH : natural := 8;
    SIZE  : natural := 3);

  port (
    --Clock and reset interface
    clk, reset : in  std_logic;
    --INPUT DATA INTERFACE
    --Matrix A
    a_addr_o   : out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    a_data_i   : in  std_logic_vector(WIDTH-1 downto 0);
    a_we_o     : out std_logic;
    --Matrix B
    b_addr_o   : out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    b_data_i   : in  std_logic_vector(WIDTH-1 downto 0);
    b_we_o     : out std_logic;
    --Matrix dimensions 
    n_in       : in  std_logic_vector(log2c(SIZE)-1 downto 0);
    m_in       : in  std_logic_vector(log2c(SIZE)-1 downto 0);
    p_in       : in  std_logic_vector(log2c(SIZE)-1 downto 0);
    --Command interface
    start      : in  std_logic;
    --Status interface
    ready      : out std_logic;
    --OUTPUT DATA INTERFACE
    --Matrix C
    c_add_o    : out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    c_data_o   : out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
    c_we_o     : out std_logic);

end entity multiplaying_matrix_algorithm;

architecture rtl of multiplaying_matrix_algorithm is

  type states is (idle, i1, i2, load, i3, i3e, i2e);
  --signals for control path register
  signal current_state, next_state                   : states;

  --signals for datapath register
  signal i_reg, i_next, j_reg, j_next, k_reg, k_next : unsigned(log2c(SIZE)-1 downto 0);
  signal temp_reg, temp_next                         : unsigned(2*WIDTH+SIZE-1 downto 0);

begin  -- architecture rtl

  -- Control path and datapath registers
  process (clk, reset) is
  begin  -- process
    if reset = '1' then
      current_state <= idle;
      i_reg         <= (others => '0');
      j_reg         <= (others => '0');
      k_reg         <= (others => '0');
      temp_reg      <= (others => '0');
    elsif rising_edge(clk) then
      current_state <= next_state;
      i_next         <= (others => '0');
      j_next         <= (others => '0');
      k_next         <= (others => '0');
      temp_next      <= (others => '0');
    end if;
  end process;

  --Control path: Next-state logic and datapath: routing network
  process (current_state, start, a_data_i, b_data_i, i_reg, i_next, j_reg, j_next, k_reg, k_next) is
  begin  -- process
    --registers
    i_next    <= i_reg;
    j_next    <= j_reg;
    k_next    <= k_reg;
    temp_next <= temp_reg;
    --Matrix A
    a_addr_o  <= (others => '0');
    a_we_o    <= '0';
    --Matrix B
    b_addr_o  <= (others => '0');
    b_we_o    <= '0';
    --Matrix C
    c_add_o   <= (others => '0');
    c_data_o  <= (others => '0');
    c_we_o    <= '0';
    --status signal
    ready     <= '0';

    case current_state is
      when idle =>
        i_next     <= (others => '0');
        j_next     <= (others => '0');
        k_next     <= (others => '0');
        temp_next  <= (others => '0');
        ready      <= '1';
        if start = '1' then
          next_state <= i1;
        else
          next_state <= idle;
        end if;
      when i1 =>
        j_next     <= (others => '0');
        next_state <= i2;
      when i2 =>
        temp_next  <= (others => '0');
        k_next     <= (others => '0');
        a_addr_o   <= std_logic_vector((i_reg * unsigned(n_in)) + k_reg);
        b_addr_o   <= std_logic_vector((k_reg * unsigned(m_in)) + j_reg);
        next_state <= i3;
      when load =>
        a_addr_o   <= std_logic_vector((i_reg * unsigned(n_in)) + k_reg);
        b_addr_o   <= std_logic_vector((k_reg * unsigned(m_in)) + j_reg);
        next_state <= i3;
      when i3 =>
        temp_next <= temp_reg + (unsigned(a_data_i) * unsigned(b_data_i));
        k_next    <= k_reg + 1;
        if (k_next = unsigned(m_in)) then
          next_state <= i3e;
        else
          next_state <= load;
        end if;
      when i3e =>
        c_add_o  <= std_logic_vector((i_reg * unsigned(n_in)) + j_reg);
        c_we_o   <= '1';
        c_data_o <= std_logic_vector(temp_reg);
        j_next   <= j_reg + 1;
        if (j_next = unsigned(p_in)) then
          next_state <= i2e;
        else
          next_state <= i2;
        end if;
      when i2e =>
        i_next <= i_reg + 1;
        if (i_next = unsigned(n_in)) then
          next_state <= idle;
        else
          next_state <= i1;
        end if;
      when others => null;
    end case;
  end process;


end architecture rtl;


















