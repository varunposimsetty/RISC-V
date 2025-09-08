library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RISC_V_SingleCycle_Core is
    port (
        i_clk       : in  std_ulogic;
        i_nrst      : in  std_ulogic;
        i_instr     : in  std_ulogic_vector(31 downto 0);
        i_mem_data  : in  std_ulogic_vector(31 downto 0);
        o_pc        : out std_ulogic_vector(31 downto 0);
        o_alu       : out std_ulogic_vector(31 downto 0);
        o_data      : out std_ulogic_vector(31 downto 0);
        o_wmem      : out std_ulogic
    );
end entity;

architecture RTL of RISC_V_SingleCycle_Core is
    signal pc, npc, p4 : std_ulogic_vector(31 downto 0);
    signal reg_readA, reg_readB : std_ulogic_vector(31 downto 0);
    signal imm : std_ulogic_vector(31 downto 0);
    signal alu_res : std_ulogic_vector(31 downto 0);
    signal bra_addr, jal_addr, jalr_addr : std_ulogic_vector(31 downto 0);
    signal alu_srcB : std_ulogic_vector(31 downto 0);
    signal wb_in, wb_data : std_ulogic_vector(31 downto 0);
    signal aluc : std_ulogic_vector(4 downto 0);
    signal alui : std_ulogic_vector(1 downto 0);
    signal pcsrc : std_ulogic_vector(1 downto 0);
    signal m2reg, bimm, call, wreg, wmem : std_ulogic;
    signal z_flag : std_ulogic;
begin
    u_pc_reg : entity work.DFF32
        port map (
            i_clk  => i_clk,
            i_nrst => i_nrst,
            i_d    => npc,
            o_q    => pc
        );
    o_pc <= pc;

    u_pc4 : entity work.ProgramCounter
        port map (
            i_pc => pc,
            o_pc => p4
        );

    u_regfile : entity work.RegisterFile
        port map (
            i_clk_100MHz => i_clk,
            i_nrst_async => i_nrst,
            i_write_en   => wreg,
            i_rs1        => i_instr(19 downto 15),
            i_rs2        => i_instr(24 downto 20),
            i_rd         => i_instr(11 downto 7),
            i_write_data => wb_data,
            o_read_data1 => reg_readA,
            o_read_data2 => reg_readB
        );
    o_data <= reg_readB;

    u_cu : entity work.ControlUnit
        port map (
            i_opcode => i_instr(6 downto 0),
            i_func7  => i_instr(31 downto 25),
            i_func3  => i_instr(14 downto 12),
            i_z      => z_flag,
            o_aluc   => aluc,
            o_alui   => alui,
            o_pcsrc  => pcsrc,
            o_m2reg  => m2reg,
            o_bimm   => bimm,
            o_call   => call,
            o_wreg   => wreg,
            o_wmem   => wmem
        );
    o_wmem <= wmem;

    u_mux_aluB : entity work.Mux2x32
        port map (
            i_a0 => reg_readB,
            i_a1 => imm,
            i_s  => bimm,
            o_y  => alu_srcB
        );

    u_alu : entity work.ALU
        port map (
            i_a       => reg_readA,
            i_b       => alu_srcB,
            i_alu_op  => aluc,
            o_result  => alu_res,
            o_zero    => z_flag
        );
    o_alu <= alu_res;

    u_imm : entity work.ImmediateGenerator
        port map (
            i_instruction    => i_instr,
            i_immediate_type => alui,
            o_immediate      => imm
        );

    u_mux_memres : entity work.Mux2x32
        port map (
            i_a0 => alu_res,
            i_a1 => i_mem_data,
            i_s  => m2reg,
            o_y  => wb_in
        );

    u_mux_call : entity work.Mux2x32
        port map (
            i_a0 => wb_in,
            i_a1 => p4,
            i_s  => call,
            o_y  => wb_data
        );

    u_branch_addr : entity work.BranchAddress
        port map (
            i_pc          => pc,
            i_instruction => i_instr,
            o_address     => bra_addr
        );

    u_jal_addr : entity work.JALAddress
        port map (
            i_pc          => pc,
            i_instruction => i_instr,
            o_address     => jal_addr
        );

    u_jalr_addr : entity work.JALRAddress
        port map (
            i_source_register => reg_readA,
            i_instruction     => i_instr,
            o_address         => jalr_addr
        );

    u_pc_mux : entity work.Mux4x32
        port map (
            i_a0 => p4,
            i_a1 => bra_addr,
            i_a2 => jalr_addr,
            i_a3 => jal_addr,
            i_s  => pcsrc,
            o_y  => npc
        );
end architecture;