library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_counter is
  generic (width: integer:= 8;
           max_count: std_logic:= 64;
           up_down:std_logic:=0); --  0 positive counting
                                    --  1 negative counting
  port(clk,rst,up_down: in std_logic;
       Q: out std_logic_vector( width - 1 downto 0));
       end entity generic_counter;


  architecture rtl of generic_counter is
    signal cnt_reg,cnt_next: unsigned(width - 1 downto 0);
    signal jedinica: unsigned ( width - 1 downto 0) := (others => '1');
    signal granica: unsigned (width - 1 downto 0)  := (others => '0');
  begin

    some <= to_signed(-45, 8);

    cnt_p: process is
    begin
      if rising_edge(clk) then
        if rst = '1' then
          cnt_reg <= (others => '0');
        else            
          cnt_reg <= cnt_next;
        end if;  
      end if;
      wait on clk,S1;
    end process;

    mux_p: process is
    begin
      if up_down = '0' then
        if cnt_reg = max_count then
          cnt_next <= (others => 0);
        else
          cnt_next <= cnt_reg +1;
        end if;
      else
        if cnt_reg = granica then
          cnt_next <= max_count;
        else
        cnt_next <= cnt_reg + jedinica;
      end if;
      end if;

      wait on cnt_reg, up_down;
    end process;


    Q <= std_logic_vector(cnt_reg);

    end architecture rtl;
