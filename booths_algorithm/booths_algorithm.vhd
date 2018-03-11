library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booth_algorithm is
  
  generic (
    WIDTH : natural := 8);

  port (
    a_in, b_in : in  std_logic_vector(WIDTH-1 downto 0);
    start      : in  std_logic;
    clk, reset : in  std_logic;
    ready      : out std_logic;
    res        : out std_logic_vector(2*WIDTH-1 downto 0));

end entity booth_algorithm;



architecture rtl of booth_algorithm is

  type state is (idle, for_init, i1, i2, i3, i4, final);
signal current_state, next_state : state;
signal A_reg, A_next             : signed(2*WIDTH downto 0);
signal S_reg, S_next             : signed(2*WIDTH downto 0);
signal P_reg, P_next             : signed(2*WIDTH downto 0);
signal res_reg, res_next         : signed(2*WIDTH-1 downto 0);

signal i_reg, i_next             : unsigned(3 downto 0) := (others => '0'); --variable in "for loop"
signal temp_reg, temp_next       : signed(2*WIDTH+1 downto 0);


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

--controlpath generating next_state logic
  process(start, A_reg, A_next, S_reg, S_next, P_reg, P_next, temp_next, temp_reg, i_reg, i_next, res_reg, res_next, current_state)
  begin
    case current_state is
      when idle =>
        if start = '1' then
          next_state <= for_init;
        else
          next_state <= idle;
        end if;
      when for_init =>
        if (P_reg(1 downto 0) = "01") then
          next_state <= i1;
        elsif (P_reg(1 downto 0) = "10") then
          next_state <= i2;
        elsif (P_reg(1 downto 0) = "00") then
          next_state <= i3;
        else
          next_state <= i4;
        end if;
      when i1 =>
        next_state <= final;
      when i2 =>
        next_state <= final;
      when i3 =>
        next_state <= final;
      when i4 =>
        next_state <= final;
      when final =>
        if ( i_next < 8) then
          if (P_next(1 downto 0) = "01") then
            next_state <= i1;
          elsif (P_next(1 downto 0) = "10") then
            next_state <= i2;
          elsif (P_next(1 downto 0) = "00") then
            next_state <= i3;
          else
            next_state <= i4;
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
      A_reg    <= (others => '0');
      S_reg    <= (others => '0');
      P_reg    <= (others => '0');
      res_reg  <= (others => '0');
      temp_reg <= (others => '0');
      i_reg    <= (others => '0');
    elsif rising_edge(clk) then
      A_reg    <= A_next;
      S_reg    <= S_next;
      P_reg    <= P_next;
      res_reg  <= res_next;
      temp_reg <= temp_next;
      i_reg    <= i_next;
    end if;
  end process;

--datapath routing network
  process(a_in, b_in, current_state, A_reg, A_next, S_next, S_reg, P_reg, P_next, temp_reg, temp_next, i_reg, i_next, res_reg, res_next)
  begin
    case current_state is
    when idle =>
      A_next    <= signed(a_in) & "000000000";
      S_next    <= (-signed(a_in)) & "000000000";
      P_next    <= "00000000" & signed(b_in) & '0';
      temp_next <= temp_reg;
      res_next  <= res_reg;
      i_next    <= i_reg;
    when for_init =>
      A_next    <= A_reg;
      S_next    <= S_reg;
      P_next    <= P_reg;
      temp_next <= (others => '0');           --18 bits bcs + of 2 operands of 17bits
                                              --can be max 18 bits
      res_next  <= res_reg;
      i_next    <= (others => '0');
    when i1 =>
      A_next    <= A_reg;
      S_next    <= S_reg;
      P_next    <= P_reg;
      temp_next <= to_signed(to_integer(P_reg + A_reg), 2*WIDTH+2);
      res_next  <= res_reg;
      i_next    <= i_reg;
    when i2 =>
      A_next    <= A_reg;
      S_next    <= S_reg;
      P_next    <= P_reg;
      temp_next <= to_signed(to_integer(P_reg + S_reg), 2*WIDTH+2);
      res_next  <= res_reg;
      i_next    <= i_reg;
    when i3 =>
      A_next    <= A_reg;
      S_next    <= S_reg;
      P_next    <= P_reg;
      temp_next <= to_signed(to_integer(P_reg), 2*WIDTH+2); 
      res_next  <= res_reg;
      i_next    <= i_reg;
    when i4 =>
      A_next    <= A_reg;
      S_next    <= S_reg;
      P_next    <= P_reg;
      temp_next <= to_signed(to_integer(P_reg), 2*WIDTH+2);
      res_next  <= res_reg;
      i_next    <= i_reg;
    when final =>
      A_next <= A_reg;
      S_next <= S_reg;
      P_next <= '0' & temp_reg(2*WIDTH+1 downto 1); --ovde je greska u zadatku?
      temp_next <= temp_reg;
      res_next  <= P_next(16 downto 1);
      i_next <= i_reg + 1;
    when others => null;
  end case;
end process;


--output logic
res <= std_logic_vector(res_reg);

end architecture rtl;
