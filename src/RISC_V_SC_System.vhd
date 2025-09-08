library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RISC_V_SingleCycle_Computer is
    port (
        i_clk  : in  std_ulogic;
        i_nrst : in  std_ulogic;
        o_instr : out std_ulogic_vector(31 downto 0);
        o_pc    : out std_ulogic_vector(31 downto 0);
        o_alu   : out std_ulogic_vector(31 downto 0);
        o_mem   : out std_ulogic_vector(31 downto 0)
    );
end entity;

architecture RTL of RISC_V_SingleCycle_Computer is

    signal instr   : std_ulogic_vector(31 downto 0);
    signal pc      : std_ulogic_vector(31 downto 0);
    signal alu_out : std_ulogic_vector(31 downto 0);
    signal mem_data: std_ulogic_vector(31 downto 0);
    signal data    : std_ulogic_vector(31 downto 0);
    signal wmem    : std_ulogic;

begin

    -- CPU Core
    u_core : entity work.RISC_V_SingleCycle_Core
        port map (
            i_clk      => i_clk,
            i_nrst     => i_nrst,
            i_instr    => instr,
            i_mem_data => mem_data,
            o_pc       => pc,
            o_alu      => alu_out,
            o_data     => data,
            o_wmem     => wmem
        );

    -- Instruction Memory (read-only)
    u_instmem : entity work.InstructionMemory
        port map (
            i_address => pc,
            o_instruction => instr
        );

    -- Data Memory
    u_datamem : entity work.DataMemory
        port map (
            i_clk        => i_clk,
            i_mem_write  => wmem,
            i_address    => alu_out,
            i_write_data => data,
            o_read_data  => mem_data
        );

    -- Outputs to top-level
    o_instr <= instr;
    o_pc    <= pc;
    o_alu   <= alu_out;
    o_mem   <= mem_data;

end architecture;