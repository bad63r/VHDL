library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_converter_generic is
  
  generic (
    WIDTH : natural := 8);

  port (
    s_i : in  std_logic;
    clk : in  std_logic;
    p_o : out std_logic_vector(WIDTH-1 downto 0));

end entity sp_converter_generic;

architecture rtl of sp_converter_generic is

  signal buf_reg : unsigned(WIDTH-1 downto 0) := (others =>'0');
  signal cnt : unsigned(WIDTH-1 downto 0):= (others => '0');
  
begin  -- architecture rtl

  generisanje_FF: for i in 1 to WIDTH-1 generate
    process(clk)    
    begin
      if rising_edge(clk) then
        buf_reg(i) <= buf_reg(i-1);
      end if;
    end process;
  end generate generisanje_FF; 

  process(clk)
  begin
    if rising_edge(clk) then
      buf_reg(0) <= s_i;
    end if;
  end process;
  
    counter: process(clk)  --odredjuje duzinu izlaza
             begin
               if rising_edge(clk) then
                 cnt <= cnt + 1;
                 if cnt = WIDTH then
                   p_o <= std_logic_vector(buf_reg);
                   cnt <= (others =>'0');
                 end if;
               end if;
                   
               end process;
               
             
end architecture rtl;
