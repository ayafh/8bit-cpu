library ieee; 
use ieee.std_logic_1164.all ; 

 entity mux1sel is 
port ( 
 sel : in std_logic_vector ( 0 downto 0 ) ; 
 in0 : in std_logic_vector (  7 downto 0 ) ;
 in1 : in std_logic_vector (  7 downto 0 ) ;  
 muxout : out std_logic_vector ( 7 downto 0 )  
 );
 end entity mux1sel ; 
 architecture archamux of mux1sel is 
  begin 
 process ( sel , in0 , in1 )
  begin 
 case sel is                                                      
  when "0" => muxout <= in0 ;
  when "1" => muxout <= in1 ;
  when others => muxout <=(others => 'Z'); 
  end case ; 
  end process ; 
  end architecture ; 