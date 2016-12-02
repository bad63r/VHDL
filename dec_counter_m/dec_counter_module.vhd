--Pitaj ga sta ti tu nije jasno kdo povezivanja i koji tip da nazoves signale...
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric.std.all;

entity dec_counter_module is
	port (en,rst,clk: in std_logic;
	      q: out std_logic_vector(2 downto 0));

architecture struct of dec_counter_module is 
	signal s1,s2,s3,s4,s5,s6: unsigned
begin
	dec1: entity work.dec_counter(rtl)
	port map(en => en,
		 rst => rst,
		 clk => clk,
		 q => s1,
		 pulse => s2);

	dec2: entity work.dec_counter(rtl)
	port map(en => en,
		 rst => rst,
		 clk => clk,
		 q => s3,
		 pulse => s4);

	dec3: entity work.dec_counter(rtl)
	port map(en => en,
		 rst => rst,
		 clk => clk,
		 q => s5,
		 pulse => s6);

end architecture struct;
