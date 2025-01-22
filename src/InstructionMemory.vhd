
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity InstructionMemory is 
    generic (
        PC_WIDTH  : integer := 32;  -- instruction width 
        MEM_DEPTH : integer := 128   -- instruction depth 
    );
    port (
        i_address     : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        o_instruction : out std_ulogic_vector(PC_WIDTH-1 downto 0)
    );
end entity InstructionMemory;

architecture RTL of InstructionMemory is 
    signal index : integer := 0;
    type memory_array is array (0 to MEM_DEPTH-1) of std_ulogic_vector(PC_WIDTH-1 downto 0);

    constant instruction_array : memory_array := (
    -- R-Type Instructions
    0   => x"00208033",  -- ADD x3, x1, x2
    1   => x"005280b3",  -- ADD x6, x4, x5
    2   => x"40c40433",  -- SUB x9, x7, x8
    3   => x"40a684b3",  -- SUB x13, x10, x12
    4   => x"00f5c833",  -- AND x17, x15, x16
    5   => x"0137d0b3",  -- AND x20, x18, x19
    6   => x"015a78b3",  -- OR x23, x21, x22
    7   => x"018a72b3",  -- OR x26, x24, x25
    8   => x"01b87433",  -- XOR x29, x27, x28
    9   => x"01f8f0b3",  -- XOR x31, x30, x0
    10  => x"0043a093",  -- SLL x1, x4, x3
    11  => x"0094a293",  -- SLL x10, x9, x8
    12  => x"00e6c733",  -- SRL x15, x14, x13
    13  => x"0137d733",  -- SRL x20, x19, x18
    14  => x"415ab933",  -- SRA x23, x22, x21
    15  => x"41babdb3",  -- SRA x28, x27, x26

    -- I-Type Immediate Arithmetic Instructions
    16  => x"00108013",  -- ADDI x2, x1, 1
    17  => x"00418093",  -- ADDI x4, x3, 4
    18  => x"00728113",  -- ANDI x6, x5, 7
    19  => x"00a38193",  -- ANDI x8, x7, 10
    20  => x"00d48213",  -- ORI x10, x9, 13
    21  => x"01058293",  -- ORI x12, x11, 16

    -- I-Type Immediate Load Instructions
    22  => x"0016a213",  -- LW x14, 1(x13)
    23  => x"0027a293",  -- LW x16, 2(x15)

    -- I-Type Jump Instructions
    24  => x"0038a313",  -- JALR x18, x17, 3
    25  => x"0049a393",  -- JALR x20, x19, 4

    -- S-Type Store Instructions
    26  => x"1b5ab023",  -- SW x23, 7(x21)
    27  => x"219b3023",  -- SW x26, 8(x24)

    -- B-Type Branch Instructions
    28  => x"1ceee663",  -- BEQ x29, x27, 14
    29  => x"201e1863",  -- BEQ x2, x1, 1
    30  => x"216e2163",  -- BNE x7, x6, 1
    31  => x"291e22e3",  -- BNE x10, x9, 2

    -- J-Type Jump Instructions
    32  => x"003001ef",  -- JAL x13, 12
    33  => x"004001ef",  -- JAL x17, 16
    34  => x"005001ef",  -- JAL x21, 20
    35  => x"006001ef",  -- JAL x25, 24

    -- Repeat some instructions to fill up to 128 entries
    36  => x"00208033",  -- ADD x3, x1, x2
    37  => x"005280b3",  -- ADD x6, x4, x5
    38  => x"40c40433",  -- SUB x9, x7, x8
    39  => x"40a684b3",  -- SUB x13, x10, x12
    40  => x"00f5c833",  -- AND x17, x15, x16
    41  => x"0137d0b3",  -- AND x20, x18, x19
    42  => x"015a78b3",  -- OR x23, x21, x22
    43  => x"018a72b3",  -- OR x26, x24, x25
    44  => x"01b87433",  -- XOR x29, x27, x28
    45  => x"01f8f0b3",  -- XOR x31, x30, x0
    46  => x"0043a093",  -- SLL x1, x4, x3
    47  => x"0094a293",  -- SLL x10, x9, x8
    48  => x"00e6c733",  -- SRL x15, x14, x13
    49  => x"0137d733",  -- SRL x20, x19, x18
    50  => x"415ab933",  -- SRA x23, x22, x21
    51  => x"41babdb3",  -- SRA x28, x27, x26

    -- More instructions
    52  => x"00108013",  -- ADDI x2, x1, 1
    53  => x"00418093",  -- ADDI x4, x3, 4
    54  => x"00728113",  -- ANDI x6, x5, 7
    55  => x"00a38193",  -- ANDI x8, x7, 10
    56  => x"00d48213",  -- ORI x10, x9, 13
    57  => x"01058293",  -- ORI x12, x11, 16

    -- Load instructions again
    58  => x"0016a213",  -- LW x14, 1(x13)
    59  => x"0027a293",  -- LW x16, 2(x15)

    -- Jump instructions again
    60  => x"0038a313",  -- JALR x18, x17, 3
    61  => x"0049a393",  -- JALR x20, x19, 4

    -- Store instructions again
    62  => x"1b5ab023",  -- SW x23, 7(x21)
    63  => x"219b3023",  -- SW x26, 8(x24)

    -- Branch instructions again
    64  => x"1ceee663",  -- BEQ x29, x27, 14
    65  => x"201e1863",  -- BEQ x2, x1, 1
    66  => x"216e2163",  -- BNE x7, x6, 1
    67  => x"291e22e3",  -- BNE x10, x9, 2

    -- Jump instructions again
    68  => x"003001ef",  -- JAL x13, 12
    69  => x"004001ef",  -- JAL x17, 16
    70  => x"005001ef",  -- JAL x21, 20
    71  => x"006001ef",  -- JAL x25, 24

    -- More R-Type instructions
    72  => x"00208033",  -- ADD x3, x1, x2
    73  => x"005280b3",  -- ADD x6, x4, x5
    74  => x"40c40433",  -- SUB x9, x7, x8
    75  => x"40a684b3",  -- SUB x13, x10, x12
    76  => x"00f5c833",  -- AND x17, x15, x16
    77  => x"0137d0b3",  -- AND x20, x18, x19
    78  => x"015a78b3",  -- OR x23, x21, x22
    79  => x"018a72b3",  -- OR x26, x24, x25
    80  => x"01b87433",  -- XOR x29, x27, x28
    81  => x"01f8f0b3",  -- XOR x31, x30, x0
    82  => x"0043a093",  -- SLL x1, x4, x3
    83  => x"0094a293",  -- SLL x10, x9, x8
    84  => x"00e6c733",  -- SRL x15, x14, x13
    85  => x"0137d733",  -- SRL x20, x19, x18
    86  => x"415ab933",  -- SRA x23, x22, x21
    87  => x"41babdb3",  -- SRA x28, x27, x26

    -- More I-Type Immediate Arithmetic Instructions
    88  => x"00108013",  -- ADDI x2, x1, 1
    89  => x"00418093",  -- ADDI x4, x3, 4
    90  => x"00728113",  -- ANDI x6, x5, 7
    91  => x"00a38193",  -- ANDI x8, x7, 10
    92  => x"00d48213",  -- ORI x10, x9, 13
    93  => x"01058293",  -- ORI x12, x11, 16

    -- Load instructions again
    94  => x"0016a213",  -- LW x14, 1(x13)
    95  => x"0027a293",  -- LW x16, 2(x15)

    -- Jump instructions again
    96  => x"0038a313",  -- JALR x18, x17, 3
    97  => x"0049a393",  -- JALR x20, x19, 4

    -- Store instructions again
    98  => x"1b5ab023",  -- SW x23, 7(x21)
    99  => x"219b3023",  -- SW x26, 8(x24)

    -- Branch instructions again
    100 => x"1ceee663",  -- BEQ x29, x27, 14
    101 => x"201e1863",  -- BEQ x2, x1, 1
    102 => x"216e2163",  -- BNE x7, x6, 1
    103 => x"291e22e3",  -- BNE x10, x9, 2

    -- Jump instructions again
    104 => x"003001ef",  -- JAL x13, 12
    105 => x"004001ef",  -- JAL x17, 16
    106 => x"005001ef",  -- JAL x21, 20
    107 => x"006001ef",  -- JAL x25, 24

    -- More R-Type instructions
    108 => x"00208033",  -- ADD x3, x1, x2
    109 => x"005280b3",  -- ADD x6, x4, x5
    110 => x"40c40433",  -- SUB x9, x7, x8
    111 => x"40a684b3",  -- SUB x13, x10, x12
    112 => x"00f5c833",  -- AND x17, x15, x16
    113 => x"0137d0b3",  -- AND x20, x18, x19
    114 => x"015a78b3",  -- OR x23, x21, x22
    115 => x"018a72b3",  -- OR x26, x24, x25
    116 => x"01b87433",  -- XOR x29, x27, x28
    117 => x"01f8f0b3",  -- XOR x31, x30, x0
    118 => x"0043a093",  -- SLL x1, x4, x3
    119 => x"0094a293",  -- SLL x10, x9, x8
    120 => x"00e6c733",  -- SRL x15, x14, x13
    121 => x"0137d733",  -- SRL x20, x19, x18
    122 => x"415ab933",  -- SRA x23, x22, x21
    123 => x"41babdb3",  -- SRA x28, x27, x26

    -- More I-Type Immediate Arithmetic Instructions
    124 => x"00108013",  -- ADDI x2, x1, 1
    125 => x"00418093",  -- ADDI x4, x3, 4
    126 => x"00728113",  -- ANDI x6, x5, 7
    127 => x"00a38193",  -- ANDI x8, x7, 10

    others => x"00000000"
);
    begin 
    process(i_address) is 
        begin 
            index <= to_integer(unsigned(i_address(31 downto 2)));
            if (index < MEM_DEPTH) then 
                o_instruction <= instruction_array(index);
            else 
                o_instruction <= (others => '0'); -- NOP 
            end if;
    end process;
end architecture RTL;


