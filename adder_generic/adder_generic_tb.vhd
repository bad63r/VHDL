library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sabirac_generic_tb is
  
end entity sabirac_generic_tb;

architecture rtl of sabirac_generic_tb is

  signal a_s,b_s : std_logic_vector(WIDTH-1 downto 0);
  signal cin_s : std_logic;
  signal sum_s : std_logic_vector(WIDTH-1 downto 0);
  signal cout_s,zero_s,overflow_s,sign_s : std_logic;

begin  -- architecture rtl

duv: entity work.sabirac_generic(rtl)
  generic map (WIDTH => 5)
  port map (a => a_s,
            b => b_s,
            cin => cin_s,
            sum => sum_s,
            cout => cout_s,
            zero => zero_s,
            overflow => overflow_s,
            sign => sign_s);


stim_gen: process is
begin
  a_s <= "00000","00001" after 100 ns,"00010" after 200 ns,"10001" after 300 ns, "10000" after 400 ns;
  
  b_s <= "00000","00001" after 100 ns,"00010" after 200 ns,"00101" after 300 ns, "10000" after 400 ns;

  cin_s <= '0';
  wait;
  end process;

end architecture rtl;
