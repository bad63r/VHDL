library ieee;
use ieee.std_logic_1164.all;

entity arbitar_fer is
  
  port (
    clk,reset,r0,r1: in std_logic;
    g0,g1: out std_logic);
    

end entity arbitar_fer;

architecture rtl of arbitar_fer is

  type moguca_stanja is (start,wait0,wait1, grant1, grant0);
  signal current_state, next_state : moguca_stanja;

  
begin  -- architecture rtl

  --state register
  rad_fsm: process(clk,reset)
  begin
    if reset = '1' then
      current_state <= start;
    else
      current_state <= next_state;
    end if;
  end process;

  --next-state logic
  dodela_stanja:process(current_state,r0,r1)
  begin
    if current_state = start then
      if (r1 = '0') and (r0 = '0') then
        next_state <= start;
      elsif r1 = '1' then
        next_state <= grant1;
      elsif (r1 = '0') and (r0 = '1') then
        next_state <= grant0;
      end if;
    elsif current_state = grant1 then
      if (r1 = '1') then
        next_state <= grant1;
      elsif (r1= '0') then
        next_state <= wait0;
      end if;
    elsif current_state = grant0 then
      if (r0 = '1') then
        next_state <= grant0;
      else
        next_state <= wait1;
      end if;
    elsif current_state = wait1 then
      if r1 = '1' then
        next_state <= grant1;
      elsif (r1 = '0') and (r0 = '1') then
        next_state <= grant0;
      else
        next_state <= wait1;
      end if;
    elsif current_state = wait0 then
      if r0 = '1' then
        next_state <= grant0;
      elsif (r0 = '0') and (r1 = '1') then
        next_state <= grant1;
      else
        next_state <= wait0;
      end if;
    end if;
    end process;

    --datapath routing network
    dekodovanje_stanja: process(current_state)
    begin
      case current_state is
        when grant1 =>
        g1 <= '1';
        g0 <= '0';
        when grant0 =>
        g1 <= '0';
        g0 <= '1';
        when start =>
        g1 <= '0';
        g0 <= '0';
        when wait0 =>
        g1 <= '0';
        g0 <= '0';
        when wait1 =>
        g1 <= '0';
        g0 <= '0';
        when others =>
        g1 <= '0';
        g0 <= '0';

        end case;
   end process;
    
end architecture rtl;
