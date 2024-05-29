library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
 entity programcounter is port ( 
  RST : in std_logic ; 
  clk : in std_logic ; 
  inc : in std_logic ; 
  pc_in_en : in std_logic ; 
  addressin : in std_logic_vector(7 downto 0 ) ; 
  addressout : out std_logic_vector( 7 downto 0 ) ); 
 end entity ; 
 
 architecture archpc of programcounter is 
  signal pcsig : std_logic_vector(7 downto 0) ; 
  signal pcinc : std_logic_vector ( 1 downto 0 ) ; 
  begin 
   pcinc <= pc_in_en & inc ; 
  pc_process : process ( RST , clk ) 
  begin 
   if ( RST='1' ) then 
     pcsig <= ( others=>'0') ; 
     elsif ( rising_edge (clk)) then 
        if ( pcinc = "10") then 
        pcsig <= addressin ; 
        elsif ( pcinc = "01") then 
        pcsig <= std_logic_vector (unsigned(pcsig) + 1 ) ; 
        else pcsig <= pcsig ; 
        end if ; 
    else pcsig <= pcsig ;
   end if ;    
   end process ;  
    addressout <= pcsig ; 
    end architecture ; 
   