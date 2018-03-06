library ieee;
use ieee.std_logic_1164.all;

use work.utils_pkg.all;

entity RAM_memory_tb is
  
end entity RAM_memory_tb;

architecture rtl of RAM_memory_tb is

  constant WIDTH : integer := 8;
  constant SIZE  : integer := 9;
  signal clk        : std_logic;
  signal address_in : std_logic_vector(log2c(SIZE)-1 downto 0);
  signal data_in    : std_logic_vector(WIDTH-1 downto 0);
  signal data_out   : std_logic_vector(WIDTH-1 downto 0);
  signal we         : std_logic;

begin  -- architecture rtl

RAM_memory_1: entity work.RAM_memory
  generic map (
    WIDTH => WIDTH,
    SIZE  => SIZE)
  port map (
    clk        => clk,
    address_in => address_in,
    data_in    => data_in,
    data_out   => data_out,
    we         => we);

clk_gen: process is
begin  -- process clk_gen
  clk <='0', '1' after 10 ns;
  wait for 20 ns;
end process clk_gen;

stim_gen: process is
begin  -- process stim_gen
  we <= '1', '0' after 200 ns;
  address_in <= x"0", x"1" after 25 ns, x"2" after 45 ns, x"3" after 65 ns, x"4" after 85 ns, x"0" after 201 ns,
                x"1" after 225 ns, x"2" after 245 ns, x"3" after 265 ns, x"4" after 285 ns, x"3" after 300 ns, x"3" after 610 ns;
  data_in <= x"54", x"72" after 25 ns, x"30" after 45 ns, x"03" after 65 ns, x"94" after 85 ns, x"10" after 610 ns;
  wait;
end process stim_gen;

end architecture rtl;
