library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity JALAddress is 
    generic (
        PC_WIDTH : integer := 32
    );
    port (
        i_pc          : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        i_instruction : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        o_address     : out std_ulogic_vector(PC_WIDTH-1 downto 0)

    );
end entity JALAddress;

architecture RTL of JALAddress is 
    signal offset : std_ulogic_vector(PC_WIDTH-1 downto 0) := (others => '0');
    begin 
    offset <=  (PC_WIDTH-1 downto 20 => i_instruction(31)) &  i_instruction(19 downto 12) & i_instruction(20) & i_instruction(30 downto 21) & '0';
    o_address <= std_ulogic_vector(signed(i_pc) + signed(offset));
end architecture RTL;