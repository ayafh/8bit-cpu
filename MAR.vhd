library ieee; 
 use ieee.std_logic_1164.all ; 
 
 entity MAR is port ( 
RST    : in std_logic ; 
MARIen : in std_logic ;
CLK    : in std_logic  ;
MARIN : in std_logic_vector( 7 downto 0 ) ; 
MAROUT : out std_logic_vector( 7 downto 0 ) ); 
end entity ;

architecture MARarch of MAR is 
signal marreg : std_logic_vector ( 7 downto 0 ) ;
 begin 
 MARLOADING : process ( RST , CLK , MARIen ) 
   begin 
   if ( RST ='1') Then 
     marreg <= (others=>'0') ; 
   elsif ( Rising_edge (CLK) and MARIen = '1') Then 
          marreg <= MARIN ;   
   end if ; 
   end process ; 
  
 
   MAROUT <= marreg ; 
  
 end architecture MARarch ; 
  

