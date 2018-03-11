library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sqrt_algorithm is
  
  generic (
    WIDTH : natural := 32);

  port (
    x_in            : in  std_logic_vector(WIDTH-1 downto 0);
    clk, reset      : in  std_logic;
    start           : in  std_logic;
    ready           : out std_logic;
    result          : out std_logic_vector(WIDTH-1 downto 0));

end entity sqrt_algorithm;

architecture rtl of sqrt_algorithm is

  type state is (idle, i1, calc, finit, pra);
  signal current_state, next_state : state;
  signal op_reg, op_next, res_reg, res_next, one_reg, one_next : unsigned(WIDTH-1 downto 0);
begin  -- architecture rtl

  --controlpath: current state register
  process(clk,reset)
  begin
    if reset = '1' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  --controlpath logic for generating next state
  process(current_state, start, one_reg, op_reg, res_reg, one_next, op_next, res_next)
  begin
    case current_state is
      when idle =>
        if start = '1' then
          next_state <= i1; 
        else
          next_state <= idle;
        end if;
      when i1 =>
        if (one_next > op_reg) then 
          next_state <= i1;
        else
          if (op_next >= res_next + one_next) then
            next_state <= calc;
          else
            next_state <= finit;
          end if;
        end if;
      when calc =>
        next_state <= finit;
      when finit =>
        if (one_next /= 0) then
          if (op_next >= res_next + one_next) then
            next_state <= calc;
          else
            next_state <= finit;
          end if;
        else
          next_state <= idle;
        end if;
      when others => null;
    end case;
  end process;
  
  --controlpath output logic
  ready <= '1' when (current_state = idle) else '0';

  --datapath registers
  process(clk, reset)
  begin
    if reset = '1' then
      op_reg  <= (others => '0');
      res_reg <= (others => '0');
      one_reg <= (others => '0');
    elsif rising_edge(clk) then
      op_reg  <= op_next;
      res_reg <= res_next;
      one_reg <= one_next;
    end if;
  end process;

  --datapath routing network
  process(current_state, op_reg, op_next, res_next, res_reg, one_reg, one_next, x_in)
  begin
    case current_state is
      when idle =>
        op_next  <= unsigned(x_in);
        res_next <= to_unsigned(0, WIDTH); 
        one_next <= ("01" & to_unsigned(0, WIDTH-2)); 
      when i1 =>
        op_next  <= op_reg;
        res_next <= res_reg;
        one_next <= (to_unsigned(0,2) & one_reg(WIDTH-1 downto 2)); 
      when calc =>
        op_next  <= (op_reg - (res_reg + one_reg));
        res_next <= (res_reg + (one_reg(WIDTH-2 downto 0) & '0'));
        one_next <= one_reg;
      when finit =>
        op_next  <= op_reg;
        res_next <= ('0' & res_reg(WIDTH-1 downto 1));
        one_next <= ("00" & one_reg(WIDTH-1 downto 2));
      when others => null;
    end case;
  end process;

  --controlpath: output logic
result <= std_logic_vector(res_reg);


end architecture rtl;
