library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb is 
end entity tb;

architecture bhv of tb is 
    signal clk : std_ulogic := '0';
    signal rst : std_ulogic := '0';

    begin 

    DUT_TOP : entity work.RISC_V_Single_Cycle(RTL)
    port map (
        i_clk_100MHz  => clk,
        i_nrst_async => rst
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
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 100 ns;
            rst <= '1';
            wait for 10000 ns;
            rst <= '0';
            wait for 200 ns;
            wait;
        end process proc_tb;
end architecture bhv;