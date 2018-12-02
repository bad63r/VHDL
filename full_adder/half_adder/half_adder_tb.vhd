library ieee;
use ieee.std_logic_1164.all;

entity half_adder_tb is
  
end entity half_adder_tb;

architecture beh of half_adder_tb is

  signal a, b      : std_logic;
  signal sum, cout : std_logic;

begin  -- architecture beh

  half_adder_1: entity work.half_adder
    port map (
      a    => a,
      b    => b,
      sum  => sum,
      cout => cout);

  stim_gen: process is
  begin  -- process stim_gen
    a <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 500 ns;
    b <= '1', '0' after 100 ns, '1' after 400 ns;
    wait;
  end process stim_gen;

end architecture beh;







