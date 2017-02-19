library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity f_adder_4bits is
port(
	a: in std_logic_vector (3 downto 0);
	b: in std_logic_vector (3 downto 0);
	s: out std_logic_vector (3 downto 0);
	cin: in std_logic;
	cout: out std_logic);
end f_adder_4bits;

architecture rtl of f_adder_4bits is
component f_adder
port(
	a:  in STD_LOGIC_vector (1 downto 0);
	cin: in STD_LOGIC;
	s, cout: out STD_LOGIC);
end component;

signal carry_s: std_logic_vector (4 downto 0);

begin
	carry_s(0) <= cin;
	four_bit_add: for i in 0 to 3 generate

	signal_bit_add: f_adder
	port map(
	a(0) => a(i);
	a(1) => b(i);
	cin => carry_s(i);
	s=>s(i);
	cout => carry_s(i+1)
	);

end generate four_bit_add;
cout<=carry_s(4);
end architecture rtl;
