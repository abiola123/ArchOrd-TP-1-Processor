library ieee;
use ieee.std_logic_1164.all;
-- I ADDED THIS LIBRARY, ARE WE ALLOWED TO DO IT?
use ieee.numeric_std.all;

entity decoder is
	port(
		address : in  std_logic_vector(15 downto 0);
		cs_LEDS : out std_logic;
		cs_RAM  : out std_logic;
		cs_ROM  : out std_logic
	);
end decoder;

architecture synth of decoder is
	signal s_address            : unsigned(15 downto 0);
	constant c_ROM_upper_bound  : unsigned(15 downto 0) := to_unsigned(4092, 16);
	constant c_RAM_lower_bound  : unsigned(15 downto 0) := to_unsigned(4096, 16);
	constant c_RAM_upper_bound  : unsigned(15 downto 0) := to_unsigned(8188, 16);
	constant c_LEDS_lower_bound : unsigned(15 downto 0) := to_unsigned(8192, 16);
	constant c_LEDS_upper_bound : unsigned(15 downto 0) := to_unsigned(8204, 16);
begin
	s_address <= unsigned(address);
	cs_ROM    <= '1' when (s_address <= c_ROM_upper_bound) else '0';
	cs_RAM    <= '1' when (c_RAM_lower_bound <= s_address) and (s_address <= c_RAM_upper_bound) else '0';
	cs_LEDS   <= '1' when (c_LEDS_lower_bound <= s_address) and (s_address <= c_LEDS_upper_bound) else '0';
end synth;
