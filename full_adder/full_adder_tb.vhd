library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is
  
end entity full_adder_tb;

architecture beh of full_adder_tb is

  signal a, b : std_logic;
  signal cin  : std_logic;
  signal cout : std_logic;
  signal sum  : std_logic;

 begin  -- architecture beh

   full_adder_1 : entity work.full_adder
     port map (
       a    => a,
       b    => b,
       cin  => cin,
       cout => cout,
       sum  => sum);

   stim_gen : process is
   begin  -- process stim_gen
     a   <= '0', '1' after 100 ns, '0' after 200 ns, '1' after 500 ns;
     b   <= '1', '0' after 100 ns, '1' after 400 ns;
     cin <= '0', '1' after 300 ns, '0' after 360 ns, '1' after 600 ns;
     wait;
   end process stim_gen;

end architecture beh;
