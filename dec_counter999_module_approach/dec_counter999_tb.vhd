library ieee;
use ieee.std_logic_1164.all;

entity dec_counter999_tb is
  
end entity dec_counter999_tb;

architecture rtl of dec_counter999_tb is

  signal clk, en, reset : std_logic;
  signal q              : std_logic_vector(9 downto 0);
  signal p              : std_logic;

begin  -- architecture rtl

  dec_counter999_1: entity work.dec_counter999
    port map (
      clk   => clk,
      en    => en,
      reset => reset,
      q     => q,
      p     => p);

  clk_gen:process is
  begin
    clk <= '0', '1' after 10 ns;
    wait for 20 ns;
  end process;

  stim_gen:process is
  begin
    reset <= '1',
             '0' after 15 ns;--'1' after 930 ns;
    en    <= '1';
             --'0' after 345 ns,'1' after 380 ns;
    wait;
    end process;
  

end architecture rtl;
