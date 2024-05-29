library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package neededtools is 

type t_ram is array ( 255 downto 0) of std_logic_vector(7 downto 0); 

pure function init_ram (file_placement : string ) return t_ram ; 

end package neededtools ; 

package body neededtools is 

	pure function init_ram(file_placement:string) return t_ram is
	variable i :integer:=0;
	variable output : t_ram;
	variable data_read : bit_vector(7 downto 0);  
	variable line_read : line ;
	file my_file: text open read_mode is file_placement;
	begin 
		while not endfile(my_file) loop
			readline(my_file, line_read);
			read(line_read, data_read);
			output(i):=to_stdlogicvector(data_read);
			if (i<255)then 
			i:=i+1;
			else exit;
			end if;
		end loop;
		return output;
	end function;
end package body neededtools ; 
