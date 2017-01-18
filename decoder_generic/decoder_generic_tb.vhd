library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_generic_tb is
  
end entity decoder_generic_tb;

architecture rtl of decoder_generic_tb is

  constant WIDTH : natural := 3;
  signal a    : std_logic_vector(WIDTH-1 downto 0);
  signal code : std_logic_vector(2**WIDTH-1 downto 0);

  
begin  -- architecture rtl

  decoder_generic_1: entity work.decoder_generic
    generic map (
      WIDTH => WIDTH)
    port map (
      a    => a,
      code => code);

  stim_gen: process is
  begin
  a <= "000","001" after 100 ns,"010" after 200 ns,"011" after 300 ns,"101" after 400 ns;
  wait;
  end process;

end architecture rtl;
