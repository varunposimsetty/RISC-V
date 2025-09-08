
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port(
        i_opcode  : in  std_ulogic_vector(6 downto 0);
        i_func7   : in  std_ulogic_vector(6 downto 0);
        i_func3   : in  std_ulogic_vector(2 downto 0);
        i_z       : in  std_ulogic;
        o_aluc    : out std_ulogic_vector(4 downto 0);
        o_alui    : out std_ulogic_vector(1 downto 0);
        o_pcsrc   : out std_ulogic_vector(1 downto 0);
        o_m2reg   : out std_ulogic;
        o_bimm    : out std_ulogic;
        o_call    : out std_ulogic;
        o_wreg    : out std_ulogic;
        o_wmem    : out std_ulogic
    );
end entity ControlUnit;

architecture RTL of ControlUnit is
    -- RV32I instruction decode
    signal i_lui, i_jal, i_jalr, i_beq, i_bne, i_lw, i_sw,
           i_addi, i_xori, i_ori, i_andi, i_slli, i_srli, i_srai,
           i_add, i_sub, i_slt, i_xor, i_or, i_and : std_ulogic;
    -- RV32M
    signal i_mul, i_mulh, i_mulhsu, i_mulhu, i_div, i_divu, i_rem, i_remu : std_ulogic;
