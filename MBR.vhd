library ieee; 
 use ieee.std_logic_1164.all ; 
 
 entity MBR is port ( 
RST    : in std_logic ; 
MBRIen : in std_logic ;
CLK    : in std_logic  ;
MBRIN : in std_logic_vector( 7 downto 0 ) ; 
MBROUT : out std_logic_vector( 7 downto 0 ) ); 
end entity ;

architecture MBRarch of MBR is 
signal mbrreg : std_logic_vector ( 7 downto 0 ) ;
 begin 
 MbRLOADING : process ( RST , CLK, MBRIen ) 
   begin 
   if ( RST ='1') Then 
     mbrreg <= (others=>'0') ; 
   elsif ( Rising_edge (CLK) and MBRIen = '1' ) Then 
     mbrreg <= MBRIN ;  
  end if ;
    end process ; 
  
 MBROUT <= mbrreg ;
  
 end architecture MBRarch ;