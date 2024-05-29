library ieee; 
use ieee.std_logic_1164.all ; 
--use ieee.numeric.std.all ; 
entity toplevelup is 
generic (
 filepath : string:=  "C:\altera\91sp2\quartus\newprocessor\up\init ram\raminit.txt"  );
port (
clk , rst : std_logic ;
upout : out std_logic_vector (7 downto 0)); 
end entity ; 

architecture uparch of toplevelup is 

component instructionreg is 
port ( 
clk : IN std_logic ; 
rst : IN std_logic ; 
WRregE : in std_logic ;
RDregE : in std_logic ; 
writeaddress : in std_logic_vector( 1 downto 0) ;---write address---
readaddress : in std_logic_vector( 1 downto 0) ;---read address---
fetcheddatareg : in std_logic_vector( 7 downto 0); 
regoutdata : out std_logic_vector( 7 downto 0) ); 
end component ; 
component registerfile is 
port ( 
clk : IN std_logic ; 
rst : IN std_logic ; 
WRregE : in std_logic ;
RDregE : in std_logic ; 
writeaddress : in std_logic_vector( 2 downto 0) ;---write address---
readaddress : in std_logic_vector( 2 downto 0) ;---read address---
fetcheddatareg : in std_logic_vector( 7 downto 0); 
regoutdata : out std_logic_vector( 7 downto 0) ); 
end component ;
component alu is 
port(
accin : in std_logic_vector(7 downto 0); 
datasecin : in std_logic_vector(7 downto 0); 
opc : in std_logic_vector(3 downto 0); 
zr, carry , sgn , ovfl : out std_logic ; 
aluout : out std_logic_vector( 7 downto 0) );
 end component ;
 component flagsreg is 
port ( 
clk : in std_logic ; 
rst : in std_logic ; 
flags_load : in std_logic ;  
zr , sgn , carry , ovfl : in std_logic ; 
flagsout : out std_logic_vector ( 7 downto 0) ); 
end component ;
component programcounter is port ( 
  RST : in std_logic ; 
  clk : in std_logic ; 
  inc : in std_logic ; 
  pc_in_en : in std_logic ; 
  addressin : in std_logic_vector(7 downto 0 ) ; 
  addressout : out std_logic_vector( 7 downto 0 ) ); 
 end component ; 
component stackpointer is port ( 
RST    : in std_logic ; 
SPinen : in std_logic ;
PUSHEN:  in std_logic ;
popen : in std_logic ; 
CLK    : in std_logic  ;
SP_IN : in std_logic_vector( 7 downto 0 ) ; 
SP_OUT : out std_logic_vector( 7 downto 0 ) ); 
end component ;

component MAR is port ( 
RST    : in std_logic ; 
MARIen : in std_logic ;
CLK    : in std_logic  ;
MARIN : in std_logic_vector( 7 downto 0 ) ; 
MAROUT : out std_logic_vector( 7 downto 0 ) ); 
end component ;

component MBR is port ( 
RST    : in std_logic ; 
MBRIen : in std_logic ;
CLK    : in std_logic  ;
MBRIN : in std_logic_vector( 7 downto 0 ) ; 
MBROUT : out std_logic_vector( 7 downto 0 ) ); 
end component ;

component accumulator is port
(
	acc_in : in std_logic_vector(7 downto 0); 
	acc_out : out std_logic_vector(7 downto 0);
	data_in_en	 : in std_logic; -- data in enable
	RST : in std_logic;
	clk : in std_logic 
);
end component ;
component  myram IS
 generic (
 filepath : string );
 
