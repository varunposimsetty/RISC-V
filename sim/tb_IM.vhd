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


