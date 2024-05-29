library ieee; 
use ieee.std_logic_1164.all ; 
use ieee.numeric_std.all;
 
 entity stackpointer is port ( 
RST    : in std_logic ; 
SPinen : in std_logic ;
PUSHEN:  in std_logic ;
POPEN: in std_logic ;
CLK    : in std_logic  ;
SP_IN : in std_logic_vector( 7 downto 0 ) ; 
SP_OUT : out std_logic_vector( 7 downto 0 ) ); 
end entity ;

architecture SParch of stackpointer is 

component genericreg 
is port( 
RST    : in std_logic ; 
datainen : in std_logic ;
CLK    : in std_logic  ;
datain : in std_logic_vector( 7 downto 0 ) ; 
dataout: out std_logic_vector( 7 downto 0 ) ); 
end component ; 

signal loaden : std_logic_vector( 2 downto 0); 
signal load : std_logic ;
signal ptrin : std_logic_vector ( 7 downto 0) := "11111111" ; 
signal ptrout : std_logic_vector ( 7 downto 0); 


begin 
 
 loaden <= SPinen & PUSHEN & POPEN ; 
 
 with loaden select 
   ptrin <= sp_in when "100" ,
            std_logic_vector ( unsigned(ptrout)-1) when "010" , 
            std_logic_vector ( unsigned(ptrout)+1) when "001" ,
            "00000000" when others ; 
    load <= SPinen XOR PUSHEN XOR POPEN ;
   
stack_pointer : component genericreg port map (
RST    => RST  ,
datainen => load ,
CLK    => clk , 
datain => ptrin , 
dataout=> ptrout ); 

SP_OUT <= ptrout ; 

end architecture ; 