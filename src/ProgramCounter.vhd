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
        i_clk_100MHz  : in std_ulogic;
        i_nrst_async  : in std_ulogic;
        i_pc          : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        i_pc_sel        : in std_ulogic;
        o_pc          : out std_ulogic_vector(PC_WIDTH-1 downto 0)

    );
end entity ProgramCounter;

architecture RTL of ProgramCounter is 
    signal pc_present : std_ulogic_vector(PC_WIDTH-1 downto 0) := RESET_VALUE;
    signal pc_next    : std_ulogic_vector(PC_WIDTH-1 downto 0) := RESET_VALUE;

    begin 

    proc_pc : process(i_clk_100MHz,i_nrst_async) is 
        begin 
            if (i_nrst_async = '0') then 
                pc_present <= RESET_VALUE;
                pc_next   <= RESET_VALUE;
            elsif (rising_edge(i_clk_100MHz)) then 
                pc_present <= pc_next;
                if (i_pc_sel = '0') then 
                    pc_next <= std_ulogic_vector(unsigned(pc_present) + 4);
                elsif (i_pc_sel = '1') then 
                    pc_next <= i_pc;
                end if;
            end if;
        end process proc_pc;
    o_pc <= pc_present;
end architecture RTL;