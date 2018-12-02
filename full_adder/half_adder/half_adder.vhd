library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
  
  port (
    a, b      : in  std_logic;
    sum, cout : out std_logic);

end entity half_adder;

architecture beh of half_adder is

begin  -- architecture beh

  adding: process (a, b) is
  begin  -- process adding
    sum <= a xor b;
    cout <= a and b;
  end process adding;

end architecture beh;
