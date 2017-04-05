library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

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
    clk <= '0','1' after 25 ns;
    wait for 50 ns;
  end process;

    stim_gen: process
    begin
      x_in <= conv_std_logic_vector(0,WIDTH),conv_std_logic_vector(9,WIDTH) after 30 ns, conv_std_logic_vector(16,WIDTH) after 80 ns, conv_std_logic_vector(64,WIDTH) after 130 ns;

      start <= '0','1' after 50 ns;
      reset <= '0','1' after 125 ns;
      wait;
      end process;
      
end architecture rtl;
