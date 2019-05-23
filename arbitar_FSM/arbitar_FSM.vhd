library ieee;
use ieee.std_logic_1164.all;

entity arbitar is
  
  port (
    clk,reset,r0,r1: in std_logic;
    g0,g1: out std_logic);
    

end entity arbitar;

architecture rtl of arbitar is

  type moguca_stanja is (waitr, grant1, grant0);
  signal current_state, next_state : moguca_stanja;

  
begin  -- architecture rtl

  --state register
  rad_fsm: process(clk, reset)
  begin
    if reset = '1' then
      current_state <= waitr;
    else
      current_state <= next_state;
    end if;
  end process;

  --next-state logic
  dodela_stanja:process(current_state, r0, r1)
  begin
    if current_state = waitr then
      if (r1 = '0') and (r0 = '0') then
        next_state <= waitr;
      elsif r1 = '1' then
        next_state <= grant1;
      elsif (r1 = '0') and (r0 = '1') then
        next_state <= grant0;
      end if;
    elsif current_state = grant0 then
      if (r0 = '1') then
        next_state <= grant0;
      elsif (r0 = '0') then
        next_state <= waitr;
      end if;
    elsif current_state = grant1 then
      if (r1 = '1') then
        next_state <= grant1;
      else
        next_state <= waitr;
      end if;
    end if;
    end process;

    --datapath routing network
    dekodovanje_stanja: process(current_state)
    begin
      case current_state is
        when grant0 =>
          g0 <= '1';
        when grant1 =>
          g1 <= '1';
        when others =>
          g0 <= '0';
          g1 <= '0';
      end case;
    end process;
    
end architecture rtl;
