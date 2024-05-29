library ieee; 
use ieee.std_logic_1164.all ; 
entity flagsreg is 
port ( 
clk : in std_logic ; 
rst : in std_logic ; 
flags_load : in std_logic ;  
zr , sgn , carry , ovfl : in std_logic ; 
flagsout : out std_logic_vector ( 7 downto 0) ); 
end entity ; 
architecture falgsarch of flagsreg is 
signal flags : std_logic_vector(7 downto 0 ); 
begin  
process (rst , clk )
begin 
if (rst='1') then 
flags <= (others=>'0');
else 
if (rising_edge(clk) and flags_load = '1') then 
flags <= (sgn)&(zr)&(carry)&(ovfl)&"0000" ; 
end if ; 
end if ;
end process ;
flagsout <= flags ; 
end architecture ; 