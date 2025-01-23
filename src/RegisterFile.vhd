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
        i_reg_write  : in std_ulogic;
        i_rs1        : in std_ulogic_vector(4 downto 0);
        i_rs2        : in std_ulogic_vector(4 downto 0);
        i_rd         : in std_ulogic_vector(4 downto 0);
        i_write_data : in std_ulogic_vector(REG_WIDTH-1 downto 0);
        o_read_data1 : out std_ulogic_vector(REG_WIDTH-1 downto 0);
        o_read_data2 : out std_ulogic_vector(REG_WIDTH-1 downto 0)
    );
end entity RegisterFile;

architecture RTL of RegisterFile is 
    type reg_array is array (0 to REG_COUNT-1) of std_ulogic_vector(REG_WIDTH-1 downto 0);

    constant x0 : std_ulogic_vector(REG_WIDTH-1 downto 0) := (others => '0');
    -- Ramdom Values in Register Bank 
    signal register_bank : reg_array := (
        0  => x0, -- x0 should always be zero
        1  => x"01200000",
        2  => x"00001111",
        3  => x"10230000",
        4  => x"12345678",
        5  => x"00000035",
        6  => x"0000000A",
        7  => x"00000ABC",
        8  => x"01020304",
        9  => x"00200005",
        10 => x"10000000",
        11 => x"01200120",
        12 => x"10100100",
        13 => x"00011100",
        14 => x"11110000",
        15 => x"12300012",
        16 => x"01010100",
        17 => x"01110100",
        18 => x"01011100",
        19 => x"01010101",
        20 => x"01010000",
        22 => x"0000F00D",
        23 => x"1CEB00DA",
        24 => x"BA5EBA11",
        25 => x"ABADCAFE",
        26 => x"B01DFACE",
        27 => x"C0FFEE00",
        28 => x"45760910",
        29 => x"09102000",
        others => x"00000000"
    );

    begin 
        -- WRITE IS SEQUENTIAL i.e. Synchronous
        proc_write: process(i_clk_100MHz) is 
            begin 
                if (rising_edge(i_clk_100MHz)) then 
                    if ((i_reg_write = '1') and (i_rd /= x"00000")) then
                        register_bank(to_integer(unsigned(i_rd))) <= i_write_data;
                    end if;
                end if;
        end process proc_write;
     -- READ IS COMBINATIONAL i.e. Asynchronous 
     o_read_data1 <= register_bank(to_integer(unsigned(i_rs1)));
     o_read_data2 <= register_bank(to_integer(unsigned(i_rs2)));
end architecture RTL;
