library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is

  constant c_last_bit_one : std_logic_vector(32 downto 0) := X"00000000" & '1';
  signal s_sum : std_logic_vector(32 downto 0);
  signal s_b : std_logic_vector(31 downto 0);
  signal s_a_unsigned, s_b_unsigned : unsigned(32 downto 0);
    begin

      s_a_unsigned <= unsigned('0' &a);
      s_b_unsigned <= unsigned('0' & s_b);

        s_b <= b  when (sub_mode = '0')  else (not b);

      adder : process (s_a_unsigned,s_b_unsigned,sub_mode) is
        begin


          if(sub_mode = '1') then
            s_sum<= std_logic_vector(s_a_unsigned + s_b_unsigned + unsigned(c_last_bit_one));
          else
            s_sum <= std_logic_vector(s_a_unsigned + s_b_unsigned);
        end if;



      end process adder;

      carry <= s_sum(32);
      zero <= '1' when (s_sum(31 downto 0) = X"00000000") else '0' ;
      r <= s_sum(31 downto 0);
    end synth;
