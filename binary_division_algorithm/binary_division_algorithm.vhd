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
    result, lefovers : out std_logic_vector(WIDTH-1 downto 0);
    ready            : out std_logic);

end entity binary_division;

architecture rtl of binary_division is

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
  process(start,current_state,

end architecture rtl;
