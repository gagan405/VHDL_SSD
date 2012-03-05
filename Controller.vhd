library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity CONTROLLER is
  generic(M,N : INTEGER);
  port(
    CLK     : in BIT;
    RESET_N : in BIT;
    C       : in BIT;
    EN      : in BIT;
    
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
    EN_TSH  : out BIT;
    EN_TADD : out BIT;
    SEL_SH  : out BIT_VECTOR(0 to 1);
    SEL_Q   : out BIT_VECTOR(0 to 1);
    SEL_COMP: out BIT;
    SEL_ADD : out BIT_VECTOR(0 to 1);
    SEL_SUB : out BIT_VECTOR(0 to 1);
    BUSY    : out BIT
  );
end;

architecture RTL of CONTROLLER is

  type T_STATE is (S0, S1, S2, S3, S4, S5 );
  signal STATE : T_STATE;
  
begin

FSM : process( CLK, RESET_N )
begin
   if RESET_N = '0' then
     STATE <= S0;
   elsif CLK'EVENT and CLK = '1' then
     if EN = '1' then
      case STATE is
        when S0 => STATE <= S1;
        when S1 => STATE <= S2;
        when S2 => STATE <= S3;
        when S3 => 
           if C = '0' then STATE <= S4;
           else STATE <= S5;
           end if;
        when S4 => 
          if C = '0' then STATE <= S2;
          else STATE <= S0;
          end if;
        when S5 =>
          if C = '0' then STATE <= S2;
          else STATE <= S0;
        end if;
      end case;
     else
      STATE <= S0;
    end if;
    end if;
end process;
 
COMB : process( STATE )
begin
    case STATE is
      when S1 =>
          EN_ADD  <= '1';
          EN_SUB  <= '1';
          EN_SH   <= '1';
          EN_COMP <= '0';
          MODE_SH <= '0';
          EN_D    <= '1';
          EN_Q    <= '1';
          EN_N    <= '1';
          EN_R    <= '0';
          en_tr   <= '1';
          SEL_SH  <= "10";
          SEL_COMP<= '0';
          SEL_ADD <= "00";
          sel_sub <= "00";
          sel_q   <= "11";
          en_tsh  <= '0';
          en_tadd <= '0';
          busy    <= '1';

      when S2 =>
          EN_ADD  <= '1';
          EN_SUB  <= '0';
          EN_SH   <= '1';
          EN_COMP <= '1';
          MODE_SH <= '0';
          EN_D    <= '0';
          EN_Q    <= '0';
          EN_N    <= '1';
          en_r    <= '1';
          en_tr   <= '0';
          SEL_SH  <= "00";
          SEL_COMP<= '1';
          SEL_ADD <= "01";
          sel_sub <= "00";
          sel_q   <= "11";
          en_tsh  <= '1';
          en_tadd <= '0';
          busy    <= '1';
          
      when S3 =>
          EN_ADD  <= '1';
          EN_SUB  <= '1';
          EN_SH   <= '1';
          EN_COMP <= '1';
          MODE_SH <= '1';
          EN_D    <= '1';
          EN_Q    <= '0';
          EN_N    <= '0';
          en_r    <= '0';
          en_tr   <= '1';
          SEL_SH  <= "01";
          SEL_COMP<= '0';
          SEL_ADD <= "10";
          sel_sub <= "01";
          sel_q   <= "11";
          en_tsh  <= '0';
          en_tadd <= '1';
          busy    <= '1';
                   
      when S4 =>
          EN_ADD  <= '0';
          EN_SUB  <= '1';
          EN_SH   <= '0';
          EN_COMP <= '0';
          MODE_SH <= '0';
          EN_D    <= '0';
          EN_Q    <= '1';
          EN_N    <= '0';
          en_r    <= '0'; 
          en_tr   <= '1';
          SEL_SH  <= "00";
          SEL_COMP<= '0';
          SEL_ADD <= "00";
          sel_sub <= "11";
          sel_q   <= "01";
          en_tsh  <= '0';
          en_tadd <= '0';
          busy    <= '1';
          
      when S5 =>
          EN_ADD  <= '0';
          EN_SUB  <= '0';
          EN_SH   <= '0';
          EN_COMP <= '0';
          MODE_SH <= '0';
          EN_D    <= '0';
          EN_Q    <= '1';
          EN_N    <= '0';
          en_r    <= '1'; 
          en_tr   <= '0';
          SEL_SH  <= "00";
          SEL_COMP<= '0';
          SEL_ADD <= "00";
          sel_sub <= "00";
          sel_q   <= "10";
          en_tsh  <= '0';
          en_tadd <= '0';
          busy    <= '1';
 
       when OTHERS =>
          EN_ADD  <= '0';
          EN_SUB  <= '0';
          EN_SH   <= '0';
          EN_COMP <= '0';
          MODE_SH <= '0';
          EN_D    <= '0';
          EN_Q    <= '0';
          EN_N    <= '0';
          en_r    <= '0';
          SEL_SH  <= "00";
          SEL_COMP<= '0';
          SEL_ADD <= "00";
          sel_sub <= "00";
          sel_q   <= "00";
          en_tsh  <= '0';
          en_tadd <= '0';
          busy    <= '0';
               
    end case;
end process;
    
end RTL;
