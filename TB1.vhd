library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity divider_str_tb is
  generic ( M : integer := 4;
            N : integer := 3 );
end;

architecture testbench_struct of divider_str_tb is
  
component divider is
  generic(M, N: natural);
      port(A: in unsigned(M-1 downto 0);
           B: in unsigned(N-1 downto 0);
           Q: out unsigned(M-1 downto 0);
           R: out unsigned(M-1 downto 0);
           EN : in BIT;
           reset_n : in BIT;
           CLK : in BIT;
           BUSY : out BIT);
end component;  

   signal A1: unsigned(M-1 downto 0);
   signal B1: unsigned(N-1 downto 0);
   signal Q1,Q2: unsigned(M-1 downto 0);
   signal R1,R2: unsigned(M-1 downto 0);
   
   signal clk : BIT := '0';
   signal reset_n : BIT := '0';
   signal check_busy : BIT;
   signal EN : BIT;
begin
   DIV1: divider generic map(M,N) port map(A1, B1, Q1, R1, en, reset_n, clk, check_busy);
 --  DIV2: divider_sh_sub generic map(M,N) port map(A1, B1, Q2, R2);

      reset_n <= '1' after 200 ns;
  
Clock_Generator : process(clk)
   begin
     if now < 41_000 NS then 
       clk <= not clk after 50 ns;
     end if;
end process;
   
process (reset_n, check_busy)
     variable quotient : integer;
     variable remainder : integer;
     variable done : bit := '0';
     variable a_temp : unsigned(A1'RANGE):= (others => '0');
     variable b_temp : unsigned(B1'RANGE):= (others => '0');
     variable Ain  : integer := (2**(M-1));
     variable Bin  : integer := (2**(N-1));
     variable Max_A: integer := (2**(M) - 1);
     variable Max_B: integer := (2**(N) - 1);
begin
      
            if reset_n = '0' then
              
              EN <= '1';
              A1 <= conv_unsigned(Ain, M);
              B1 <= conv_unsigned(Bin, N);
              
            elsif check_busy'event and check_busy = '0' then
            quotient := Ain / Bin;
            remainder := Ain rem Bin;  
            assert (( quotient = conv_integer(Q1)) 
                      and (remainder = conv_integer(R1)))
            report "wrong response to stimulus : A is " & integer'image(Ain) & " B is " & integer'image(Bin)
            severity WARNING; 
            
              if Ain = Max_A then 
                if Bin = Max_B then EN <= '0';
                else Bin := Bin + 1;
                end if;
              else 
                if Bin = Max_B then Bin := 2**(N-1);  Ain := Ain + 1; 
                else Bin := Bin + 1;
                end if;
              end if;
              
                A1 <= conv_unsigned(Ain, M);
                B1 <= conv_unsigned(Bin, N);
            
            end if;
end process;
  
end testbench_struct;