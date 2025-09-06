
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity InstructionMemory is 
    generic (
        PC_WIDTH  : integer := 32;  -- instruction width 
        MEM_DEPTH : integer := 32   -- instruction depth 
    );
    port (
        i_address     : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        o_instruction : out std_ulogic_vector(PC_WIDTH-1 downto 0)
    );
end entity InstructionMemory;

architecture RTL of InstructionMemory is 
    signal index_sig : integer := 0;
    type memory_array is array (0 to MEM_DEPTH-1) of std_ulogic_vector(PC_WIDTH-1 downto 0);

    constant instruction_array : memory_array := (
        0   => "00000000000000000000000010110111",  
        1   => "00000101000000001110001000010011",  
        2   => "00000000010000000000001010010011",  
        3   => "00000101100000000000000011101111",  
        4   => "00000000011000100010000000100011",  
        5   => "00000000000000100010010010000011",  
        6   => "01000000010001001000010000110011",  
        7   => "00000000001100000000001010010011",  
        8   => "11111111111100101000001010010011",  
        9   => "11111111111100101110010000010011",
        10  => "01010101010101000100010000010011", 
        11  => "11111111111100000000010010010011", 
        12  => "11111111111101001111010100010011",
        13  => "00000000100101010110001000110011", 
        14  => "00000000100101010100010000110011", 
        15  => "00000000010001010111001110110011", 
        16  => "00000000000000101000010001100011", 
        17  => "11111101110111111111000001101111", 
        18  => "11111111111100000000001010010011", 
        19  => "00000000111100101001010000010011", 
        20  => "00000001000001000001010000010011", 
        21  => "01000001000001000101010000010011", 
        22  => "00000000111101000101010000010011", 
        23  => "00000000011000100010000110110011", 
        24  => "00000000000000000000000001101111", 
        25  => "00000000000000000000001100110011", 
        26  => "00000000000000100010010010000011", 
        27  => "00000000010000100000001000010011", 
        28  => "00000000100100110000001100110011", 
        29  => "11111111111100101000001010010011", 
        30  => "11111110000000101001100011100011", 
        31  => "00000000000000001000000001100111",
        others => (others => '0')
    );
    begin 
    process(i_address) is 
     variable index : integer := 0;
        begin 
            index := to_integer(unsigned(i_address(31 downto 2)));
            index_sig <= index;
            if (index < MEM_DEPTH) then 
                o_instruction <= instruction_array(index);
            else 
                o_instruction <= (others => '0'); -- NOP 
            end if;
    end process;
end architecture RTL;


