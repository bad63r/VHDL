library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity dec_counter is
	port  (en, rst, clk: in std_logic; 
	       q: out std_logic_vector(3 downto 0);   --this is output
	       pulse: out std_logic);
end dec_counter;

architecture rtl of dec_counter is
	signal cnt_reg:  unsigned(3 downto 0);
	signal cnt_next: unsigned(3 downto 0);
begin

	reg_p: process(clk) is 
	begin
		if rising_edge(clk) then
			if rst = '1' then
				cnt_reg <= (others => '0');
			else
				cnt_reg <= cnt_next;
			end if;
		end if;
	end process;

	comb_p: process(cnt_reg, en) is
	begin
		cnt_next <= cnt_reg;
		pulse <= '0';

		if en = '1' then
			if cnt_reg = 9 then
				cnt_next <= (others => '0');
				pulse <= '1';
			else
				cnt_next <= cnt_reg + 1;
			end if;
		end if;
	end process;       

	q <= std_logic_vector(cnt_reg);        

end rtl;


