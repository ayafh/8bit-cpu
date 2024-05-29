library ieee;
use ieee.std_logic_1164.all;

entity accumulator is port
(
	acc_in : in std_logic_vector(7 downto 0); 
	acc_out : out std_logic_vector(7 downto 0);
	data_in_en	 : in std_logic; -- data in enable
	RST : in std_logic;
	clk : in std_logic 
);
end accumulator ;

architecture accarch of accumulator is
	signal reg : std_logic_vector(7 downto 0);
begin
	acc_reg : process (clk , RST, data_in_en)
	begin
	   if (RST = '1') then
			reg <= (others =>'0');
		 elsif (rising_edge(clk) and data_in_en = '1') then
				reg <= acc_in ; 
		 end if;
	end process acc_reg;
	 acc_out <= reg ; 
end architecture accarch;