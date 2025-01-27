library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity Pipelined is 
    generic (
        DATA_WIDTH : integer := 32;
        ADDR_WIDTH : integer := 32
    );
    port (
        i_clk_100MHz  : in std_ulogic;
        i_nrst_async  : in std_ulogic;
        o_instruction : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_pc          : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_alu         : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_mem_data    : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
    );
end entity Pipelined;

architecture RTL of Pipelined is 



end architecture RTL;