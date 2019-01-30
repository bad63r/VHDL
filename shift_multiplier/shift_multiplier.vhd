library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_multiplier is
  
  generic (
    WIDTH : natural := 8);

  port (
    --Input data interface
    a_in, b_in : in  std_logic_vector(WIDTH-1 downto 0);
    --Command interface
    start      : in  std_logic;
    --Clock and reset interface
    clk, reset : in  std_logic;
    --Output data interface
    sum_out    : out std_logic_vector(2*WIDTH-1 downto 0);
    --Status interface
    ready      : out std_logic);

end entity shift_multiplier;

architecture rtl of shift_multiplier is

  --states of ASM
  type state is (idle, add, shift);
  signal current_state, next_state                   : state;
  --signals for data registers
  signal a_reg, a_next, b_reg, b_next, n_reg, n_next : unsigned(WIDTH-1 downto 0);
  signal p_reg, p_next                               : unsigned(2*WIDTH-1 downto 0);
  
begin  -- architecture rtl

  --controlpath register
  process(clk, reset)
  begin
    if reset = '1' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;
  
  --controlpath logic for generating next state
  process(current_state, start, n_next, b_next, b_in)
  begin
    case current_state is
      when idle =>
        if start = '1' then
          if b_in(0) = '1' then
            next_state <= add;
          else
            next_state <= shift;
          end if;
        else
          next_state <= idle;
        end if;
      when add =>
        next_state <= shift;
      when shift =>
        if n_next /= 0 then
          if b_next(0) = '1' then
            next_state <= add;
          else
            next_state <= shift;
          end if;
        else
          next_state <= idle;
        end if;
    end case;
  end process;


    --controlpath output logic
    ready <= '1' when (current_state = idle) else '0';

    --datapath registers
    process(clk, reset)
    begin
      if reset = '1' then
        a_reg <= (others => '0');
        b_reg <= (others => '0');
        n_reg <= (others => '0');
        p_reg <= (others => '0');
      elsif rising_edge(clk) then
        a_reg <= a_next;
        b_reg <= b_next;
        n_reg <= n_next;
        p_reg <= p_next;
      end if;
    end process;

    --datapath routing network
    process(current_state, a_in, b_in, a_reg, b_reg, n_reg, p_reg, n_next, b_next)
    begin
      case current_state is
        when idle =>
          a_next <= unsigned(a_in);
          b_next <= unsigned(b_in);
          n_next <= to_unsigned(WIDTH, WIDTH);
          p_next <= to_unsigned(0, 2*WIDTH);
        when add =>
          a_next <= a_reg;
          n_next <= n_reg;
          b_next <= b_reg;
          p_next <= p_reg + (to_unsigned(0, WIDTH) & a_reg);
        when shift =>
          a_next <= a_reg(WIDTH-2 downto 0) & '0';
          b_next <= '0' & b_reg(WIDTH-1 downto 1);
          n_next <= n_reg - 1;
          p_next <= p_reg;
      end case;
    end process;

    --system output
    sum_out <= std_logic_vector(p_reg);
                     

end architecture rtl;
