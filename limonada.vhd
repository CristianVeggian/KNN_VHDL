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

	constant attrNumber 	: integer := 8;
	constant xTreinoIDX	: integer := 4296;
	constant xTesteIDX	: integer := 6144;
	constant yTreinoIDX	: integer := 6681;
	constant yTesteIDX	: integer := 6912;
	constant ram_depth 	: integer := 8192;
	constant ram_width 	: integer := 32;

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
	
	pure function raizQ (vop  : unsigned(15 downto 0)  
								)
		variable vone : unsigned(15 downto 0);
		variable vres : unsigned(15 downto 0);  
	begin
			vone := to_unsigned(2**(14),16);
			vop  := unsigned(value);
			vres := (others=>'0'); 
			while (vone /= 0) loop
				if (vop >= vres+vone) then
					vop   := vop - (vres+vone);
					vres  := vres/2 + vone;
				else
					vres  := vres/2;
				end if;
				vone := vone/4;
			end loop;
			result <= vres(result'range);
			return result;
		end function;
	
	pure function euclides (ram_content: ram_type := ram;
									contador	  : unsigned
									) return unsigned is
		variable soma : unsigned;
		variable index: integer;
		variable sqrt : unsigned;
	begin
	
		for contTreino in 0 to 536 loop 
			for i in 0 to attrNumber - 1 loop
				index:= xTreinoIDX + 1 + i + to_integer(contador)*attrNumber;
				soma := soma + (unsigned(ram_content(index)) - unsigned(ram_content(i + contTreino*attrNumber)))*(unsigned(ram_content(index)) - unsigned(ram_content(i + contTreino*attrNumber)));
			end loop;
			sqrt := raizQ(soma);
		end loop;
	end function;
	
begin

	


end logic;
