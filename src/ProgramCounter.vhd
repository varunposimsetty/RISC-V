library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity ProgramCounter is 
    generic (
        PC_WIDTH : integer := 32;
        RESET_VALUE : std_ulogic_vector(31 downto 0) := (others => '0')
    );
    port (
        i_pc          : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        o_pc          : out std_ulogic_vector(PC_WIDTH-1 downto 0)

    );
end entity ProgramCounter;

architecture RTL of ProgramCounter is 
    begin 
    o_pc <= std_ulogic_vector(unsigned(i_pc) + 4);
end architecture RTL;