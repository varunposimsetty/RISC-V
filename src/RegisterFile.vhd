library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity RegisterFile is 
    generic (
        REG_COUNT : integer := 32;
        REG_WIDTH : integer := 32
    );
    port (
        i_clk_100MHz : in std_ulogic;
        i_nrst_async : in std_ulogic;
        i_write_en   : in std_ulogic;
        i_rs1        : in std_ulogic_vector(4 downto 0); -- reg # of read port A
        i_rs2        : in std_ulogic_vector(4 downto 0); -- reg # of read port B
        i_rd         : in std_ulogic_vector(4 downto 0); -- reg # of write port 
        i_write_data : in std_ulogic_vector(REG_WIDTH-1 downto 0);
        o_read_data1 : out std_ulogic_vector(REG_WIDTH-1 downto 0);
        o_read_data2 : out std_ulogic_vector(REG_WIDTH-1 downto 0)
    );
end entity RegisterFile;

architecture RTL of RegisterFile is 
    type reg_array is array (0 to REG_COUNT-1) of std_ulogic_vector(REG_WIDTH-1 downto 0);
    signal register_bank : reg_array := (others => (others => '0'));

    begin 
        proc_write: process(i_clk_100MHz,i_nrst_async) is 
            begin 
                if (i_nrst_async = '0') then
                    register_bank <= (others => (others => '0'));
                elsif(rising_edge(i_clk_100MHz)) then 
                    if ((i_write_en = '1') and (i_rd /= "00000")) then
                        register_bank(to_integer(unsigned(i_rd))) <= i_write_data;
                    end if;
                end if;
        end process proc_write;
     -- READ IS COMBINATIONAL i.e. Asynchronous 
     o_read_data1 <= register_bank(to_integer(unsigned(i_rs1))) when (i_rs1 /= "00000") else (others => '0');
     o_read_data2 <= register_bank(to_integer(unsigned(i_rs2))) when (i_rs2 /= "00000") else (others => '0');
end architecture RTL;
