library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--when converting std_logic_vector to integer : to_integer(unsigned(my_std_logic_vector)
--when converting integer to std_logic_vector : std_logic_vector(to_unsigned(my_int, number_of_bits))

entity dec_counter999 is
  
  port (
    clk, en, reset : in  std_logic;
    q              : out std_logic_vector(9 downto 0);    --output of the counter
    p              : out std_logic);    -- pulse signal

end entity dec_counter999;

architecture rtl of dec_counter999 is

  signal sig1,sig2 : std_logic;         -- wiring signals
  signal q1,q2,q3  : std_logic_vector(3 downto 0);

begin  -- architecture rtl

  dec_counter_1: entity work.dec_counter
    port map (
      en    => en,
      rst   => reset,
      clk   => clk,
      q     => q1,
      pulse => sig1);

  dec_counter_2: entity work.dec_counter
    port map (
      en    => sig1,
      rst   => reset,
      clk   => clk,
      q     => q2,
      pulse => sig2);

  dec_counter_3: entity work.dec_counter
    port map (
      en    => sig2,
      rst   => reset,
      clk   => clk,
      q     => q3,
      pulse => p);

  q <= std_logic_vector(to_unsigned((to_integer(unsigned(q1)) + to_integer(unsigned(q2))*10 + to_integer(unsigned(q3))*100),10));
--ovo nije dobro jer ti fakticki sabirac posebno rezultat svakog brojaca umesto
--da ih lepis :S

end architecture rtl;
