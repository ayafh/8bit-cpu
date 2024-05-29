library ieee; 
use ieee.std_logic_1164.all ;
use IEEE.NUMERIC_STD.ALL;
entity instructionreg is 
port ( 
clk : IN std_logic ; 
rst : IN std_logic ; 
WRregE : in std_logic ;
RDregE : in std_logic ; 
writeaddress : in std_logic_vector( 1 downto 0) ;---write address---
readaddress : in std_logic_vector( 1 downto 0) ;---read address---
fetcheddatareg : in std_logic_vector( 7 downto 0); 
regoutdata : out std_logic_vector( 7 downto 0) ); 
end entity ; 
architecture fileregarch of instructionreg is 
SUBTYPE REG is STD_LOGIC_VECTOR(7 DOWNTO 0); 
type Regfile is array (3 downto 0) of REG ;
signal RF : Regfile;
begin 
WRITEREG : process (clk , rst, RF, writeaddress ) 
begin 
 if ( rst ='1') then     
    RF <= (others=>(others => '0')); 
 else 
if rising_edge(clk ) then 
  if WRregE = '1' then 
RF(to_integer(unsigned(writeaddress))) <= fetcheddatareg ;    
  end if ; 
  end if ;
  end if ; 
  end process; 
 readingfrom : process ( RDregE , readaddress, rf ) 
    begin  
    if (RDregE ='1') then 
    regoutdata <= RF(to_integer(unsigned(readaddress))) ; 
    else 
    regoutdata <= (others => 'Z');
    end if ;
    end process ; 
  end architecture ; 

