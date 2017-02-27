library ieee;
use ieee.std_logic_1164.all;

entity arbitar_fer_tb is
  
end entity arbitar_fer_tb;

architecture rtl of arbitar_fer_tb is

  signal clk, reset, r0, r1 : std_logic;
  signal g0, g1             : std_logic;
  
begin  -- architecture rtl

  arbitar_1: entity work.arbitar_fer
    port map (
      clk   => clk,
      reset => reset,
      r0    => r0,
      r1    => r1,
      g0    => g0,
      g1    => g1);

  stim_gen:process
  begin
    reset <= '0','1' after 1 ns, '0' after 100 ns;
    r0 <= '0','1' after 110 ns, '0' after 200 ns, '1' after 290 ns, '0' after 500 ns;
    r1 <= '0', '1' after 140 ns, '0' after 200 ns, '1' after 300 ns, '0' after 510 ns;
    wait;
  end process;

  clk_gen: process
    begin
    clk <= '0', '1' after 50 ns;
    wait for 100 ns;
   end process;

end architecture rtl;
