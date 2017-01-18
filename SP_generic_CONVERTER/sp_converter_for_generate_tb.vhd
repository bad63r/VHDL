library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_converter_tb is
  
end entity sp_converter_tb;

architecture rtl of sp_converter_tb is

  constant WIDTH : natural := 8; 
  signal s_i : std_logic;
  signal clk : std_logic;
  signal p_o : std_logic_vector(WIDTH-1 downto 0);
  
begin  -- architecture rtl

  sp_converter_generic_1: entity work.sp_converter_generic
    generic map (
      WIDTH => WIDTH)
    port map (
      s_i => s_i,
      clk => clk,
      p_o => p_o);

  stim_gen_clk:process
    begin
    clk <= '0','1' after 25 ns;
    wait for 50 ns;
  end process;

  stim_gen:process
  begin
    s_i <= '0','1' after 30 ns, '1' after 80 ns, '0' after 130 ns, '1' after 170 ns, '1' after 239 ns,'0' after 280 ns,'1' after 340 ns,'0' after 390 ns,'0' after 426 ns, '1' after 480 ns,'1' after 545 ns,'0' after 580 ns,'0' after 640 ns, '1' after 690 ns, '1' after 743 ns,'0' after 760 ns,'1' after 840 ns; 
    wait;
    end process;
  

end architecture rtl;
