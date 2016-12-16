library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SP_generic_converter is
	generic(width: integer := 8);
			
	port(s_i,clk: in std_logic;
		 Q : out std_logic_vector(width - 1  downto 0));
end entity SP_generic_converter;

architecture rtl of SP_generic_converter is
  signal bufer : unsigned(width - 1 downto 0) := (others => '0');
  signal p_o: unsigned (width -1 downto 0) := (others => '0');
begin
  converter: process is
  begin
      if counter = 8 then
        p_o <= bufer;
      end if;
    wait on counter;
  end process;

  counter: process is
  begin
    if rising_edge(clk) then
      counter <= counter + 1;
      bufer <= s_i & bufer(width -1 downto 1);
    end if;
    wait on clk;
    end process;
    Q <= std_logic_vector(p_o);


    
 end architecture;
