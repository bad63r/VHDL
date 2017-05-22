library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booth_algorithm_tb is
  
end entity booth_algorithm_tb;

architecture rtl of booth_algorithm_tb is

  constant WIDTH:natural := 8;

  signal a_in, b_in : std_logic_vector(WIDTH-1 downto 0);
  signal start      : std_logic;
  signal clk, reset : std_logic;
  signal ready      : std_logic;
  signal res        : std_logic_vector(2*WIDTH-1 downto 0);


begin  -- architecture rtl

  booth_algorithm_1: entity work.booth_algorithm
    generic map (
      WIDTH => WIDTH)
    port map (
      a_in  => a_in,
      b_in  => b_in,
      start => start,
      clk   => clk,
      reset => reset,
      ready => ready,
      res   => res);

    stim_gen_clk:process
    begin
      clk <= '0','1' after 25 ns;
    wait for 50 ns;
    end process;

      stim_gen: process
    begin
      a_in <= "00000000","00001000" after 20 ns, "10000010" after 200 ns;
      b_in <= "00000000","10000010" after 20 ns, "10000010" after 200 ns;

      start <='1'; 
      reset <= '1','0' after 10 ns,'1' after 125 ns, '0' after 200 ns;
      wait;
      end process;
 



 end architecture rtl;
