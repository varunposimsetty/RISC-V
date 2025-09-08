library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb is 
end entity tb;

architecture bhv of tb is 
    signal clk : std_ulogic := '0';
    signal rst : std_ulogic := '0';
    signal instr : std_ulogic_vector(31 downto 0) := (others => '0');
    signal pc : std_ulogic_vector(31 downto 0) := (others => '0');
    signal alu : std_ulogic_vector(31 downto 0) := (others => '0');
    signal mem : std_ulogic_vector(31 downto 0) := (others => '0');
    
    begin 

    DUT_PC : entity work.RISC_V_SingleCycle_Computer(RTL)
    port map(
        i_clk => clk,
        i_nrst => rst,
        o_instr => instr,
        o_pc => pc,
        o_alu => alu,
        o_mem => mem 
    );
    
    proc_clock_gen : process is 
        begin 
            wait for 5 ns;
            clk <= not clk;
    end process proc_clock_gen;

    proc_tb : process is 
        begin 
            wait for 20 ns;
            rst <= '1';
            wait for 1000005 ns;
            rst <= not clk;
            wait for 90 ns;
            rst <= '1';
            wait for 600000 ns;
            rst <= '0';
            wait;
    end process proc_tb;
end architecture bhv;