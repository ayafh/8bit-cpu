library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.neededtools.all;

ENTITY myram IS
 generic (
 filepath : string :=  "C:\altera\91sp2\quartus\newprocessor\up\init ram\raminit.txt"  ); --
 
PORT (  
 clk: IN STD_LOGIC;
 WE : IN STD_LOGIC;
 RDE: IN STD_LOGIC;
 ADDRESS :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 DATA_IN: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 DATA_OUT: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
 END myram ; 
ARCHITECTURE memoarch OF myram IS 
 SIGNAL myram: t_ram := init_ram(filepath); -- text file initilization 
 --ATTRIBUTE ram_init_file: STRING; --- for mif initilization
 -- ATTRIBUTE ram_init_file OF myram: SIGNAL IS filepath ; -- mif ini --
 BEGIN
 PROCESS (clk , data_in ,RDE,WE , myram , address )
 BEGIN 
 IF (clk'EVENT AND clk='1') THEN
 IF (WE='1') THEN
 myram(to_integer(unsigned(address))) <= data_in;end if;end if;
 IF ( RDE='1') THEN 
 data_out <= myram(to_integer(unsigned(address)));
 END IF; 
 END PROCESS;
 END ; 