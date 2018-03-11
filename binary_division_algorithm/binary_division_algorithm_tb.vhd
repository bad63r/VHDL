library ieee;
use ieee.std_logic_1164.all;

entity binary_division_tb is
  
end entity binary_division_tb;

architecture rtl of binary_division_tb is

  constant WIDTH           : natural := 8;
  signal a_in, b_in        : std_logic_vector(WIDTH-1 downto 0);
  signal clk, reset        : std_logic;
  signal start             : std_logic;
  signal result, leftovers : std_logic_vector(WIDTH-1 downto 0);
  signal ready             : std_logic;

  
begin  -- architecture rtl

  binary_division_1: entity work.binary_division
    generic map (
      WIDTH => WIDTH)
    port map (
      a_in      => a_in,
      b_in      => b_in,
      clk       => clk,
      reset     => reset,
      start     => start,
      result    => result,
      leftovers => leftovers,
      ready     => ready);

    stim_gen_clk:process
    begin
      clk <= '0','1' after 25 ns;
      wait for 50 ns;
    end process;

  stim_gen:process
  begin
    reset <= '1','0' after 5 ns,'1' after 1500 ns;
    start <= '1', '0' after 30 ns;
    a_in  <= "00010000", "00000100" after 1000 ns;
    b_in  <= "00000010", "00001100" after 1000 ns;
    wait;
  end process;

end architecture rtl;
