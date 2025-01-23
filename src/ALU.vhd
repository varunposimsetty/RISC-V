library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity ALU is 
    generic (
        DATA_WIDTH : integer := 32
    );
    port (
        i_a       : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
        i_b       : in std_ulogic_vector(DATA_WIDTH-1 downto 0);
        i_alu_op  : in std_ulogic_vector(3 downto 0);
        o_result  : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_zero    : out std_ulogic
    );
end entity ALU;

architecture RTL of ALU is 
    signal result : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    signal zero : std_ulogic := '0';

begin 

    proc_alu : process(i_a,i_b,i_alu_op) is 
        begin 
            case i_alu_op is 
                when "0000" => 
                    -- Addition
                    result <= std_ulogic_vector(unsigned(i_a) + unsigned(i_b));
                when "0001" => 
                    -- Subtraction 
                    result <= std_ulogic_vector(unsigned(i_a) - unsigned(i_b));
                when "0010" => 
                    -- AND 
                    result <= i_a and i_b;
                when "0011" => 
                    -- OR 
                    result <= i_a or i_b;
                when "0100" =>
                    -- XOR 
                    result <= i_a xor i_b;
                when "0101" => 
                    -- Shift Left Logical 
                    result <= std_ulogic_vector(shift_left(unsigned(i_a), to_integer(unsigned(i_b(4 downto 0)))));
                when "0110" =>
                    -- Shift Right Logical 
                    result <= std_ulogic_vector(shift_right(unsigned(i_a), to_integer(unsigned(i_b(4 downto 0)))));
                when "0111" => 
                    -- Shift Right Arithematic 
                    result <= std_ulogic_vector(shift_right(signed(i_a), to_integer(unsigned(i_b(4 downto 0)))));
                when "1001" => 
                    if (i_a = i_b) then 
                        result <= x"00000001";
                    else
                        result <= (others => '0');
                    end if;
                when "1010" => 
                    if (i_a = i_b) then 
                    result <= x"00000001";
                    else
                        result <= (others => '0');
                    end if;
                when others => 
                    null;
            end case;
            if (result = x"00000000") then 
                zero <= '1';
            else 
                zero <= '0';
            end if;
        end process proc_alu;
o_result <= result;
o_zero <= zero;
end architecture RTL;
