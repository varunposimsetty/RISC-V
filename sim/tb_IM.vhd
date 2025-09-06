library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb is 
end entity tb;

architecture bhv of tb is 
    signal pc_in : std_ulogic_vector(31 downto 0) := (others => '0');
    signal pc_out : std_ulogic_vector(31 downto 0); 
    signal instruction : std_ulogic_vector(31 downto 0);


    begin 
    DUT_PC : entity work.ProgramCounter(RTL)
    port map(
        i_pc         => pc_in,
        o_pc         => pc_out 
    );
    DUT_IM : entity work.InstructionMemory(RTL)
    port map(
        i_address     => pc_in,
        o_instruction => instruction

    );

    proc_tb : process is 
        begin
            wait for 20 ns;
            pc_in <= pc_out;
    end process proc_tb;
end architecture bhv;