begin

    -- Instruction decoding using exact bit matching
    i_lui   <= '1' when i_opcode = "0110111" else '0';
    i_jal   <= '1' when i_opcode = "1101111" else '0';
    i_jalr  <= '1' when (i_opcode = "1100111" and i_func3 = "000") else '0';
    i_beq   <= '1' when (i_opcode = "1100011" and i_func3 = "000") else '0';
    i_bne   <= '1' when (i_opcode = "1100011" and i_func3 = "001") else '0';
    i_lw    <= '1' when i_opcode = "0000011" else '0';
    i_sw    <= '1' when i_opcode = "0100011" else '0';
    i_addi  <= '1' when (i_opcode = "0010011" and i_func3 = "000") else '0';
    i_xori  <= '1' when (i_opcode = "0010011" and i_func3 = "100") else '0';
    i_ori   <= '1' when (i_opcode = "0010011" and i_func3 = "110") else '0';
    i_andi  <= '1' when (i_opcode = "0010011" and i_func3 = "111") else '0';
    i_slli  <= '1' when (i_opcode = "0010011" and i_func3 = "001" and i_func7 = "0000000") else '0';
    i_srli  <= '1' when (i_opcode = "0010011" and i_func3 = "101" and i_func7 = "0000000") else '0';
    i_srai  <= '1' when (i_opcode = "0010011" and i_func3 = "101" and i_func7 = "0100000") else '0';
    i_add   <= '1' when (i_opcode = "0110011" and i_func3 = "000" and i_func7 = "0000000") else '0';
    i_sub   <= '1' when (i_opcode = "0110011" and i_func3 = "000" and i_func7 = "0100000") else '0';
    i_slt   <= '1' when (i_opcode = "0110011" and i_func3 = "010" and i_func7 = "0000000") else '0';
    i_xor   <= '1' when (i_opcode = "0110011" and i_func3 = "100" and i_func7 = "0000000") else '0';
    i_or    <= '1' when (i_opcode = "0110011" and i_func3 = "110" and i_func7 = "0000000") else '0';
    i_and   <= '1' when (i_opcode = "0110011" and i_func3 = "111" and i_func7 = "0000000") else '0';

    -- RV32M
    i_mul     <= '1' when (i_opcode = "0110011" and i_func3 = "000" and i_func7 = "0000001") else '0';
    i_mulh    <= '1' when (i_opcode = "0110011" and i_func3 = "001" and i_func7 = "0000001") else '0';
    i_mulhsu  <= '1' when (i_opcode = "0110011" and i_func3 = "010" and i_func7 = "0000001") else '0';
    i_mulhu   <= '1' when (i_opcode = "0110011" and i_func3 = "011" and i_func7 = "0000001") else '0';
    i_div     <= '1' when (i_opcode = "0110011" and i_func3 = "100" and i_func7 = "0000001") else '0';
    i_divu    <= '1' when (i_opcode = "0110011" and i_func3 = "101" and i_func7 = "0000001") else '0';
    i_rem     <= '1' when (i_opcode = "0110011" and i_func3 = "110" and i_func7 = "0000001") else '0';
    i_remu    <= '1' when (i_opcode = "0110011" and i_func3 = "111" and i_func7 = "0000001") else '0';

    -- Control signals mapping
    o_aluc(0) <= '1' when (i_sub  = '1' or i_xori = '1' or i_xor  = '1' or i_andi = '1' or i_slli = '1' or
                         i_srli = '1' or i_srai = '1' or i_and  = '1' or i_beq  = '1' or i_rem   = '1' or
                         i_remu = '1' or i_mulhsu = '1') and not (i_jal = '1' or i_jalr = '1') else '0';

    o_aluc(1) <= '1' when (i_slt  = '1' or i_xori = '1' or i_xor  = '1' or i_slli = '1' or i_srli = '1' or
                         i_srai = '1' or i_lui  = '1' or i_bne  = '1' or i_mulhu = '1') and not (i_jal = '1' or i_jalr = '1') else '0';

    o_aluc(2) <= '1' when (i_ori  = '1' or i_or   = '1' or i_and  = '1' or i_andi = '1' or i_srli = '1' or
                         i_srai = '1' or i_lui  = '1' or i_div  = '1' or i_rem  = '1' or i_remu = '1')
                         and not (i_jal = '1' or i_jalr = '1') else '0';

    o_aluc(3) <= '1' when (i_xori = '1' or i_xor  = '1' or i_srai = '1' or i_bne  = '1' or i_beq = '1' or
                         i_mul  = '1' or i_div  = '1' or i_rem  = '1' or i_divu = '1' or i_remu = '1')
                         and not (i_jal = '1' or i_jalr = '1') else '0';

    o_aluc(4) <= '1' when (i_divu = '1' or i_remu = '1' or i_mulh = '1' or i_mulhsu = '1' or i_mulhu = '1')
                         and not (i_jal = '1' or i_jalr = '1' or i_lui = '1' or i_xori = '1' or
                                  i_ori = '1' or i_andi = '1' or i_slli = '1' or i_srli = '1' or
                                  i_srai = '1' or i_xor = '1' or i_or = '1' or i_and = '1' or i_div = '1') else '0';

    o_m2reg <= '1' when i_lw = '1' else '0';
    o_wmem  <= '1' when i_sw = '1' else '0';
    o_wreg  <= '1' when (i_lui = '1' or i_jal = '1' or i_jalr = '1' or i_lw = '1' or i_addi = '1' or
                       i_xori = '1' or i_ori = '1' or i_andi = '1' or i_slli = '1' or i_srli = '1' or
                       i_srai = '1' or i_add = '1' or i_sub = '1' or i_slt = '1' or i_xor = '1' or
                       i_or = '1' or i_and = '1' or i_divu = '1' or i_remu = '1' or i_mulh = '1' or
                       i_mulhsu = '1' or i_mulhu = '1' or i_div = '1' or i_rem = '1') else '0';

    o_call  <= '1' when (i_jal = '1' or i_jalr = '1') else '0';

    o_alui(0) <= '1' when (i_slli = '1' or i_srli = '1' or i_srai = '1' or i_lui = '1') else '0';
    o_alui(1) <= '1' when (i_lui = '1' or i_sw = '1') else '0';

    o_bimm <= '1' when (i_addi = '1' or i_xori = '1' or i_ori = '1' or i_andi = '1' or
                      i_slli = '1' or i_srli = '1' or i_srai = '1' or i_lw = '1' or
                      i_sw = '1' or i_lui = '1') else '0';

    o_pcsrc(0) <= '1' when (i_jal = '1' or (i_beq = '1' and i_z = '1') or (i_bne = '1' and i_z = '0')) else '0';
    o_pcsrc(1) <= '1' when (i_jal = '1' or i_jalr = '1') else '0';

end architecture RTL;