library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
  type state_type is (fetch1,fetch2,decode,r_op,store,break,load1,load2,i_op);
  signal s_current_state,s_next_state : state_type;

begin

flip_flop : process(clk,reset_n) is
  begin
    if(reset_n = '0') then
      s_current_state <= fetch1;
    elsif(rising_edge(clk)) then
      s_current_state<= s_next_state;
    end if;

  end process flip_flop;

output : process(s_current_state) is
  begin
    branch_op <= '0';
    imm_signed <= '0';
    ir_en <= '0';
    pc_add_imm <= '0';
    pc_en <= '0';
    pc_sel_a <= '0';
    pc_sel_imm <= '0';
    rf_wren <= '0';
    sel_addr <= '0';
    sel_b <= '0';
    sel_mem <= '0';
    sel_pc <='0';
    sel_ra <= '0';
    sel_rC <= '0';
    read <= '0';
    write <= '0';

    case s_current_state is
      when fetch1 =>
        read <= '1';
      when fetch2 =>
        pc_en <= '1';
      when i_op =>
        if(op = X"04") then
          imm_signed <= '1';
        end if;
      when r_op =>
        sel_b <= '1';
        sel_rC <= '1';
      when load1 =>
        read <= '1';
       if(op = X"17") then
        imm_signed <= '1';
       end if;
      when load2 =>
      if(op = X"17") then
       imm_signed <= '1';
      end if;
      when store =>
      if(op = X"15") then
         imm_signed <= '1';
      end if;




    end case;
  end process output;

  op_alu <= "100001" when ((op = X"3A") AND (opx = X"0E")) else
            "110011" when ((op = X"3A") AND (opx = X"1B")) else
            "000000" when ((op = X"04") OR (op = X"17") OR (op = X"15")) else
            "110011" when ((op = X"3A") AND (opx = X"1B"));

  s_next_state <= fetch2 when s_current_state = fetch1 else
                  decode when s_current_state = fetch2 else
                  r_op when ((s_current_state = decode) and (op = X"3A") and (opx = X"0E")) else
                  i_op when ((s_current_state = decode) and (op = X"04")) else
                  load1 when ((s_current_state = decode) and (op = X"17")) else
                  store when ((s_current_state = decode) and (op = X"15")) else
                  break when ((s_current_state = break) or ((s_current_state=decode) and (op = X"3A") and (opx = X"34"))) else
                  load2 when s_current_state = load1 else
                  fetch1 when ((s_current_state = r_op) or (s_current_state = store) or (s_current_state = load2) or (s_current_state = i_op));



end synth;
