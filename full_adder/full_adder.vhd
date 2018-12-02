library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
  
  port (
    a, b : in  std_logic;
    cin  : in  std_logic;               -- carry in
    cout : out std_logic;               -- carry out
    sum  : out std_logic);              -- sum

end entity full_adder;

architecture beh of full_adder is

  signal s1, s2, s3 : std_logic;

begin  -- architecture beh

  half_adder_1: entity work.half_adder
    port map (
      a    => a,
      b    => b,
      sum  => s1,
      cout => s2);

  half_adder_2: entity work.half_adder
    port map (
      a    => cin,
      b    => s1,
      sum  => sum,
      cout => s3);

  cout <= s2 or s3;
end architecture beh;
