library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity f_adder is
port(
	a:  in STD_LOGIC_vector (1 downto 0);
	cin: in STD_LOGIC;
	s, cout: out STD_LOGIC);
end f_adder;

architecture rtl of f_adder is
begin

s<= a(1) xor a(0) xor cin;
cout<= (a(1) and a(0)) or (a(0) and cin) or (a(1) and cin);
end rtl;
