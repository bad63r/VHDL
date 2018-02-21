library ieee;
use ieee.std_logic_1164.all;

entity MtoN_tb is
  
end entity MtoN_tb;

architecture rtl of MtoN_tb is

  signal clk   : std_logic;
  signal reset : std_logic;
  signal q     : std_logic_vector(3 downto 0);
  constant M : natural := 3;
  constant N : natural := 9;

begin  -- architecture rtl

  MtoN_1: entity work.MtoN
    generic map (
      M => M,
      N => N)
    port map (
      clk   => clk,
      reset => reset,
      q     => q);

  clk_gen:process
  begin
    clk <= '0','1' after 10 ns;
    wait for 20 ns;
  end process;

  stim_gen:process
  begin
    reset <= '1','0' after 15 ns,'1' after 500 ns,'0' after 520 ns;
    wait;
  end process;


end architecture rtl;
