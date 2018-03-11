--promeniti trajanje simulacije na 2000ns
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_algorithm_tb is
  
end entity sqrt_algorithm_tb;

architecture rtl of sqrt_algorithm_tb is

  constant WIDTH : natural := 32;

  signal x_in       : std_logic_vector(WIDTH-1 downto 0);
  signal clk, reset : std_logic;
  signal start      : std_logic;
  signal ready      : std_logic;
  signal result     : std_logic_vector(WIDTH-1 downto 0);
  
begin  -- architecture rtl

  sqrt_algorithm_1: entity work.sqrt_algorithm
    generic map (
      WIDTH => WIDTH)
    port map (
      x_in   => x_in,
      clk    => clk,
      reset  => reset,
      start  => start,
      ready  => ready,
      result => result);

  stim_gen_clk:process
    begin
    clk <= '0','1' after 10 ns;
    wait for 20 ns;
  end process;

    stim_gen: process
    begin
      x_in <= std_logic_vector(to_unsigned(9, WIDTH)), std_logic_vector(to_unsigned(16, WIDTH)) after 500 ns,
              std_logic_vector(to_unsigned(64, WIDTH)) after 1000 ns;

      start <='1', '0' after 14 ns, '1' after 505 ns, '0' after 515 ns;
      reset <= '1','0' after 10 ns;
      wait;
      end process;
      
end architecture rtl;
