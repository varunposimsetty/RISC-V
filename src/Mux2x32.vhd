library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity Mux2x32 is 
    generic (
        PC_WIDTH : integer := 32
    );
    port (
        i_a0  : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        i_a1  : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        i_s   : in std_ulogic;
        o_y   : out std_ulogic_vector(PC_WIDTH-1 downto 0)      
    );
end entity Mux2x32;

architecture RTL of Mux2x32 is 
    begin 
    o_y <= i_a1 when (i_s = '1') else i_a0;
end architecture RTL;