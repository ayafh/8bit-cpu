library ieee; 
use ieee.std_logic_1164.all ; 
use ieee.numeric_std.all;
 
 entity genericreg is port ( 
RST    : in std_logic ; 
datainen : in std_logic ;
CLK    : in std_logic  ;
datain : in std_logic_vector( 7 downto 0 ) ; 
dataout: out std_logic_vector( 7 downto 0 ) ); 
end entity ;

architecture archgenreg of genericreg is 

signal datasig : std_logic_vector ( 7 downto 0);
begin 
 
LOADING : process ( RST , CLK ) 
   begin 
   if ( RST ='1') Then 
    datasig <= (others=>'0') ; 
   elsif ( Rising_edge (CLK) AND datainen ='1' ) Then 
     datasig <= datain ; 
     end if; 
  end process ;
  dataout <= datasig; 
  end architecture ;
 