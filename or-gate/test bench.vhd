library ieee;
use ieee.std_logic_1164.all;

entity or_gate_tb is
end entity or_gate_tb;

architecture beh of or_gate_tb is

signal x0_s,x1_s:std_logic;
signal y_s:std_logic;

begin

	duv:entity work.or_gate(beh)
				port map(x0=>x0_s,
						 x1=>x1_s,
						 y=>y_s);
						 
	stim_gen:process is	
			 begin
			 
			 x0_s<='0','1' after 100 ns,'0' after 200 ns,
					 '1' after 300 ns,'0' after 400 ns,
					 '1' after 600 ns,'0' after 700 ns;
			 x1_s<='0','1' after 200 ns,'0' after 300 ns,
					   '1' after 400 ns,'0' after 500 ns,
					   '1' after 600 ns,'0' after 700 ns;
			wait;
			end process;
end beh;
