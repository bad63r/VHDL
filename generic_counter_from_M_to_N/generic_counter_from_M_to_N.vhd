--zadatak2.2 ,druga vezba
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity generic_counter is
	generic (M:integer:=2
	N:integer:=8
	width:integer:=N-M);
	port( clk: in std_logic;
	      q:out std_logic_vector(width-1 downto 0));


architecture rtl of generic_counter is
begin

