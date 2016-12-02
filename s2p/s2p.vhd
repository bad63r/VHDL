library ieee;
use ieee.std_logic_1164.all;
use eee.numeric_std.all;


entity s2p_converter is
  generic(WIDTH:natural);
  port(clk: in std_logic;
       si:in std_logic;
       q: out std_logic_vector(WIDTH -1 downto 0));
end s2p_converter;

architecture rtl of s2p_converter is
  signal pom: unsigned (WIDTH -1 downto 0);
begin

  s2p_p:process is
  begin
    if rising_edge(clk) then
      pom <= si & pom(WIDTH -1 downto 1);
    end if;
    wait on clk;
  end process;

  q <= std_logic_vector(pom);

  end architecture rtl;
