library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; --using this package for conversion --> std_logic_vector(to_unsigned(number,bit_width))

entity repetitive_addition_tb is
  
end entity repetitive_addition_tb;

architecture rtl of repetitive_addition_tb is


  constant WIDTH    : natural := 8;
  signal a_in, b_in : std_logic_vector(WIDTH-1 downto 0);
  signal clk, reset : std_logic;
  signal start      : std_logic;
  signal result     : std_logic_vector(2*WIDTH-1 downto 0);
  signal ready      : std_logic;
begin  -- architecture rtl

  rep_addition_1: entity work.repetitive_addition
    generic map (
      WIDTH => WIDTH)
    port map (
      a_in   => a_in,
      b_in   => b_in,
      clk    => clk,
      reset  => reset,
      start  => start,
      result => result,
      ready  => ready);

  clk_gen:process
  begin
    clk <= '0', '1' after 10 ns;
    wait for 20 ns;
  end process;

  stim_gen:process
  begin
    reset <= '1','0' after 14 ns, '1' after 300 ns, '0' after 330 ns;
    start <= '1','0' after 150 ns, '1' after 300 ns, '0' after 340 ns;
    a_in <= std_logic_vector(to_unsigned(5,WIDTH)), std_logic_vector(to_unsigned(9,WIDTH)) after 200 ns;
    b_in <= std_logic_vector(to_unsigned(7,WIDTH)), std_logic_vector(to_unsigned(9,WIDTH)) after 200 ns;
    wait;
  end process;


end architecture rtl;