PORT (  
 clk: IN STD_LOGIC;
 WE : IN STD_LOGIC;
 RDE: IN STD_LOGIC;
 ADDRESS :IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 DATA_IN: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
 DATA_OUT: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
 END component ; 
 
component mux2sel is 
port ( 
 sel : in std_logic_vector ( 1 downto 0 ) ; 
 in0 : in std_logic_vector (  7 downto 0 ) ;
 in1 : in std_logic_vector (  7 downto 0 ) ;
 in2 :  in std_logic_vector ( 7 downto 0 ) ;
 in3 :  in std_logic_vector ( 7 downto 0 ) ;  
 muxout : out std_logic_vector ( 7 downto 0 )  
 );
 end component mux2sel ;
 
 component mux1sel is 
port ( 
 sel : in std_logic_vector ( 0 downto 0 ) ; 
 in0 : in std_logic_vector (  7 downto 0 ) ;
 in1 : in std_logic_vector (  7 downto 0 ) ;  
 muxout : out std_logic_vector ( 7 downto 0 )  
 );
 end component mux1sel ; 
 
 component controlunit is 
port ( 
CLK : IN STD_LOGIC ; 
RST : IN STD_LOGIC ; 
FLAGSIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
CU_IN : IN STD_LOGIC_VECTOR( 7 DOWNTO 0); 
caccsel , cmbrsel , cmarsel , crfsel : out std_logic_vector ( 1 downto 0) ; --- mux select lines --
calusel : out std_logic_vector(0 downto 0) ;  -- mux select--- 
ramWR , ramRD, maren , mbren , pcen , spen , accen , rfWR , rfRD ,flagsen , irW , irR , inc_pc ,
push , pop : out std_logic ; --- enables 
rfwrite , rfread : out std_logic_vector (2 downto 0 ) ; --- rf address --
irwrite , irread : out std_logic_vector (1 downto 0); -- ir address --
aluopc : out std_logic_vector ( 3 downto 0)); 
end component ; 
  
 ---- signal ------- 
 signal accout , irout, ramout , rfout , pcout , mbroutsig , maroutsig , aluoutsig , spout , statusout   : std_logic_vector(7 downto 0); 
 signal muxtoacc , muxtorf , muxtombr , muxtomar , muxtoalu : std_logic_vector ( 7 downto 0); 
 signal zrsig , carrysig , ovflsig , sgnsig : std_logic ;  
 signal alubsel : std_logic_vector(0 downto 0); 
 signal accsel , rfsel , mbrsel , marsel : std_logic_vector ( 1 downto 0); 
 signal sramWR , sramRD, smaren , smbren , spcen , sspen , saccen , srfWR , srfRD ,sflagsen , sirW , sirR , sinc , spush , spop : std_logic ;
  signal srfread , srfwrite  : std_logic_vector (2 downto 0);
  signal sirwrite , sirread : std_logic_vector (1 downto 0 ); 
 signal sopc : std_logic_vector (3 downto 0);

begin 

instreg : instructionreg port map (clk => clk , rst => rst, WRregE=> sirw   ,RDregE => sirr , writeaddress=> sirwrite ,  readaddress=> sirread , fetcheddatareg => ramout , regoutdata => irout  );
rgfile :  registerfile port map   (clk =>clk , rst =>rst , WRregE=> srfwr ,RDregE => srfrd  , writeaddress=> srfwrite ,  readaddress=> srfread , fetcheddatareg => muxtorf, regoutdata => rfout );                           
aluwu : alu port map ( accin => accout , datasecin => muxtoalu , opc => sopc , zr => zrsig , carry => carrysig , sgn => sgnsig, ovfl => ovflsig , aluout => aluoutsig  ); 
flagsregister : flagsreg port map  ( clk=>clk , rst=>rst , flags_load => sflagsen , zr => zrsig , sgn =>sgnsig  , carry => carrysig , ovfl=> ovflsig , flagsout => statusout  );
pc : programcounter port map  ( Rst =>rst , clk =>clk , inc => sinc , pc_in_en => spcen , addressin => irout , addressout => pcout  ); 
sp : stackpointer port map  (rst =>rst , clk=>clk , Spinen => sspen , pushen => spush , popen => spop ,sp_in => irout , sp_out => spout ); 
marreg : mar port map ( rst => rst, clk=>clk , marien => smaren , marin => muxtomar , marout => maroutsig );
mbrreg : mbr port map ( rst =>rst, clk=>clk , mbrien =>smbren , mbrin => muxtombr , mbrout => mbroutsig );
acc : accumulator port map (rst =>rst , clk=>clk , data_in_en => saccen , acc_in => muxtoacc , acc_out => accout );
ram : myram generic map (filepath => filepath ) port map (clk => clk , RDE => sramrd , WE=> sramwr , ADDRESS => maroutsig , DATA_IN => mbroutsig , DATA_OUT => ramout);
alumux : mux1sel port map ( sel => alubsel , in0=> rfout , in1=> ramout , muxout => muxtoalu );
accmux : mux2sel port map (sel =>accsel , in0=>accout , in1=> rfout , in2=> aluoutsig , in3=> ramout , muxout =>muxtoacc );
rfmux : mux2sel port map (sel =>rfsel , in0=>accout , in1=> rfout , in2=> aluoutsig , in3=> ramout , muxout =>muxtorf );
marmux2 : mux2sel port map (sel =>marsel , in0=>spout , in1=> irout, in2=> pcout, in3=> ramout , muxout => muxtomar);
mbrmux2 : mux2sel port map (sel =>mbrsel , in0=>accout , in1=>rfout , in2=>pcout , in3=>statusout , muxout =>muxtombr ); 

cu : controlunit port map (clk => clk , rst => rst , Flagsin => statusout , cu_in => irout , caccsel=> accsel , cmbrsel => mbrsel , cmarsel=> marsel , crfsel=> rfsel ,
 calusel=> alubsel , ramWR =>sramwr , ramRD=> sramrd , maren=> smaren , mbren => smbren , pcen => spcen , spen=> sspen , accen => saccen ,push => spush , pop=> spop , rfWR =>srfwr  , rfRD => srfrd ,
 flagsen => sflagsen , irW=> sirw , irR => sirr , rfwrite => srfwrite , rfread=> srfread, irwrite=> sirwrite, irread=> sirread, aluopc => sopc , inc_pc=> sinc);
upout <= accout ; 
end architecture ; 
