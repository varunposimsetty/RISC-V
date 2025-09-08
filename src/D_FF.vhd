library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity DFF32 is 
    generic (
        PC_WIDTH : integer := 32
    );
    port (
        i_clk   : in std_ulogic;
        i_nrst  : in std_ulogic;
        i_d     : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        o_q     : out std_ulogic_vector(PC_WIDTH-1 downto 0)    
    );
end entity DFF32;

architecture RTL of DFF32 is 
    begin 
        process(i_clk,i_nrst) is 
            begin 
                if(i_nrst = '0') then 
                    o_q <= (others => '0');
                elsif(rising_edge(i_clk)) then 
                    o_q <= i_d;
                end if;
        end process;
end architecture RTL;