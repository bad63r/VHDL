library ieee;
use ieee.std_logic_1164.all;

entity or_gate is
	port(x0,x1: in std_logic;
		 y: out std_logic);
end entity or_gate;

architecture beh of or_gate  is	
begin
	or:process is	
		begin	
			if x0='0' and x1='0' then
				y<='0';
			else y<='1';
			end if;
		wait on x0,x1;
		end process;
end beh;
