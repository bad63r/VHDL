library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--my own package
use work.utils_pkg.all;

entity multiplaying_matrix_algorithm_tb is
  
end entity multiplaying_matrix_algorithm_tb;

architecture rtl of multiplaying_matrix_algorithm_tb is

  --constants
  constant WIDTH : natural := 8;
  constant SIZE  : natural := 3;
  constant N     : integer := 3;
  constant M     : integer := 3;
  constant P     : integer := 3;

  --signals
  signal clk, reset : std_logic;
  --matrix A
  signal a_addr_o_s : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal a_data_i_s : std_logic_vector(WIDTH-1 downto 0);
  signal a_we_o_s   : std_logic;
  --matrix B
  signal b_addr_o_s : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal b_data_i_s : std_logic_vector(WIDTH-1 downto 0);
  signal b_we_o_s   : std_logic;
  --limiters
  signal n_in       : std_logic_vector(log2c(SIZE)-1 downto 0);
  signal m_in       : std_logic_vector(log2c(SIZE)-1 downto 0);
  signal p_in       : std_logic_vector(log2c(SIZE)-1 downto 0);
  --start and ready signals
  signal start      : std_logic;
  signal ready      : std_logic;
  --matrix C
  signal c_add_o_s  : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal c_data_o_s : std_logic_vector(2*WIDTH+SIZE-1 downto 0);
  signal c_we_o_s   : std_logic;

  --signals for memory modules inside test bench
      --memory A
  signal mem_a_addr_in : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal mem_a_data_in : std_logic_vector(WIDTH-1 downto 0);
  signal mem_a_we_in   : std_logic;
      --memory B
  signal mem_b_addr_in : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal mem_b_data_in : std_logic_vector(WIDTH-1 downto 0);
  signal mem_b_we_in   : std_logic;
      --memory C
  signal mem_c_addr_in : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal mem_c_data_in : std_logic_vector(WIDTH-1 downto 0);
  signal mem_c_we_in   : std_logic;

  --creating type for memory
  type mem_t is array (0 to SIZE*SIZE-1) of std_logic_vector(WIDTH-1 downto 0);

  --constant that will be storage for memory A
  constant MEM_A_CONTENT : mem_t := (std_logic_vector(to_unsigned(5, WIDTH-1)),
                                     std_logic_vector(to_unsigned(9, WIDTH-1)),
                                     std_logic_vector(to_unsigned(7, WIDTH-1)),
                                     std_logic_vector(to_unsigned(3, WIDTH-1)),
                                     std_logic_vector(to_unsigned(1, WIDTH-1)),
                                     std_logic_vector(to_unsigned(8, WIDTH-1)),
                                     std_logic_vector(to_unsigned(2, WIDTH-1)),
                                     std_logic_vector(to_unsigned(8, WIDTH-1)),
                                     std_logic_vector(to_unsigned(2, WIDTH-1)));

  --constant that will be storage for memory B
  constant MEM_B_CONTENT : mem_t := (std_logic_vector(to_unsigned(5, WIDTH-1)),
                                     std_logic_vector(to_unsigned(9, WIDTH-1)),
                                     std_logic_vector(to_unsigned(7, WIDTH-1)),
                                     std_logic_vector(to_unsigned(3, WIDTH-1)),
                                     std_logic_vector(to_unsigned(7, WIDTH-1)),
                                     std_logic_vector(to_unsigned(1, WIDTH-1)),
                                     std_logic_vector(to_unsigned(8, WIDTH-1)),
                                     std_logic_vector(to_unsigned(2, WIDTH-1)),
                                     std_logic_vector(to_unsigned(2, WIDTH-1)));

begin  -- architecture rtl

  --creating memory modules
  clk_gen: process is
  begin  -- process clk_gen
    clk <= '0', '1' after 50 ns;
    wait for 100 ns;
  end process clk_gen;

  --stimulus generator
  stim_gen: process is
  begin  -- process stim_gen
    reset <= '1';
    wait for 500 ns;
    reset <= '0';
    wait until falling_edge(clk);

    --load data into matrix A memory
    mem_a_we_in <= '1';
    for i in 0 to N loop
      for k in 0 to M loop
        mem_a_addr_in <= std_logic_vector(to_unsigned(i*M + k, mem_a_addr_in'length));
        mem_a_data_in <= MEM_A_CONTENT(i*M + k);
        wait until falling_edge(clk);
      end loop;
    end loop;
    mem_a_we_in <= '0';

    --load data into matrix B memory
    mem_b_we_in <= '1';
    for k in 0 to M loop
      for j in 0 to P loop
        mem_b_addr_in <= std_logic_vector(to_unsigned(k*P + j, mem_b_addr_in'length));
        mem_b_data_in <= MEM_B_CONTENT(i*M + k);
        wait until falling_edge(clk);
      end loop;
    end loop;
    mem_b_we_in <= '0';

    start <= '1';
    wait until falling_edge(clk);
    start <= '0';

    --waint until matrix multiplication module signals operation has been complited
    wait until ready = '1';
  wait;
  end process stim_gen;

  --Matrix A memory
  RAM_memory_2ports_1: entity work.RAM_memory_2ports
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk           => clk,
      address_in_p1 => mem_a_addr_in,
      data_in_p1    => mem_a_data_in,
      data_out_p1   => open,
      we_p1         => mem_a_we_in,
      address_in_p2 => a_addr_o_s,
      data_in_p2    => open,
      data_out_p2   => a_data_i_s,
      we_p2         => a_we_o_s);

  --Matrix B memory
  RAM_memory_2ports_2: entity work.RAM_memory_2ports
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk           => clk,
      address_in_p1 => mem_b_addr_in,
      data_in_p1    => mem_b_data_in,
      data_out_p1   => open,
      we_p1         => mem_b_we_in,
      address_in_p2 => b_addr_o_s,
      data_in_p2    => open,
      data_out_p2   => a_data_i_s,
      we_p2         => b_we_o_s);

  --Matrix C memory
  RAM_memory_2ports_3: entity work.RAM_memory_2ports
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk           => clk,
      address_in_p1 => open,
      data_in_p1    => open,
      data_out_p1   => open,
      we_p1         => open,
      address_in_p2 => c_add_o_s,
      data_in_p2    => c_data_o_s,
      data_out_p2   => open,
      we_p2         => c_we_o_s);

  --Matrix Multiply module
  multiplaying_matrix_algorithm_1: entity work.multiplaying_matrix_algorithm
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk      => clk,
      reset    => reset,
      a_addr_o => a_addr_o_s,
      a_data_i => a_data_i_s,
      a_we_o   => a_we_o_s,
      b_addr_o => b_addr_o_s,
      b_data_i => b_data_i_s,
      b_we_o   => b_we_o_s,
      n_in     => n_in,
      m_in     => m_in,
      p_in     => p_in,
      start    => start,
      ready    => ready,
      c_add_o  => c_add_o_s,
      c_data_o => c_data_o_s,
      c_we_o   => c_we_o_s);


end architecture rtl;
