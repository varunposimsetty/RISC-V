library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is 
    generic (
        DATA_WIDTH : integer := 32
    );
    port (
        i_a       : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
        i_b       : in  std_ulogic_vector(DATA_WIDTH-1 downto 0);
        i_alu_op  : in  std_ulogic_vector(4 downto 0);
        o_result  : out std_ulogic_vector(DATA_WIDTH-1 downto 0);
        o_zero    : out std_ulogic
    );
end entity ALU;

architecture RTL of ALU is 
    signal result : std_ulogic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin 
    proc_alu : process(i_a, i_b, i_alu_op) is 
        variable a_s  : signed(DATA_WIDTH-1 downto 0);
        variable b_s  : signed(DATA_WIDTH-1 downto 0);
        variable a_u  : unsigned(DATA_WIDTH-1 downto 0);
        variable b_u  : unsigned(DATA_WIDTH-1 downto 0);
        variable prod64 : signed((DATA_WIDTH*2)-1 downto 0);
        variable produ64: unsigned((DATA_WIDTH*2)-1 downto 0);
    begin 
        a_s := signed(i_a);
        b_s := signed(i_b);
        a_u := unsigned(i_a);
        b_u := unsigned(i_b);

        case i_alu_op is
            when "00000" =>  -- ADD
                result <= std_ulogic_vector(a_u + b_u);
            when "00001" =>  -- SUB
                result <= std_ulogic_vector(a_u - b_u);
            when "01001" =>  -- BEQ
                if i_a = i_b then
                    result <= (31 downto 1 => '0') & '1';
                else
                    result <= (others => '0');
                end if;
            when "01010" =>  -- BNE
                if i_a /= i_b then
                    result <= (31 downto 1 => '0') & '1';
                else
                    result <= (others => '0');
                end if;
            when "11001" =>  -- BLT (signed)
                if a_s < b_s then
                    result <= (31 downto 1 => '0') & '1';
                else
                    result <= (others => '0');
                end if;
            when "11010" =>  -- BGE (signed)
                if a_s >= b_s then
                    result <= (31 downto 1 => '0') & '1';
                else
                    result <= (others => '0');
                end if;
            when "00010" =>  -- SLT (signed less-than)
                if a_s < b_s then
                    result <= (31 downto 1 => '0') & '1';
                else
                    result <= (others => '0');
                end if;
            when "01011" | "11011" =>  -- XOR
                result <= i_a xor i_b;
            when "00100" | "10100" =>  -- OR
                result <= i_a or i_b;
            when "00101" | "10101" =>  -- AND
                result <= i_a and i_b;
            when "00011" | "10011" =>  -- SLL
                result <= std_ulogic_vector(shift_left(a_u,to_integer(b_u(4 downto 0))));
            when "00111" | "10111" =>  -- SRL
                result <= std_ulogic_vector(shift_right(a_u,to_integer(b_u(4 downto 0))));
            when "01111" | "11111" =>  -- SRA
                result <= std_ulogic_vector(shift_right(a_s,to_integer(b_u(4 downto 0))));
            when "00110" | "10110" =>  -- LUI
                result <= i_b;
            when "01000" =>  -- MUL
                prod64 := a_s * b_s;
                result <= std_ulogic_vector(prod64(31 downto 0));
            when "01100" | "11100" =>  -- DIV (signed)
                if b_s /= 0 then
                    result <= std_ulogic_vector(a_s / b_s);
                else
                    result <= (others => '0');
                end if;
            when "01101" =>  -- REM (signed)
                if b_s /= 0 then
                    result <= std_ulogic_vector(a_s rem b_s);
                else
                    result <= (others => '0');
                end if;
            when "10000" =>  -- MULH
                prod64 := a_s * b_s;
                result <= std_ulogic_vector(prod64(63 downto 32));
            when "10001" =>  -- MULHSU
                prod64 := a_s * signed(b_u);
                result <= std_ulogic_vector(prod64(63 downto 32));
            when "10010" =>  -- MULHU
                produ64 := a_u * b_u;
                result <= std_ulogic_vector(produ64(63 downto 32));
            when "11000" =>  -- DIVU
                if b_u /= 0 then
                    result <= std_ulogic_vector(a_u / b_u);
                else
                    result <= (others => '0');
                end if;
            when "11101" =>  -- REMU
                if b_u /= 0 then
                    result <= std_ulogic_vector(a_u rem b_u);
                else
                    result <= (others => '0');
                end if;
            when others => 
                result <= (others => '0');
        end case;
    end process proc_alu;
    o_result <= result;
    o_zero   <= '1' when result = (DATA_WIDTH-1 downto 0 => '0') else '0';
end architecture RTL;