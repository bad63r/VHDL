--zadatak 2.5 , vezbe 2

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_generic is
  
  generic (
    WIDTH : natural:= 3);

  port (
    a    : in  std_logic_vector(WIDTH-1 downto 0);
    code : out std_logic_vector(2**WIDTH-1 downto 0));

end entity decoder_generic;

architecture rtl of decoder_generic is

begin  -- architecture rtl

  pravljenje_komparatora:  for i in 0 to 2**WIDTH-1 generate
      code(i) <= '1' when a=std_logic_vector(to_unsigned(i,WIDTH)) else '0';  
    end generate;
    

                                             
    
end architecture rtl;
