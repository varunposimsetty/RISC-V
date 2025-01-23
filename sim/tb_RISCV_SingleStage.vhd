library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb is 
end entity tb;

architecture bhv of tb is 
    signal clk : std_ulogic := '0';
    signal rst : std_ulogic := '0';
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
        i_clk_100MHz => clk,
        i_nrst_async => rst,
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
        i_clk_100MHz => clk,
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
        i_clk_100MHz  => clk,
        i_mem_read    => mem_read,
        i_mem_write   => mem_write,
        i_address     => write_data, -- Address from ALU for lw/sw operation
        i_write_data  => read_data2, -- Data to be stored (fron Regsiter) (sw)
        o_read_data   => read_data_mem -- Data to be read from memory (lw)
    );

    proc_clock_gen : process is 
        begin 
            wait for 5 ns;
            clk <= not clk;
    end process proc_clock_gen;

    proc_tb : process is 
        begin 
            wait for 100 ns;
            rst <= '1';
            wait for 400 ns;
            pc_in <= x"00000010";
            wait for 10 ns;
            pc_sel <= '1';
            wait for 20 ns;
            pc_sel <= '0';
            wait for 2000 ns;
            rst <= '0';
            wait for 200 ns;
            rst <= '1';
            wait for 100 ns;
            pc_in <= x"00000003";
            wait for 20 ns;
            pc_sel <= '1';
            wait for 20 ns;
            pc_sel <= '0';
            wait for 800 ns;
            pc_in <= x"00000000";
            wait for 20 ns;
            pc_sel <= '1';
            wait for 40 ns;
            pc_sel <= '0';
            wait for 1000 ns;
            wait;
    end process proc_tb;
end architecture bhv;