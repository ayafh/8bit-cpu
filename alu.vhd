library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all  ; 
entity alu is 
port(
accin : in std_logic_vector(7 downto 0); 
datasecin : in std_logic_vector(7 downto 0); 
opc : in std_logic_vector(3 downto 0); 
zr, carry , sgn , ovfl : out std_logic ; 
aluout : out std_logic_vector( 7 downto 0) );
 end entity ;
architecture aluarch of alu is 
------ expend operands-------
signal  accinsig :unsigned (8 downto 0) ;
signal regdatainsig:unsigned(8 downto 0) ; 
signal  addsigcarry:std_logic_vector(8 downto 0) ;  
signal subsigcarry: std_logic_vector(8 downto 0) ; 
signal incrementac : std_logic_vector(8 downto 0) ;
signal decrementac : std_logic_vector(8 downto 0) ;
signal incrementbc : std_logic_vector(8 downto 0) ;
signal decrementbc  : std_logic_vector(8 downto 0) ;
-------------8bit sign excluding carry -------
signal addsig :std_logic_vector(7 downto 0) ;  
signal  subsig :std_logic_vector(7 downto 0) ;
signal  resultsig: std_logic_vector( 7 downto 0) ; 
signal incrementa : std_logic_vector (7 downto 0) ;
signal decrementa : std_logic_vector (7 downto 0) ;
signal incrementb : std_logic_vector (7 downto 0) ;
signal decrementb : std_logic_vector (7 downto 0) ;

------------ flags signals ------------
signal  negsigresult: std_logic ; 
signal  posigresult :std_logic ; 
 
begin 
------------arithmetic op -------------
accinsig <= unsigned ('0'& accin ); 
regdatainsig <= unsigned ('0'& datasecin ); 
addsigcarry <= std_logic_vector( accinsig + regdatainsig );  
subsigcarry <= std_logic_vector( accinsig - regdatainsig );  
addsig <= addsigcarry(7 downto 0); 
subsig <= subsigcarry(7 downto 0); 
incrementac <= std_logic_vector ( accinsig + 1 ) ; 
decrementac <= std_logic_vector ( accinsig - 1 ) ; 
incrementbc <= std_logic_vector ( regdatainsig + 1 ) ; 
decrementbc <= std_logic_vector ( regdatainsig -1  ) ; 
incrementa <= incrementac (7 downto 0);
decrementa <= decrementac (7 downto 0);
incrementb <= incrementbc (7 downto 0);
decrementb <= decrementbc(7 downto 0);
----------
             

with opc select 

resultsig <= addsig when "0000", --- a+b---
             subsig when "0001" ,---a-b---
             accin AND datasecin when "0010", --- a and b --
             accin OR  datasecin when "0011", ---a or b ---
             accin XOR datasecin when "0100", 
             accin NAND datasecin when "0101", 
             incrementa when "0110", -- inc a --
             decrementa when "0111", -- dec a --
             incrementb when "1000", -- inc b
             decrementb  when "1001",  -- dec b
             ('0'& accin(7 downto 1)) when "1010" ,  -- shift right --
             ( accin ( 6 downto 0) & '0' ) when "1011",  -- shift left -- 
             "00000000" when others ; 
        -------- assigning the flags ----- 
          ----1 the carry ----
             with opc select 
             carry <= addsigcarry(8) when "0000", ---carry ---
                      subsigcarry (8) when "0001", ---borrow---
                      incrementac (8) when "0110", 
                      decrementac (8) when "0111",
                      incrementbc (8) when "1000",
                      decrementbc(8) when "1001", 
                      '0' when others ; 
           ------2 theoverflow : occures in signed "addition" with positive argument neg result and vice versa ---
            negsigresult <= (NOT(ACCIN(7))) AND (NOT ( datasecin (7))) AND ((resultsig(7))); 
            posigresult <= (ACCIN(7)) AND( datasecin (7)) AND (NOT(resultsig (7))); 
            ovfl <= negsigresult OR posigresult when opc="0000" else '0' ; --- as mentioned befor for add only ---
            -----neg flag --- 
              sgn <= resultsig(7); --- high for neg sign ---- 
            --- zero flag ---- 
            zr <= '1' when resultsig = "00000000" else '0' ; 
           ---output --
                aluout <=resultsig ; 
     end aluarch ; 

  
       