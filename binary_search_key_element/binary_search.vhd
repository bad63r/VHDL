library ieee;
use ieee.std_logic_1164.all;

entity binary_search is
  
  generic (
    WIDTH : natural := 8);

  port (
    left_addr_in, right_addr_in : in  std_logic_vector(WIDTH-1 downto 0);
    key_in                      : in  std_logic_vector(7 downto 0);
    start                       : in  std_logic;
    middle_element              : in std_logic_vector(7 downto 0);
    el_found_out                : out std_logic;
    addr_middle                 : out std_logic_vector(WIDTH-1 downto 0);
    pos_out                     : out std_logic_vector(WIDTH-1 downto 0);
    ready                       : out std_logic);

end entity binary_search;

architecture rtl of binary_search is

  type state is (idle, load, s1, s2, s3, s4);
  signal current_state, next_state : state;
  signal middle_reg, middle_next : unsigned(8 downto 0);
  signal key_reg, key_next  : unsigned(7 downto 0);

begin  -- architecture rtl

  --controlpath:state register
  process (clk, reset) is
  begin  -- process
    if reset = '1' then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  --controlpath: next_state logic
  process (current_state, start) is
  begin  -- process
    case current_state is
      when idle =>
        if start = '1' then
          next_state <= load;
        else
          next_state <= idle;
        end if;
      when load =>
        if middle_next = key_reg then
          next_state <= s1;
        elsif middle_next > key_reg then
          next_state <= s2;
        elsif middle_next < key_reg then
          next_state <= s3;
        end if;
      when s1 =>
        next_state <= idle;
      when s2 =>
        if left_reg <= right_next then
          next_state <= load;
        else
          next_state <= s4;
        end if;
      when s3 =>
        if left_next <= right_reg then
          next_state <= load;
        else
          next_state <= s4;
        end if;
      when s4 =>
        next_state <= idle;
      when others => null;
    end case;
  end process;

  --controlpath: status signals
  el_found_out <= '1' when current_state = s4 else '0';
  ready        <= '1' when current_state = idle else '0';

  --datapath: registers
  process (clk, reset) is
  begin  -- process
    if reset = '1' then
      left_reg      <= (others => '0');
      right_reg     <= (others => '0');
      middle_reg    <= (others => '0');
      key_reg       <= (others => '0');
    elsif rising_edge(clk) then
      left_reg      <= left_next;
      right_reg     <= right_next;
      middle_reg    <= middle_next;
      key_reg       <= key_next;
    end if;
  end process;

  --datapath: routhing network
  process (current_state, middle_reg, key_reg, left_addr_in, right_addr_in, middle_element, key_in) is
  begin  -- process
    left_next   <= left_reg;
    right_next  <= right_reg;
    middle_next <= middle_reg;
    addr_middle <= (others => '0');
    key_next    <= key_reg;
    case current_state is
      when idle =>
        left_next   <= left_addr_in;
        right_next  <= right_addr_in;
        middle_next <= (others => '0');
      when load =>
        addr_middle <= ((left_reg + right_reg) / 2);
        key_next    <= key_in;
      when s1 =>
        pos_out <= (right_reg - addr_middle)
      when s2 =>
        right_next <= addr_middle - 1;
      when s3 =>
        left_next <= addr_middle + 1;
      when s4 =>
      when others => null;
    end case;
  end process;

  --datapath: output

end architecture rtl;
