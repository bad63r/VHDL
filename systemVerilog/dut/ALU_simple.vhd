LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;


ENTITY ALU IS
   GENERIC(
      WIDTH : NATURAL := 32);
   PORT(
      a_i    : in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0); --first input
      b_i    : in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0); --second input
      op_i   : in STD_LOGIC_VECTOR(2 DOWNTO 0); --operation select
      res_o  : out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0); --result
      zero_o : out STD_LOGIC); --zero flag      
END ALU;

ARCHITECTURE behavioral OF ALU IS

   constant  l2WIDTH : natural := integer(ceil(log2(real(WIDTH))));
   signal    lts_res,ltu_res,add_res,sub_res,or_res,and_res,res_s,xor_res  :  STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);
   signal    eq_res,sll_res,srl_res,sra_res : STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0);   

   
BEGin

   -- addition
   add_res <= std_logic_vector(unsigned(a_i) + unsigned(b_i));
   -- subtraction
   sub_res <= std_logic_vector(unsigned(a_i) - unsigned(b_i));
   -- and gate
   and_res <= a_i and b_i;
   -- or gate
   or_res <= a_i or b_i;
   -- xor gate
   xor_res <= a_i xor b_i;
   -- equal
   eq_res <= std_logic_vector(to_unsigned(1,WIDTH)) when (signed(a_i) = signed(b_i)) else
             std_logic_vector(to_unsigned(0,WIDTH));
   --shift results
   sll_res <= std_logic_vector(shift_left(unsigned(a_i), to_integer(unsigned(b_i(l2WIDTH downto 0)))));
   srl_res <= std_logic_vector(shift_right(unsigned(a_i), to_integer(unsigned(b_i(l2WIDTH downto 0)))));  

   -- SELECT RESULT
   res_o <= res_s;
   with op_i select
      res_s <= and_res when "000", --and
      or_res when "001", --or
      xor_res when "010", --xor
      add_res when "011", --add (changed opcode)
      sub_res when "100", --sub
      eq_res when "101", -- set equal      
      sll_res when "110", -- shift left logic
      srl_res when "111", -- shift right logic            
      (others => '1') when others; 


   -- flag outputs
   -- set zero output flag when result is zero
   zero_o <= '1' when res_s = std_logic_vector(to_unsigned(0,WIDTH)) else
             '0';


END behavioral;
