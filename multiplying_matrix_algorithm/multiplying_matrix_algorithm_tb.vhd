library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.utils_pkg.all;

entity multiplying_matrix_algorithm_tb is
  
end entity multiplying_matrix_algorithm_tb;

architecture rtl of multiplying_matrix_algorithm_tb is

  constant WIDTH : integer := 8;
  constant SIZE : integer := 3;
  constant SIZE_mem : integer := SIZE*SIZE;

  type mem_type is array (0 to SIZE*SIZE-1) of std_logic_vector(WIDTH-1 downto 0);

  signal mem_a_data, mem_b_data : std_logic_vector(WIDTH-1 downto 0);

  signal clk      : std_logic;
  signal start    : std_logic;
  signal reset    : std_logic;
  signal ready    : std_logic;
  signal matrix_w : std_logic_vector(log2c(SIZE)-1 downto 0);
  --Memory A
  signal a_addr_o : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal a_data_i : std_logic_vector(WIDTH-1 downto 0);
  signal a_we_o   : std_logic;
  --Memory B
  signal b_addr_o : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal b_data_i : std_logic_vector(WIDTH-1 downto 0);
  signal b_we_o   : std_logic;
  --Memory C
  signal c_addr_o : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal c_data_o : std_logic_vector(2*WIDTH+SIZE-1 downto 0);
  signal c_we_o   : std_logic;


  constant MEM_A_CONTENT : mem_type := (std_logic_vector(to_unsigned(1, WIDTH)),
                                        std_logic_vector(to_unsigned(2, WIDTH)),
                                        std_logic_vector(to_unsigned(3, WIDTH)),
                                        std_logic_vector(to_unsigned(4, WIDTH)),
                                        std_logic_vector(to_unsigned(5, WIDTH)),
                                        std_logic_vector(to_unsigned(6, WIDTH)),
                                        std_logic_vector(to_unsigned(7, WIDTH)),
                                        std_logic_vector(to_unsigned(8, WIDTH)),
                                        std_logic_vector(to_unsigned(9, WIDTH))
                                        );


  constant MEM_B_CONTENT : mem_type := (std_logic_vector(to_unsigned(10, WIDTH)),
                                        std_logic_vector(to_unsigned(11, WIDTH)),
                                        std_logic_vector(to_unsigned(12, WIDTH)),
                                        std_logic_vector(to_unsigned(13, WIDTH)),
                                        std_logic_vector(to_unsigned(14, WIDTH)),
                                        std_logic_vector(to_unsigned(15, WIDTH)),
                                        std_logic_vector(to_unsigned(16, WIDTH)),
                                        std_logic_vector(to_unsigned(17, WIDTH)),
                                        std_logic_vector(to_unsigned(18, WIDTH))
                                        );

begin  -- architecture rtl

  multiplying_matrix_algorithm_1: entity work.multiplying_matrix_algorithm
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk      => clk,
      start    => start,
      reset    => reset,
      ready    => ready,
      matrix_w => matrix_w,
      a_addr_o => a_addr_o,
      a_data_i => a_data_i,
      a_we_o   => a_we_o,
      b_addr_o => b_addr_o,
      b_data_i => b_data_i,
      b_we_o   => b_we_o,
      c_addr_o => c_addr_o,
      c_data_o => c_data_o,
      c_we_o   => c_we_o);

  --Memory A
  RAM_memory_1: entity work.RAM_memory
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE_mem)
    port map (
      clk        => clk,
      address_in => a_addr_o,
      data_in    => mem_a_data,
      data_out   => a_data_i,
      we         => a_we_o);

  --Memory B
  RAM_memory_2: entity work.RAM_memory
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE_mem)
    port map (
      clk        => clk,
      address_in => b_addr_o,
      data_in    => mem_b_data,
      data_out   => b_data_i,
      we         => b_we_o);

  --Memory C
  RAM_memory_3: entity work.RAM_memory
    generic map (
      WIDTH => (2*WIDTH + SIZE),
      SIZE  => SIZE_mem)
    port map (
      clk        => clk,
      address_in => c_addr_o,
      data_in    => c_data_o,
      data_out   => open,
      we         => c_we_o);

  clk_gen: process is
  begin  -- process clk_gen
    clk <= '0', '1' after 10 ns;
    wait for 20 ns;
  end process clk_gen;

stim_gen: process is
 begin  -- process stim_gen
   matrix_w <= std_logic_vector(to_unsigned(3, log2c(SIZE)));
   reset <= '1', '0' after 500 ns;
   wait until falling_edge(clk);

   --Loading the data into memory A
   a_we_o <= '1';
   for i in 0 to SIZE*SIZE-1 loop
     a_addr_o <= std_logic_vector(to_unsigned(i, a_addr_o'length));
     mem_a_data <= MEM_A_CONTENT(i);
     wait until falling_edge(clk);
   end loop;
   a_we_o <= '0';

   --Loading the data into memory B
   b_we_o <= '1';
   for i in 0 to SIZE*SIZE-1 loop
     b_addr_o <= std_logic_vector(to_unsigned(i, b_addr_o'length));
     mem_b_data <= MEM_B_CONTENT(i);
     wait until falling_edge(clk);
   end loop;
   b_we_o <= '0';

   start <= '1';
   wait until falling_edge(clk);
   start <= '0';
   wait until ready = '1';
   wait;

 end process stim_gen; 















end architecture rtl;
