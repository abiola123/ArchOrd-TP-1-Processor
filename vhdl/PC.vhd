library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
  signal s_counter_unsigned : unsigned(31 downto 0);
begin


    alt : process (clk,reset_n) is
      begin
        if(reset_n = '0') then
          s_counter_unsigned <= X"00000000";
        elsif(rising_edge(clk) and (en='1')) then
          s_counter_unsigned <= s_counter_unsigned + to_unsigned(4,32);
        end if;
    end process alt;

addr <= std_logic_vector(s_counter_unsigned);

end synth;
