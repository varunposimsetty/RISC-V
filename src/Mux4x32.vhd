library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity Mux4x32 is 
    generic (
        PC_WIDTH : integer := 32
    );
    port (
        i_a0  : in std_ulogic_vector(PC_WIDTH-1 downto 0); -- (PC+4)
        i_a1  : in std_ulogic_vector(PC_WIDTH-1 downto 0); -- (Branch Target)
        i_a2  : in std_ulogic_vector(PC_WIDTH-1 downto 0); -- JAL
        i_a3  : in std_ulogic_vector(PC_WIDTH-1 downto 0); -- JALR
        i_s   : in std_ulogic_vector(1 downto 0);
        o_y   : out std_ulogic_vector(PC_WIDTH-1 downto 0)      
    );
end entity Mux4x32;

architecture RTL of Mux4x32 is 
    begin 
        o_y <= i_a0 when (i_s = "00") else
               i_a1 when (i_s = "01") else
               i_a2 when (i_s = "10") else
               i_a3;
end architecture RTL;