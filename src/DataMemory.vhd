library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity DataMemory is
    generic (
        MEM_DEPTH : integer := 32; -- 32 words of 32-bit
        DATA_WIDTH : integer := 32
    );
    port (
        i_clk        : in  std_ulogic;
        i_mem_write  : in  std_ulogic;
        i_address    : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
        i_write_data : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_read_data  : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
    );
end entity DataMemory;

architecture RTL of DataMemory is 
    constant ADDR_MSB : integer := integer( log(real(MEM_DEPTH)) / log(2.0) ) + 1;
    type mem_array is array (0 to MEM_DEPTH-1) of std_ulogic_vector(DATA_WIDTH-1 downto 0);
    signal data_memory : mem_array := ( 20  => x"000000F2", 21  => x"0000000E", 22  => x"00000200", 23  => x"FFFFFFFF", others => (others => '0'));
    signal word_index : integer range 0 to MEM_DEPTH-1;
    
    begin

    word_index <= to_integer(unsigned(i_address(ADDR_MSB downto 2)));
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if (i_mem_write = '1') then
                data_memory(word_index) <= i_write_data;
            end if;
        end if;
    end process;
    o_read_data <= data_memory(word_index);
end architecture RTL;