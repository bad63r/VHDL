library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
	port(x0,x1:in std_logic;
		 y:out std_logic);
end entity and_gate;

architecture beh of and_gate is
begin
	i:process is	
	  begin
	  if x0='1' and x1='1' then
			y<='1';
			else y<='0';
	  end if;
	  wait on x0,x1;
	  end process;
end beh;


