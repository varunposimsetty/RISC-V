library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity DataMemory is 
    generic (
        MEM_DEPTH  : integer := 128;
        DATA_WIDTH : integer := 32
    );
    port (
        i_clk_100MHz : in std_ulogic;
        i_mem_read   : in std_ulogic;
        i_mem_write  : in std_ulogic;
        i_address    : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
        i_write_data : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_read_data  : out std_ulogic_vector(DATA_WIDTH-1 downto 0)
    );
end entity DataMemory;

architecture RTL of DataMemory is 
    signal read_data : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');

    type memory_array is array(0 to MEM_DEPTH-1) of std_ulogic_vector(DATA_WIDTH-1 downto 0);
    -- RANDOM DATA in DATA MEMORY
    signal data_memory : memory_array := (
        0  => x"00000001",  1  => x"00000002",  2  => x"00000003",  3  => x"00000004",
        4  => x"00000005",  5  => x"00000006",  6  => x"00000007",  7  => x"00000008",
        8  => x"00000009",  9  => x"0000000A",  10 => x"0000000B",  11 => x"0000000C",
        12 => x"0000000D",  13 => x"0000000E",  14 => x"0000000F",  15 => x"00000010",
        16 => x"00000011",  17 => x"00000012",  18 => x"00000013",  19 => x"00000014",
        20 => x"00000015",  21 => x"00000016",  22 => x"00000017",  23 => x"00000018",
        24 => x"00000019",  25 => x"0000001A",  26 => x"0000001B",  27 => x"0000001C",
        28 => x"0000001D",  29 => x"0000001E",  30 => x"0000001F",  31 => x"00000020",
        32 => x"00000021",  33 => x"00000022",  34 => x"00000023",  35 => x"00000024",
        36 => x"00000025",  37 => x"00000026",  38 => x"00000027",  39 => x"00000028",
        40 => x"00000029",  41 => x"0000002A",  42 => x"0000002B",  43 => x"0000002C",
        44 => x"0000002D",  45 => x"0000002E",  46 => x"0000002F",  47 => x"00000030",
        48 => x"00000031",  49 => x"00000032",  50 => x"00000033",  51 => x"00000034",
        52 => x"00000035",  53 => x"00000036",  54 => x"00000037",  55 => x"00000038",
        56 => x"00000039",  57 => x"0000003A",  58 => x"0000003B",  59 => x"0000003C",
        60 => x"0000003D",  61 => x"0000003E",  62 => x"0000003F",  63 => x"00000040",
        64 => x"00000041",  65 => x"00000042",  66 => x"00000043",  67 => x"00000044",
        68 => x"00000045",  69 => x"00000046",  70 => x"00000047",  71 => x"00000048",
        72 => x"00000049",  73 => x"0000004A",  74 => x"0000004B",  75 => x"0000004C",
        76 => x"0000004D",  77 => x"0000004E",  78 => x"0000004F",  79 => x"00000050",
        80 => x"00000051",  81 => x"00000052",  82 => x"00000053",  83 => x"00000054",
        84 => x"00000055",  85 => x"00000056",  86 => x"00000057",  87 => x"00000058",
        88 => x"00000059",  89 => x"0000005A",  90 => x"0000005B",  91 => x"0000005C",
        92 => x"0000005D",  93 => x"0000005E",  94 => x"0000005F",  95 => x"00000060",
        96 => x"00000061",  97 => x"00000062",  98 => x"00000063",  99 => x"00000064",
        100 => x"00000065", 101 => x"00000066", 102 => x"00000067", 103 => x"00000068",
        104 => x"00000069", 105 => x"0000006A", 106 => x"0000006B", 107 => x"0000006C",
        108 => x"0000006D", 109 => x"0000006E", 110 => x"0000006F", 111 => x"00000070",
        112 => x"00000071", 113 => x"00000072", 114 => x"00000073", 115 => x"00000074",
        116 => x"00000075", 117 => x"00000076", 118 => x"00000077", 119 => x"00000078",
        120 => x"00000079", 121 => x"0000007A", 122 => x"0000007B", 123 => x"0000007C",
        124 => x"0000007D", 125 => x"0000007E", 126 => x"0000007F", 127 => x"00000080"
    );

    begin 
        proc : process(i_clk_100MHz) is 
            begin 
                if(rising_edge(i_clk_100MHz)) then 
                    if(i_mem_write = '1') then 
                        if (to_integer(unsigned(i_address)) < MEM_DEPTH-1) then 
                            data_memory(to_integer(unsigned(i_address))) <= i_write_data;
                        else 
                            null;
                        end if;
                    elsif (i_mem_read = '1') then 
                        if (to_integer(unsigned(i_address)) < MEM_DEPTH-1) then 
                            read_data <= data_memory(to_integer(unsigned(i_address)));
                        else 
                            read_data <= (others => '0');
                        end if;
                    end if;
                end if;
        end process proc;
        o_read_data <= read_data;
end architecture RTL;