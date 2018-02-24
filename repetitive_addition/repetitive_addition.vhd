library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rep_addition is
  
  generic (
    WIDTH : natural := 8);

  port (
    a_in, b_in : in  std_logic_vector(WIDTH-1 downto 0);
    clk, reset : in  std_logic;
    start      : in  std_logic;
    result     : out std_logic_vector(2*WIDTH-1 downto 0);
    ready      : out std_logic);

end entity rep_addition;

architecture rtl of rep_addition is

  type state is (idle,ab0,load,op);
  signal current_state,next_state : state;
  signal a_is_0,b_is_0,count_0 : std_logic;  
  signal a_reg,n_reg,a_next,n_next : unsigned(WIDTH-1 downto 0); 
  signal r_reg,r_next : unsigned(2*WIDTH-1 downto 0);
  signal adder_out : unsigned(2*WIDTH-1 downto 0);
  signal sub_out : unsigned(WIDTH-1 downto 0);

begin  -- architecture rtl

--controlpath

  --state register
  process(clk,reset)
  begin
    if reset = '1' then
      current_state <= idle;
    else
      current_state <= next_state;
    end if;
  end process;

  --next-state logic
  process(current_state,a_is_0,b_is_0,count_0,start)
  begin
    case current_state is
      when idle =>
        if start = '1' then
          if a_in = 0 or b_in = 0 then
            next_state <= ab0;
          else
            next_state <= load;
          end if;
        else
          next_state <= idle;
        end if;
      when ab0 =>
        next_state <= idle;
      when load =>
        next_state <= op;
      when op =>
        if count_0 = '0' then
          next_state <= idle;
        else
          next_state <= op;
        end if;
    end case;
  end process;

  --controlpath output logic

  ready <= '1' when current_state = idle else '0';

--datapath

  --data registers
  process(clk,reset)
  begin
    if reset ='1' then
      a_reg <= (others => '0');
      n_reg <= (others => '0');
      r_reg <= (others => '0');
    elsif rising_edge(clk) then
      a_reg <= a_next;
      n_reg <= n_next;
      r_reg <= r_next;
    end if;
  end process;

  --routing network

  process(current_state,a_reg,n_reg,r_reg,a_in,b_in,adder_out,sub_out)
  begin
    case current_state is
      when idle =>
        a_next <= a_reg;
        n_next <= n_reg;
        r_next <= r_reg;
      when ab0 =>
        a_next <= unsigned(a_in); 
        n_next <= unsigned(b_in);
        r_next <= (others => '0');
      when load =>
        a_next <= unsigned(a_in); 
        n_next <= unsigned(b_in);
        r_next <= (others => '0');
      when op =>
        a_next <= a_reg; 
        n_next <= sub_out;
        r_next <= adder_out;
    end case;

    --datapath functional units

    adder_out <= ((conv_std_logic_vector(0,WIDTH) & a_reg) + r_reg;
    sub_out <= n_reg -1;

    --datapath status signals

    a_is_0 <= '1' when a_in = conv_std_logic_vector(0,WIDTH) else '0';
    b_is_0 <= '1' when b_in =  conv_std_logic_vector(0,WIDTH) else '0';
    count_0 <= '1' when n_next = conv_std_logic_vector(0,WIDTH) else '0';

    --datapath output

    result <= conv_std_logic_vector(a_reg);
                  

architecture rtl;
