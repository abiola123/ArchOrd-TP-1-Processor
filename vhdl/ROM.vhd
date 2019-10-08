library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is

  component ROM_Block is
    PORT
    (
      address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
      clock		: IN STD_LOGIC  := '1';
      q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  end component ROM_Block;

signal s_q : std_logic_vector(31 downto 0);

begin

  my_rom_block : ROM_Block
  PORT MAP(address => address,
          clock => clk ,
          q => s_q  );

	rddata <=  s_q when (read = '1' and cs = '1') else (31 downto 0 => 'Z');



end synth;
