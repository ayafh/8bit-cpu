library ieee; 
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all;   
use work.neededtools.all ;

entity controlunit is 
port ( 
CLK : IN STD_LOGIC ; 
RST : IN STD_LOGIC ; 
FLAGSIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
CU_IN : IN STD_LOGIC_VECTOR( 7 DOWNTO 0); 
caccsel , cmbrsel , cmarsel , crfsel : out std_logic_vector ( 1 downto 0) ; --- mux select lines --
calusel : out std_logic_vector(0 downto 0) ;   -- mux select--- 
ramWR , ramRD, maren , mbren , pcen , spen , accen , rfWR , rfRD ,flagsen , irW , irR , inc_pc,
push , pop   : out std_logic ; --- enables 
rfwrite , rfread : out std_logic_vector (2 downto 0 ) ; --- rf address --
irwrite , irread : out std_logic_vector (1 downto 0);
aluopc : out std_logic_vector ( 3 downto 0) );
end entity ; 
---------------------
architecture CUunit of controlunit is 
------ 
signal controlword: std_logic_vector ( 37 downto 0) ; ---38 control sig--- 7
signal current_instruction: std_logic_vector ( 7 downto 0) ;
signal next_cycle : boolean:=false ;
signal t_state :integer range 0 to 7;
type states is ( fetch0, decode, addimediate, addreg, adddirect, addindirect, 
 subimediate, subreg, subdirect, subindirect, LOADimediate, LOADreg, LOADdirect,
  LOADindirect, STRdirect, STRindirect, INCR ,
  DECR, SLAACC, SRAACC, ANDI, ANDREG, ANDDIRECT, ANDINDIRECT, ORI, ORREG, ORDIRECT, ORINDIRECT, 
 XORI, XORREG, XORDIRECT, XORINDIRECT, NANDI, NANDREG, NANDDIRECT, NANDINDIRECT,
 PUSHr, POPr, JUMP, JUMPC, JUMPNC, JUMPZ, JUMPNZ, halt,Nop, INCACC ,DECACC, pushacc , popacc, call , ret  );
signal state : states ;                                     
---------------                                             
begin                                                       
firstsec : process (RST , CLK,next_cycle,current_instruction )                             
 begin                                                
if RST='1' Then 
 state <= FETCH0 ;
