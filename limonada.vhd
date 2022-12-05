library IEEE;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use std.textio.all;

entity limonada is
	port(
		k	: in std_logic_vector(2 downto 0);
		res: out std_logic_vector(6 downto 0)
		);
end limonada;

architecture logic of limonada is

	constant attrNumber 	: natural := 8;
	constant xTreinoIDX	: natural := 4296;
	constant xTesteIDX	: natural := 6144;
	constant yTreinoIDX	: natural := 6681;
	constant yTesteIDX	: natural := 6912;
	constant ram_depth 	: natural := 8192;
	constant ram_width 	: natural := 32;

	type ram_type is array (0 to ram_depth - 1)
		of std_logic_vector(ram_width - 1 downto 0);

	impure function init_ram_hex return ram_type is
	  file text_file : text open read_mode is "ram_content_hex.txt";
	  variable text_line : line;
	  variable ram_content : ram_type;
	  variable c : character;
	  variable offset : integer;
	  variable hex_val : std_logic_vector(3 downto 0);
		begin
		  for i in 0 to ram_depth - 1 loop
			 readline(text_file, text_line);

			 offset := 0;

			 while offset < ram_content(i)'high loop
				read(text_line, c);

				case c is
				  when '0' => hex_val := "0000";
				  when '1' => hex_val := "0001";
				  when '2' => hex_val := "0010";
				  when '3' => hex_val := "0011";
				  when '4' => hex_val := "0100";
				  when '5' => hex_val := "0101";
				  when '6' => hex_val := "0110";
				  when '7' => hex_val := "0111";
				  when '8' => hex_val := "1000";
				  when '9' => hex_val := "1001";
				  when 'A' | 'a' => hex_val := "1010";
				  when 'B' | 'b' => hex_val := "1011";
				  when 'C' | 'c' => hex_val := "1100";
				  when 'D' | 'd' => hex_val := "1101";
				  when 'E' | 'e' => hex_val := "1110";
				  when 'F' | 'f' => hex_val := "1111";

				  when others =>
					 hex_val := "XXXX";
				end case;

				ram_content(i)(ram_content(i)'high - offset
				  downto ram_content(i)'high - offset - 3) := hex_val;
				offset := offset + 4;

			 end loop;
		  end loop;

		  return ram_content;
		end function;
	
	signal ram: ram_type := init_ram_hex;
	
	pure function euclides (ram_content: ram_type := ram;
									contador	  : unsigned
									) return unsigned is
		variable soma : unsigned;
	begin
	
		for contTreino in 0 to 536 loop 
			for i in 0 to attrNumber - 1 loop
				soma := soma + 1 sll (unsigned(ram_content(xTreinoIDX + 1 + i + contador*attrNumber)) - unsigned(ram_content(i + contTreino*attrNumber)));
			end loop;
		end loop;
	end function;
	
begin

	


end logic;
