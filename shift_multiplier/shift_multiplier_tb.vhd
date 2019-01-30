library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_multiplier_tb is
  
end entity shift_multiplier_tb;

architecture rtl of shift_multiplier_tb is

  constant WIDTH    : natural := 8;
  signal a_in, b_in : std_logic_vector(WIDTH-1 downto 0);
  signal start      : std_logic;
  signal clk, reset : std_logic;
  signal sum_out    : std_logic_vector(2*WIDTH-1 downto 0);
  signal ready      : std_logic;

begin  -- architecture rtl

  shift_multiplier_1: entity work.shift_multiplier
    generic map (
      WIDTH => WIDTH)
    port map (
      a_in    => a_in,
      b_in    => b_in,
      start   => start,
      clk     => clk,
      reset   => reset,
      sum_out => sum_out,
      ready   => ready);

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
