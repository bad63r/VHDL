library ieee;
use ieee.std_logic_1164.all;

use work.utils_pkg.all;

entity RAM_memory_2ports_tb is
  
end entity RAM_memory_2ports_tb;

architecture rtl of RAM_memory_2ports_tb is

  constant WIDTH : integer := 8;
  constant SIZE  : integer := 9;
  signal clk           : std_logic;
  signal address_in_p1 : std_logic_vector(log2c(SIZE)-1 downto 0);
  signal data_in_p1    : std_logic_vector(WIDTH-1 downto 0);
  signal data_out_p1   : std_logic_vector(WIDTH-1 downto 0);
  signal we_p1         : std_logic;
  signal address_in_p2 : std_logic_vector(log2c(SIZE)-1 downto 0);
  signal data_in_p2    : std_logic_vector(WIDTH-1 downto 0);
  signal data_out_p2   : std_logic_vector(WIDTH-1 downto 0);
  signal we_p2         : std_logic;

begin  -- architecture rtl

  RAM_memory_2ports_1: entity work.RAM_memory_2ports
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk           => clk,
      address_in_p1 => address_in_p1,
      data_in_p1    => data_in_p1,
      data_out_p1   => data_out_p1,
      we_p1         => we_p1,
      address_in_p2 => address_in_p2,
      data_in_p2    => data_in_p2,
      data_out_p2   => data_out_p2,
      we_p2         => we_p2);

  clk_gen: process is
  begin  -- process clk_gen
    clk <='0', '1' after 10 ns;
    wait for 20 ns;
  end process clk_gen;

  stim_gen: process is
  begin  -- process stim_gen
    we_p1 <= '1', '0' after 200 ns;
    address_in_p1 <= x"0", x"1" after 25 ns, x"2" after 45 ns, x"3" after 65 ns, x"4" after 85 ns, x"0" after 201 ns, x"7" after 250 ns;
    data_in_p1 <= x"54", x"72" after 25 ns, x"30" after 45 ns, x"89" after 65 ns, x"94" after 85 ns, x"10" after 610 ns;

    we_p2 <= '1', '0' after 200 ns;
    address_in_p2 <= x"5", x"6" after 25 ns, x"7" after 45 ns, x"8" after 65 ns, x"1" after 300 ns;
    data_in_p2 <= x"23", x"45" after 25 ns, x"67" after 45 ns, x"88" after 65 ns;
    wait;
  end process stim_gen;


end architecture rtl;