elsif (falling_edge (clk) and next_cycle= true) then 
 case state is 
  when fetch0 => current_instruction<=CU_IN ;state <= decode ;  
  when decode =>   
      case current_instruction is 
     when "00000100" => state <= addimediate ; 
     when "00000101" => state <= addreg ; 
     when "00000110" => state <= adddirect ; 
     when "00000111" => state <= addindirect ; 
     when "00001000" => state <= subimediate ;
     when "00001001" => state <= subreg ; 
     when "00001010" => state <= subdirect ;
     when "00001011" => state <= subindirect ;
     when "00001100" => state <= LOADimediate ; 
     when "00001101" => state <= LOADreg ; 
     when "00001110" => state <= LOADdirect ; 
     when "00001111" => state <= LOADindirect ;  
     when "00010010" => state <= STRdirect ; 
     when "00010011" => state <= STRindirect ;
     when "00010101" => state <= INCR ;        
     when "00011001" => state <= DECR;
     when "00011101" => state <= SLAACC ; 
     when "00100001" => state <= SRAACC;
     when "00100100" => state <= ANDI;
     when "00100101" => state <= ANDREG;
     when "00100110" => state <= ANDDIRECT;
     when "00100111" => state <= ANDINDIRECT;
     when "00101000" => state <= ORI;
     when "00101001" => state <= ORREG;
     when "00101010" => state <= ORDIRECT;
     when "00101011" => state <= ORINDIRECT;
     when "00101100" => state <= XORI;
     when "00101101" => state <= XORREG;
     when "00101110" => state <= XORDIRECT;
     when "00101111" => state <= XORINDIRECT;
     when "00110000" => state <= NANDI;
     when "00110001" => state <= NANDREG;
     when "00110010" => state <= NANDDIRECT;
     when "00110011" => state <= NANDINDIRECT;
     when "00110101" => state <= PUSHr;
     when "00111001" => state <= POPr;
     when "00111100" => state <= JUMP;
     when "01000000" => state <= JUMPC;
     when "01000001" => state <= JUMPNC;
     when "01000100" => state <= JUMPZ;
     when "01000101" => state <= JUMPNZ;
     when "01000110" => state <= INCACC;
     when "01000111" => state <= DECACC; 
     when "01001000" => state <= pushacc; 
     when "01001001" => state <= popacc;
     when "01001010" => state <= call; 
     when "01001011" => state <= ret; --pop pc-- 
     WHEN "11111111" => state <= HALT;
     WHEN OTHERS => state <= NOP ;  
     end case ;
     
     when addimediate => state <=  FETCH0;
     when addreg      => state <=  FETCH0;
     when adddirect   => state <=  FETCH0;
     when addindirect => state <=  FETCH0;
     when subimediate => state <=  FETCH0;
     when subreg      => state <=  FETCH0;
     when subdirect   => state <=  FETCH0;
     when subindirect => state <=  FETCH0;
     when LOADimediate => state <= FETCH0;
     when LOADreg      => state <= FETCH0;
     when LOADdirect   => state <= FETCH0;
     when LOADindirect => state <= FETCH0;
     when STRdirect   => state <=  FETCH0;
     when STRindirect => state <=  FETCH0;
     when INCR         => state <= FETCH0;
     when DECR         => state <= FETCH0;
     when SLAACC     => state <=   FETCH0;
     when SRAACC     => state <=   FETCH0;
     when ANDI       => state <=   FETCH0;
     when ANDREG     => state <=   FETCH0;
     when ANDDIRECT  => state <=   FETCH0;
     when ANDINDIRECT => state <=  FETCH0;
     when ORI        => state <=   FETCH0;
     when ORREG      => state <=   FETCH0;
     when ORDIRECT   => state <=   FETCH0;
     when ORINDIRECT => state <=   FETCH0;
     when XORI       => state <=   FETCH0;
     when XORREG     => state <=   FETCH0;
     when XORDIRECT  => state <=   FETCH0;
     when XORINDIRECT => state <=  FETCH0;
     when NANDI       => state <=  FETCH0;
     when NANDREG     => state <=  FETCH0;    
     when NANDDIRECT   => state <= FETCH0;
     when NANDINDIRECT => state <= FETCH0;
     when PUSHr         => state <= FETCH0;
     when POPr          => state <= FETCH0;
     when JUMP         => state <= FETCH0;      
     when JUMPC         => state <= FETCH0;
     when JUMPNC       => state <= FETCH0;
     when JUMPZ         => state <= FETCH0;
     when JUMPNZ       => state <= FETCH0;
     when INCACC       => state <= FETCH0;
     when DECACC       => state <= FETCH0;
     when pushacc      => state <= FETCH0;
     when popacc       => state <= FETCH0;
     when call       => state <= FETCH0;
     when ret       => state <= FETCH0;
     when halt         => state <= halt;
     when others      => state <=  nop;
     end case ; --- the state case ---- 
     end if ;
     end process ; 
     
     process(clk,rst,controlword,next_cycle, t_state, state, CU_IN )
	begin
	if (rst='1') then t_state<=0;
	elsif(falling_edge(clk)) then if(next_cycle=false) then t_state<=t_state+1; 
										else t_state<=0; end if;
	end if;
	       
	controlword<=(others=>'0');
	next_cycle<=false; 
	
	case state is 
	when decode=>if(t_state=0)then next_cycle<=true; end if;
	when fetch0=>if(t_state=0)then controlword(35)<='1';controlword(4 downto 3)<="10";
				elsif(t_state=1)then controlword(30)<='1';controlword(24 downto 23)<="00";controlword(25)<='1';
				elsif(t_state=2)then controlword(28)<='1';controlword(27 downto 26)<="00";controlword(31)<='1';
				next_cycle<=true;end if;
				
	when incacc=>if(t_state=0)then controlword(14 downto 11)<="0110";controlword(36)<='1';controlword(8 downto 7)<="10";
				next_cycle<=true;end if;
	when decacc => if(t_state=0)then controlword(14 downto 11)<="0111";controlword(36)<='1';controlword(8 downto 7)<="10";
				next_cycle<=true;end if;
	when incr => if(t_state=0)then controlword(35)<='1';controlword(4 downto 3)<="10"; -- pc to mar --
				elsif (t_state=1) then controlword(30)<='1';controlword(25)<='1'; controlword(24 downto 23)<="01";  --ram to ir --
				elsif (t_state =2) then controlword(28)<='1';controlword(27 downto 26)<="01";controlword(31)<='1'; -- ir to cu and pc in --
				elsif (t_state =3) then controlword (22)<='1' ; controlword( 21 downto 19)<= CU_IN(2 downto 0) ; controlword(0 downto 0) <= "1" ; 
				elsif (t_state =4) then controlword(14 downto 11)<="1000"; controlword (18) <= '1'; controlword(17 downto 15) <= CU_IN(2 downto 0);
				 controlword(2 downto 1)<="10"; 
				next_cycle<=true;end if;
	when decr => if(t_state=0)then controlword(35)<='1';controlword(4 downto 3)<="10"; -- pc to mar --
				elsif (t_state=1) then controlword(30)<='1';controlword(25)<='1'; controlword(24 downto 23)<="01";  --ram to ir --
				elsif (t_state =2) then controlword(28)<='1';controlword(27 downto 26)<="01";controlword(31)<='1'; -- ir to cu and pc in --
				elsif (t_state =3) then controlword (22)<='1' ; controlword( 21 downto 19)<= CU_IN(2 downto 0) ; controlword(0 downto 0) <= "1" ; 
				elsif (t_state =4) then controlword(14 downto 11)<="1001"; controlword (18) <= '1'; controlword(17 downto 15) <= CU_IN(2 downto 0);
				 controlword(2 downto 1)<="10"; 
				next_cycle<=true;end if;
				 
	
	
	when halt=> next_cycle<=true ;
	when nop=> next_cycle<=true ;
	when others=>null;
	end case;
	end process;
	
	pcen <= controlword(37); 
	accen <= controlword(36);
	maren <= controlword(35);
	mbren <= controlword(34);
	spen <= controlword(33);
	flagsen <= controlword(32);
	inc_pc <= controlword(31) ;
	ramRD <= controlword(30);
	ramWR <= controlword(29);
	irR <= controlword(28);
	irread  <= controlword (27 downto 26);
	irW <= controlword(25);
	irwrite <=  controlword (24 downto 23); 
    rfRD <= controlword(22);
    rfread  <= controlword (21 downto 19 ); 
    rfWR <= controlword(18);
    rfwrite <= controlword (17 downto 15);
    aluopc <= controlword ( 14 downto 11) ;
    push <= controlword(10);
    pop <= controlword(9);  
    --- selector----
    caccsel <= controlword(8 downto 7);
    cmbrsel <= controlword(6 downto 5);
    cmarsel <= controlword(4 downto 3);
    crfsel <= controlword(2 downto 1);
    calusel <= controlword(0 downto 0); 
    
    
     end architecture ; 