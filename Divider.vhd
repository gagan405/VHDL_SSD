library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity divider is
generic ( M : integer := 6;
          N : integer := 4 );
port( A : in UNSIGNED(M-1 downto 0);
      B : in UNSIGNED(N-1 downto 0);
      Q : out unsigned (M-1 downto 0);
      R : out unsigned (M-1 downto 0);
      en : in bit;
      clk : in bit;
      reset_n : in bit;
      busy   : out bit
);
  
end;

architecture STRUCTURE of DIVIDER is

component DATA_PATH_DIV is
  generic( m : INTEGER; 
           n : INTEGER);
  port(
    CLK     : in BIT;
    RESET_N : in BIT;
    
    A       : in UNSIGNED(M-1 downto 0);              -- DIVIDEND
    B       : in UNSIGNED (N-1 downto 0);             -- DIVISOR
        
    EN_ADD  : in BIT;
    EN_SUB  : in BIT;
    EN_SH   : in BIT;
    MODE_SH : in BIT;
    EN_COMP : in BIT;
    
    EN_D    : in BIT;
    EN_TR   : in BIT;
    EN_Q    : in BIT;
    EN_N    : in BIT;
    EN_R    : in BIT;
    EN_TSH  : in BIT;
    EN_TADD : in BIT;
       
    SEL_SH  : in BIT_VECTOR(0 to 1);
    SEL_Q  : in BIT_VECTOR(0 to 1);
    SEL_COMP: in BIT;
    SEL_ADD : in BIT_VECTOR(0 to 1);
    SEL_SUB : in BIT_VECTOR(0 to 1);
    
    C       : out BIT;
    Q       : out UNSIGNED(M-1 downto 0);            -- QUOTIENT Q
    R       : out UNSIGNED(M-1 downto 0)           -- REMAINDER R  
  );
end component; 

component CONTROLLER is
  generic(M : INTEGER ;
          N : INTEGER );
  port(
    CLK     : in BIT;
    RESET_N : in BIT;
    C       : in BIT;
    en      : in BIT;
    
    EN_ADD  : out BIT;
    EN_SUB  : out BIT;
    EN_SH   : out BIT;
    EN_COMP : out BIT;
    MODE_SH : out BIT;
    EN_D    : out BIT;
    EN_R    : out BIT;
    EN_TR   : out BIT;
    EN_Q    : out BIT;
    EN_N    : out BIT;
    SEL_SH  : out BIT_VECTOR(0 to 1);
    SEL_Q  : out BIT_VECTOR(0 to 1);
    SEL_SUB : out BIT_VECTOR(0 to 1);
    SEL_COMP: out BIT;
    EN_TSH  : out BIT;
    EN_TADD : out BIT;
    SEL_ADD : out BIT_VECTOR(0 to 1);
    BUSY    : out BIT);
end component;


 signal   C       : BIT;
 signal   EN_ADD  : BIT;
 signal   EN_SUB  : BIT;
 signal   EN_SH   : BIT;
 signal   EN_COMP : BIT;
 signal   MODE_SH : BIT;
 signal   EN_D    : BIT;
 signal   en_dt   : bit;
 signal   en_tr   : bit;
 signal   EN_R    : BIT;
 signal   EN_TSH  : BIT;
 signal   EN_TADD : BIT;
 signal   EN_Q    : BIT;
 signal   EN_N    : BIT;
 signal   SEL_SH  : BIT_VECTOR(0 to 1);
 signal   SEL_Q  : BIT_VECTOR(0 to 1);
 signal   SEL_COMP: BIT;
 signal   sel_sub : bit_VECTOR(0 to 1);
 signal   SEL_ADD : BIT_VECTOR(0 to 1);
 
begin
  
  DP : DATA_PATH_DIV
  generic map ( M => M, N => N)
  port map(    
    clk     => clk,
    RESET_N => RESET_N,
    
    A       => A,              -- DIVIDEND
    B       => B,             -- DIVISOR
        
    EN_ADD  => EN_ADD,
    EN_SUB  => EN_SUB,
    EN_SH   => EN_SH,
    MODE_SH => MODE_SH,
    EN_COMP => EN_COMP,
    
    sel_sub => sel_sub,
    en_tr => en_tr,
    EN_D    => EN_D,
    EN_Q    => EN_Q,
    EN_N    => EN_N,
    EN_R    => EN_R,      
    SEL_SH  => SEL_SH,
    SEL_COMP => SEL_COMP,
    SEL_ADD => SEL_ADD,
    SEL_Q  => SEL_Q,
    EN_TSH => EN_TSH,
    EN_TADD => EN_TADD,
    C       => C,
    Q       => Q,           -- QUOTIENT Q
    R       => R          -- REMAINDER R  
  
  );
  
  CTRL : CONTROLLER 
  
  generic map(M => M, N => N)
  port map(
    CLK     => CLK,
    RESET_N => RESET_N,
    C       => C,
    EN      => EN,
    EN_ADD  => EN_ADD,
    EN_SUB  => EN_SUB,
    EN_SH   => EN_SH,
    MODE_SH => MODE_SH,
    EN_COMP => EN_COMP,
    EN_D    => EN_D,
    EN_Q    => EN_Q,
    EN_N    => EN_N,
    en_tr   => en_tr,
    sel_sub => sel_sub,
    EN_R    => EN_R,
    EN_TSH  => EN_TSH,
    EN_TADD => EN_TADD,
    SEL_SH  => SEL_SH,
    SEL_COMP => SEL_COMP,
    SEL_Q => SEL_Q,
    SEL_ADD => SEL_ADD,
    BUSY    => BUSY);
    
  
end STRUCTURE;