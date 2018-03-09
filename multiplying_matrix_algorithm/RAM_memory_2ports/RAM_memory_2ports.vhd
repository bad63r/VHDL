library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utils_pkg.all;

entity RAM_memory_2ports is
  
  generic (
    WIDTH : integer := 8;
    SIZE  : integer := 9);

  port (
    clk           : in  std_logic;
    address_in_p1 : in  std_logic_vector(log2c(SIZE)-1 downto 0);-- port 1
    data_in_p1    : in  std_logic_vector(WIDTH-1 downto 0);      -- port 1
    data_out_p1   : out std_logic_vector(WIDTH-1 downto 0);      -- port 1
    we_p1         : in  std_logic;        -- write enable
    address_in_p2 : in  std_logic_vector(log2c(SIZE)-1 downto 0);-- port 2
    data_in_p2    : in  std_logic_vector(WIDTH-1 downto 0);      -- port 2
    data_out_p2   : out std_logic_vector(WIDTH-1 downto 0);      -- port 2
    we_p2         : in  std_logic);        -- write enable

end entity RAM_memory_2ports;

architecture rtl of RAM_memory_2ports is

  type mem is array (0 to SIZE-1) of std_logic_vector(WIDTH-1 downto 0);
  signal mem_s : mem;
begin  -- architecture rtl

  process (clk) is
  begin  -- process
    if rising_edge(clk) then
      if we_p1 = '1' then
        mem_s(to_integer(unsigned(address_in_p1))) <= data_in_p1;
      end if; 
      if we_p2 = '1' then
        mem_s(to_integer(unsigned(address_in_p2))) <= data_in_p2;
      end if; 
      data_out_p1 <= mem_s(to_integer(unsigned(address_in_p1)));
      data_out_p2 <= mem_s(to_integer(unsigned(address_in_p2)));
    end if;
  end process;

end architecture rtl;
