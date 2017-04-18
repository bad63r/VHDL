library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_division is
  
  generic (
    WIDTH : natural := 8);

  port (
    a_in, b_in       : in  std_logic_vector(WIDTH-1 downto 0);
    clk, reset       : in  std_logic;
    start            : in  std_logic;
    result,leftovers : out std_logic_vector(WIDTH-1 downto 0);
    ready            : out std_logic);

end entity binary_division;

architecture rtl of binary_division is

  type state is (idle,reverse,division,finit);
  signal current_state,next_state : state;
  signal op1_reg,op1_next : unsigned(WIDTH-1 downto 0);
  signal op2_reg,op2_next : unsigned(WIDTH-1 downto 0);
  signal q_reg,q_next : unsigned(WIDTH-1 downto 0);
  signal r_reg,r_next : unsigned(WIDTH-1 downto 0);
  
begin  -- architecture rtl

  --controlpath register
  process(clk,reset)
  begin
    if reset = '1' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  --controlpath generating next_state logic
  process(start,current_state,op1_reg,op1_next,op2_next,op2_reg,q_reg,q_next,r_reg,r_next,a_in,b_in)
  begin
    case current_state is
      when idle =>
        if start = '1' then
          if (a_in < b_in) then
            next_state <= reverse;
          else
            next_state <= division;
          end if;
        else
          next_state <= idle;
        end if;
      when reverse =>
        next_state <= division;
      when division =>
        if (op1_next < op2_next) then
          next_state <= finit;
        else
          next_state <= division;
        end if;
      when finit =>
        next_state <= idle;
    end case;
  end process;
  

end architecture rtl;
