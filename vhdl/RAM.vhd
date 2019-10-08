library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	port(
		clk     : in  std_logic;
		cs      : in  std_logic;
		read    : in  std_logic;
		write   : in  std_logic;
		address : in  std_logic_vector(9 downto 0);
		wrdata  : in  std_logic_vector(31 downto 0);
		rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is
	type memory_type is array (0 to 1023) of std_logic_vector(31 downto 0);
	signal memory_block   : memory_type;
	signal s_address      : std_logic_vector(9 downto 0);
	signal s_output       : std_logic_vector(31 downto 0);
	signal s_enableBuffer : std_logic;
begin

	-- retrieving information from memory block
	s_output <= memory_block(to_integer(unsigned(s_address)));

	-- tri state buffer
	rddata <= s_output when s_enableBuffer = '1' else (31 downto 0 => 'Z');

	-- writing information into memory block
	writing : process(clk) is
	begin
		if (rising_edge(clk) and (write and cs) = '1') then
			memory_block(to_integer(unsigned(address))) <= wrdata;
		end if;
	end process writing;

	-- updating the address
	addressUpdate : process(clk) is
	begin
		if (rising_edge(clk)) then
			s_address <= address;
		end if;
	end process addressUpdate;

	-- updating s_enableBuffer
	bufferUpdate : process(clk) is
	begin
		if (rising_edge(clk)) then
			s_enableBuffer <= read and cs;
		end if;
	end process bufferUpdate;
end synth;
