library ieee;
use ieee.std_logic_1164.all; 

entity mux2sel is 
port ( 
 sel : in std_logic_vector ( 1 downto 0 ) ; 
 in0 : in std_logic_vector (  7 downto 0 ) ;
 in1 : in std_logic_vector (  7 downto 0 ) ;
 in2 :  in std_logic_vector ( 7 downto 0 ) ;
 in3 :  in std_logic_vector ( 7 downto 0 ) ;  
 muxout : out std_logic_vector ( 7 downto 0 )  
 );
 end entity mux2sel ; 
 
 architecture archaccmux of mux2sel is 
  begin 
 process ( sel , in0 , in1 , in2 , in3 )
  begin 
 case sel is                                                      
  when "00" => muxout <= in0 ;
  when "01" => muxout <= in1 ; 
  when "10" => muxout <= in2 ; 
  when "11" => muxout <= in3 ; 
  when others => muxout <=(others => 'Z'); 
  end case ; 
  end process ; 
  end architecture ; 