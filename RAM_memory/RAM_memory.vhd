library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utils_pkg.all;

entity RAM_memory is
  
  generic (
    WIDTH : integer := 8;
    SIZE  : integer := 9);

  port (
    clk        : in  std_logic;
    address_in : in  std_logic_vector(log2c(SIZE)-1 downto 0);
    data_in    : in  std_logic_vector(WIDTH-1 downto 0);
    data_out   : out std_logic_vector(WIDTH-1 downto 0);
    we         : in  std_logic);        -- write enable

end entity RAM_memory;

architecture rtl of RAM_memory is

  type mem is array (0 to SIZE-1) of std_logic_vector(WIDTH-1 downto 0);
  signal mem_s : mem;
begin  -- architecture rtl

  process (clk) is
  begin  -- process
    if rising_edge(clk) then
      if we = '1' then
       mem_s(to_integer(unsigned(address_in))) <= data_in;
      end if; 
       data_out <= mem_s(to_integer(unsigned(address_in)));
    end if;
  end process;

end architecture rtl;
