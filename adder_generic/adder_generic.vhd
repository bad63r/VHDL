library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_generic is
  generic(WIDTH : natural := 8);
  port(a, b                       : in  std_logic_vector(WIDTH-1 downto 0);
       cin                        : in  std_logic;
       sum                        : out std_logic_vector(WIDTH-1 downto 0);
       cout, zero, overflow, sign : out std_logic);
end entity;

architecture rtl of adder_generic is
  signal adder: unsigned(WIDTH downto 0);
  signal cinw: std_logic_vector(WIDTH downto 0);
  signal overflow_temp : std_logic;     -- pomocni signal kako bih mogao da manipulisem sa overflow-om u process-u
begin
  cin_edit:process(cin)
  begin
    cinw <= (others => '0');
    cinw(0) <= cin;
  end process;

  stat_signals:process(adder,a,b,cout) is
  begin
    if ((a(WIDTH-1) = b(WIDTH-1)) and a(WIDTH-1) /= adder(WIDTH))  then
      overflow_temp <= '1';
    else
      overflow_temp <= '0' ;
      if adder(WIDTH-1)= '1' then
        sign <= '1';
      end if;

      if adder(WIDTH-1 downto 0) = (others => '0') and overflow_temp = '0' then
        zero <= '1';
      end if;
   end if;
     
    cout <= adder(WIDTH);
      
  end process;
  
  adder <= unsigned('0' & a) + unsigned('0' & b) + unsigned(cinw);
  sum <= std_logic_vector(adder(WIDTH-1 downto 0));
  overflow <= overflow_temp;
end architecture;

