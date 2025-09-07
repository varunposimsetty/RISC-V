library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity JALRAddress is 
    generic (
        PC_WIDTH : integer := 32
    );
    port (
        i_source_register : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        i_instruction     : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        o_address         : out std_ulogic_vector(PC_WIDTH-1 downto 0)

    );
end entity JALRAddress;

architecture RTL of JALRAddress is 
    signal immediate : std_ulogic_vector(PC_WIDTH-1 downto 0) := (others => '0');
    signal target : std_ulogic_vector(PC_WIDTH-1 downto 0) := (others => '0');
    begin 
    immediate <= (PC_WIDTH-1 downto 12 => i_instruction(31)) & i_instruction(31 downto 20);
    target <= std_ulogic_vector(signed(i_source_register) + signed(immediate));
    o_address <= target(PC_WIDTH-1 downto 1) & '0';
end architecture RTL;