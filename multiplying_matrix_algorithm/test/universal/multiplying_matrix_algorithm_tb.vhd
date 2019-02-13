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

  --test
  signal data_test : std_logic_vector(WIDTH-1 downto 0);
  signal addr_test : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  --signals
  signal clk, reset : std_logic;
  --matrix A
  signal a_addr_o : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal a_data_i : std_logic_vector(WIDTH-1 downto 0);
  signal a_we_o   : std_logic;
  --matrix B
  signal b_addr_o : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal b_data_i : std_logic_vector(WIDTH-1 downto 0);
  signal b_we_o   : std_logic;
  --limiters
  signal n_in       : std_logic_vector(log2c(N)-1 downto 0);
  signal m_in       : std_logic_vector(log2c(M)-1 downto 0);
  signal p_in       : std_logic_vector(log2c(P)-1 downto 0);
  --start and ready signals
  signal start      : std_logic;
  signal ready      : std_logic;
  --matrix C
  signal c_add_o  : std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
  signal c_data_o : std_logic_vector(2*WIDTH+SIZE-1 downto 0);
  signal c_we_o   : std_logic;

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
  constant MEM_A_CONTENT : mem_t := (std_logic_vector(to_unsigned(0, WIDTH)),
                                     std_logic_vector(to_unsigned(6, WIDTH)),
                                     std_logic_vector(to_unsigned(6, WIDTH)),
                                     std_logic_vector(to_unsigned(9, WIDTH)),
                                     std_logic_vector(to_unsigned(6, WIDTH)),
                                     std_logic_vector(to_unsigned(0, WIDTH)),
                                     std_logic_vector(to_unsigned(7, WIDTH)),
                                     std_logic_vector(to_unsigned(3, WIDTH)),
                                     std_logic_vector(to_unsigned(5, WIDTH)));

  --constant that will be storage for memory B
  constant MEM_B_CONTENT : mem_t := (std_logic_vector(to_unsigned(7, WIDTH)),
                                     std_logic_vector(to_unsigned(1, WIDTH)),
                                     std_logic_vector(to_unsigned(4, WIDTH)),
                                     std_logic_vector(to_unsigned(2, WIDTH)),
                                     std_logic_vector(to_unsigned(5, WIDTH)),
                                     std_logic_vector(to_unsigned(8, WIDTH)),
                                     std_logic_vector(to_unsigned(6, WIDTH)),
                                     std_logic_vector(to_unsigned(3, WIDTH)),
                                     std_logic_vector(to_unsigned(3 WIDTH)));

  constant MEM_C_CONTENT : mem_t;

begin  -- architecture rtl

  --Matrix A memory
  RAM_memory_2ports_1: entity work.RAM_memory_2ports
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE*SIZE)
    port map (
      clk           => clk,
      address_in_p1 => mem_a_addr_in,
      data_in_p1    => mem_a_data_in,
      data_out_p1   => open,
      we_p1         => mem_a_we_in,
      address_in_p2 => a_addr_o,
      data_in_p2    => (others => '0'),
      data_out_p2   => a_data_i,
      we_p2         => a_we_o);

  --Matrix B memory
  RAM_memory_2ports_2: entity work.RAM_memory_2ports
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE*SIZE)
    port map (
      clk           => clk,
      address_in_p1 => mem_b_addr_in,
      data_in_p1    => mem_b_data_in,
      data_out_p1   => open,
      we_p1         => mem_b_we_in,
      address_in_p2 => b_addr_o,
      data_in_p2    => (others => '0'),
      data_out_p2   => b_data_i,
      we_p2         => b_we_o);

  --Matrix C memory
  RAM_memory_2ports_3: entity work.RAM_memory_2ports
    generic map (
      WIDTH => (2*WIDTH + SIZE),
      SIZE  => SIZE*SIZE)
    port map (
      clk           => clk,
      address_in_p1 => (others => '0'),
      data_in_p1    => (others => '0'),
      data_out_p1   => open,
      we_p1         => '0',
      address_in_p2 => c_add_o,
      data_in_p2    => c_data_o,
      data_out_p2   => open,
      we_p2         => c_we_o);
  
  --Matrix Multiply module
  multiplaying_matrix_algorithm_1: entity work.multiplaying_matrix_algorithm
    generic map (
      WIDTH => WIDTH,
      SIZE  => SIZE)
    port map (
      clk      => clk,
      reset    => reset,
      a_addr_o => a_addr_o,
      a_data_i => a_data_i,
      a_we_o   => a_we_o,
      b_addr_o => b_addr_o,
      b_data_i => b_data_i,
      b_we_o   => b_we_o,
      n_in     => n_in,
      m_in     => m_in,
      p_in     => p_in,
      start    => start,
      ready    => ready,
      c_add_o  => c_add_o,
      c_data_o => c_data_o,
      c_we_o   => c_we_o);

  --clock generator
  clk_gen: process is
  begin  -- process clk_gen
    clk <= '0', '1' after 5 ns;
    wait for 10 ns;
  end process clk_gen;

  --stimulus generator
  stim_gen: process is
  begin  -- process stim_gen
    reset <= '1', '0' after 50 ns;
    wait until falling_edge(clk);


    n_in <= std_logic_vector((to_unsigned(N, log2c(N))));
    m_in <= std_logic_vector((to_unsigned(M, log2c(M))));
    p_in <= std_logic_vector((to_unsigned(P, log2c(P))));



    --load data into matrix A memory
    mem_a_we_in <= '1';
    for i in 0 to N-1 loop
      for k in 0 to M-1 loop
        mem_a_addr_in <= std_logic_vector(to_unsigned(i*M + k, mem_a_addr_in'length));
        mem_a_data_in <= MEM_A_CONTENT(i*M + k);
        wait until falling_edge(clk);
      end loop;
    end loop;
    mem_a_we_in <= '0';

    for i in 0 to 8 loop
      addr_test <= std_logic_vector(to_unsigned(i, addr_test'length));
      wait until falling_edge(clk);
    end loop;



    --load data into matrix B memory
    mem_b_we_in <= '1';
    for k in 0 to M-1 loop
      for j in 0 to P-1 loop
        mem_b_addr_in <= std_logic_vector(to_unsigned(k*P + j, mem_b_addr_in'length));
        mem_b_data_in <= MEM_B_CONTENT(k*P + j);
        wait until falling_edge(clk);
      end loop;
    end loop;
    mem_b_we_in <= '0';

    start <= '1';
    wait until falling_edge(clk);
    start <= '0';

  wait;
  end process stim_gen;



end architecture rtl;
