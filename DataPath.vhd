library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity DATA_PATH_DIV is
  generic( m,n : INTEGER );
  port(
    CLK     : in BIT;
    RESET_N : in BIT;
    
    A       : in UNSIGNED(M-1 downto 0);              -- DIVIDEND
    B       : in UNSIGNED (N-1 downto 0);             -- DIVISOR
        
    EN_ADD  : in BIT;
    --EN_DT   : in BIT;
    EN_SUB  : in BIT;
    EN_SH   : in BIT;
    MODE_SH : in BIT;
    --SH_LEN  : in INTEGER;
    EN_COMP : in BIT;
    
    --FL_INIT : in BIT;
    
    EN_D    : in BIT;
    EN_Q    : in BIT;
    EN_N    : in BIT;
    EN_R    : in BIT;
    EN_TR   : in BIT;
    EN_TSH  : in BIT;
    EN_TADD : in BIT;
       
    SEL_SH  : in BIT_VECTOR(0 to 1);
    SEL_Q   : in BIT_VECTOR(0 to 1);
    SEL_COMP: in BIT;
    SEL_ADD : in BIT_VECTOR(0 to 1);
    SEL_SUB : in BIT_VECTOR(0 to 1); 
    
    C       : out BIT;
    Q       : out UNSIGNED(M-1 downto 0);            -- QUOTIENT Q
    R       : out UNSIGNED(M-1 downto 0)           -- REMAINDER R  
  );
end;

architecture RTL of DATA_PATH_DIV is
  
  signal D : unsigned(A'RANGE);
  signal Qout, Rout,R1, n1, T_SH, T_ADD : unsigned(A'RANGE);
  
begin
  
  Q <= Qout;
  R <= Rout;
  
FILL_Q  : process(CLK, RESET_N)
  variable t1 : unsigned (A'RANGE) := (others => '0');
  variable t2 : unsigned (A'RANGE) := (others => '0');
  begin
  
  if RESET_N = '0' then
      Qout <= (others => '0');
      Rout <= (others => '0');
  elsif clk'event and clk = '1' then
      t2 := Qout;
      if en_q = '1' then
       case sel_q is
        when "00" => Qout <= t2;
        when "01" => Qout <= T_SH;
        when "10" => Qout <= T_ADD;
        when "11" => Qout <= t1;
       end case;  
      end if;
     if en_r = '1' then Rout <= R1; end if;
  end if; 
end process;

SHIFT : process(CLK, RESET_N)
 variable op : unsigned(A'RANGE) := (others => '0');
 variable op1 : unsigned(B'RANGE) := (others => '0');
 variable temp : unsigned(A'RANGE) := (others => '0'); 
 variable len : integer;
begin

 if RESET_N = '0' then
    D <= (others => '0');
 elsif clk'event and clk = '1' then 
  case sel_sh is 
   when "00" => op := Qout;
   when "01" => op := D; 
   when "10" => op1 := B;
   when "11" => op := (others => '0');
  end case;
  
  if en_sh = '1' then
    if mode_sh = '0' then
      if sel_sh = "10" then
        temp(A'LENGTH-1 downto M-N) := op1(B'LENGTH-1 downto 0);
      else temp(A'LENGTH-1 downto 1) := op(A'LENGTH-2 downto 0);
      end if;  
    else
      temp(A'LENGTH-2 downto 0) := op(A'LENGTH-1 downto 1);
    end if;  
  
  if en_d = '1' then  D <= temp; end if;
  if en_TSH = '1' then  T_SH <= temp;  end if; 
  temp := (others => '0');  
 end if;
end if; 
end process;

ADD : process(clk, reset_n)
variable op1 : integer;
variable op2 : integer;
variable res : integer; 
begin
  if reset_n = '0' then
    n1 <= (others => '0');
  elsif clk'event and clk = '1' then 
  
   case sel_add is
    when "00" => op1 := 0; op2 := 0;
    when "01" => op1 := conv_integer(n1); op2 := 1;
    when "10" => op1 := conv_integer(T_sh); op2 := 1;
    when "11" => op1 := 0; op2 := 0;
   end case;
  
  if en_add = '1' then
    res := op1 + op2;
    if en_n = '1' then n1 <= conv_unsigned(res, M); end if;
    if en_TADD = '1' then  T_ADD <= conv_unsigned(res, M); end if;
  end if;
end if;
end process;

COMP : process(clk, reset_n)
variable count : integer;
begin
  
  if reset_n = '0' then
    C <= '0';
  elsif clk'event and clk = '1' then
    if en_comp = '1' then
      if sel_comp = '0' then
        count := conv_integer(n1);
        if count > M - N then C <= '1';
        else C <= '0'; 
        end if;
      else
        if R1 >= D then C <= '1';
        else C <= '0';
        end if;
      end if;
    end if;
  end if;
  
end process;

SUB : process(clk, reset_n)
variable op1, op2 : unsigned(A'RANGE);
begin
  
  if reset_n = '0' then
   -- Rout <= (others => '0');
   R1 <= (others => '0');
  elsif clk'event and clk = '1' then
    case sel_sub is
    when "00" => op1 := A; op2 := conv_unsigned(0, M);
    when "01" => op1 := Rout; op2 := D;
    when "10" => op1 := Rout; op2 := D;
    when "11" => op1 := Rout; op2 := conv_unsigned(0, M);
    end case;
    if en_sub = '1' then
     if en_tr = '1' then R1 <= op1 - op2;  end if; 
    end if;
  end if;
end process;
end RTL;
