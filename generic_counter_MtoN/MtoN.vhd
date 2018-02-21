library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MtoN is
  
  generic (
    M : natural := 3;
    N : natural := 9);

  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    q     : out std_logic_vector(3 downto 0));

end entity MtoN;

architecture rtl of MtoN is

  signal q_reg : unsigned(3 downto 0);
  signal q_next : unsigned(3 downto 0) := to_unsigned(M,4);

begin  -- architecture rtl

  c_reg: process (clk,reset) is
  begin  -- process c_reg
    if rising_edge(clk) then
      if reset = '1' then
        q_reg <= to_unsigned(M,4); 
      else
        q_reg <= q_next;
      end if;
    end if;
  end process c_reg;

  c_next: process (q_reg) is
  begin  -- process c_next
    if q_reg = N then
      q_next <= to_unsigned(M,4); 
    else
      q_next <= q_next + 1;
    end if;
  end process c_next;

  q <= std_logic_vector(q_reg);
end architecture rtl;
