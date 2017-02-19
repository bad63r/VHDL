entity datapath_primer is
  
  port (
    a_in, b_in : in  std_logic_vector(7 downto 0);
    control    : in  std_logic_vector(1 downto 0);
    r_out      : out std_logic_vector(15 downto 0);
    status     : out std_logic_vector(1 downto 0));

end entity datapath_primer;

architecture rtl of datapath_primer is

begin  -- architecture rtl

  

end architecture rtl;




