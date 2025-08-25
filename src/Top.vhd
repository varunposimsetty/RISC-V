library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity RISC_V_Single_Cycle is 
    generic (
        PC_WIDTH : integer := 32
    );
    port (
        i_clk_100MHz : in std_ulogic;
        i_nrst_async : in std_ulogic 
    );
end entity RISC_V_Single_Cycle;

architecture RTL of RISC_V_Single_Cycle is 
    signal pc_in : std_ulogic_vector(31 downto 0) := (others => '0');
    signal pc_sel : std_ulogic := '0';
    signal pc_out : std_ulogic_vector(31 downto 0); 
    signal instruction : std_ulogic_vector(31 downto 0);
    signal alu_op : std_ulogic_vector(3 downto 0);
    signal reg_write : std_ulogic := '0';
    signal mem_read : std_ulogic;
    signal mem_write : std_ulogic;
    signal branch : std_ulogic;
    signal jump : std_ulogic;
    signal imm : std_ulogic_vector(31 downto 0);
    signal rs1 : std_ulogic_vector(4 downto 0) := (others => '0');
    signal rs2 : std_ulogic_vector(4 downto 0) := (others => '0');
    signal rd  : std_ulogic_vector(4 downto 0) := (others => '0');
    signal write_data : std_ulogic_vector(31 downto 0) := (others => '0');
    signal read_data1 : std_ulogic_vector(31 downto 0);
    signal read_data2 : std_ulogic_vector(31 downto 0);
    signal zero : std_ulogic;
    signal read_data_mem : std_ulogic_vector(31 downto 0);


    begin

    DUT_PC : entity work.ProgramCounter(RTL)
    port map(
        i_clk_100MHz => i_clk_100MHz,
        i_nrst_async => i_nrst_async,
        i_pc         => pc_in,
        i_pc_sel     => pc_sel,
        o_pc         => pc_out 
    );
    DUT_IM : entity work.InstructionMemory(RTL)
    port map(
        i_address     => pc_out,
        o_instruction => instruction

    );
    DUT_CU : entity work.ControlUnit(RTL)
    port map(
        i_instruction => instruction,
        o_alu_op      => alu_op,
        o_reg_write   => reg_write,
        o_mem_read    => mem_read,
        o_mem_write   => mem_write,
        o_branch      => branch,
        o_jump        => jump,
        o_imm         => imm,
        o_rs1         => rs1,
        o_rs2         => rs2,
        o_rd          => rd
    );

    DUT_RF : entity work.RegisterFile(RTL) 
    port map (
        i_clk_100MHz => i_clk_100MHz,
        i_reg_write  => reg_write,
        i_rs1        => rs1,
        i_rs2        => rs2,
        i_rd         => rd,
        i_write_data => write_data,
        o_read_data1 => read_data1,
        o_read_data2 => read_data2
    );

    DUT_ALU : entity work.ALU(RTL)
    port map(
        i_a          => read_data1,
        i_b          => read_data2,
        i_alu_op     => alu_op,
        o_result     => write_data, 
        o_zero       => zero
    );

    DUT_MEM : entity work.DataMemory(RTL)
    port map(
        i_clk_100MHz  => i_clk_100MHz,
        i_mem_read    => mem_read,
        i_mem_write   => mem_write,
        i_address     => write_data, -- Address from ALU for lw/sw operation
        i_write_data  => read_data2, -- Data to be stored (fron Regsiter) (sw)
        o_read_data   => read_data_mem -- Data to be read from memory (lw)
    );

end architecture RTL;
