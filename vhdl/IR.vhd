library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)
    );
end IR;

architecture synth of IR is
  signal s_D_next : std_logic_vector(31 downto 0);
begin

  s_D_next <= D;

  alt : process(clk,enable) is
    begin
      if(rising_edge(clk)) then
        if(enable='1') then
           Q<=s_D_next;
        end if;
      end if;
  end process alt;

end synth;
