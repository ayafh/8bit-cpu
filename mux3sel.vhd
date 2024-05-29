library ieee;
use ieee.std_logic_1164.all; 

entity mux3sel is 
port ( 
 sel : in std_logic_vector ( 2 downto 0 ) ; 
 in0 : in std_logic_vector (  7 downto 0 ) ;
 in1 : in std_logic_vector (  7 downto 0 ) ;
 in2 :  in std_logic_vector ( 7 downto 0 ) ;
 in3 :  in std_logic_vector ( 7 downto 0 ) ; 
 in4 :  std_logic_vector ( 7 downto 0 ) ; 
 in5 :  in std_logic_vector ( 7 downto 0 ) ;
 in6 :  in std_logic_vector ( 7 downto 0 ) ; 
 in7 :  std_logic_vector ( 7 downto 0 ) ; 
 muxout : out std_logic_vector ( 7 downto 0 )  
 );
 end entity mux3sel ; 
 
 architecture archaccmux of mux3sel is 
  begin 
 process ( all )
  begin 
 case sel is                                                      
  when "000" => muxout <= in0 ;
  when "001" => muxout <= in1 ; 
  when "010" => muxout <= in2 ; 
  when "011" => muxout <= in3 ; 
  when "100" => muxout <= in4; 
  when others => muxout <=(others => 'Z'); 
  end case ; 
  end process ; 
  end architecture ; 