library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity ControlUnit is 
    generic (
        INSTR_WIDTH : integer := 32
    );
    port (
        i_instruction : in std_ulogic_vector(INSTR_WIDTH-1 downto 0); -- input instruction
        o_alu_op      : out std_ulogic_vector(3 downto 0); -- opcode 
        o_reg_write   : out std_ulogic; -- enable writing of data to the register file
        o_mem_read    : out std_ulogic; -- enable reading data from data memory
        o_mem_write   : out std_ulogic; -- enable writing data to data memory 
        o_branch      : out std_ulogic; -- if the instruction is a branch instruction
        o_jump        : out std_ulogic; -- if the instruction is a jump instruction 
        o_imm         : out std_ulogic_vector(31 downto 0); -- immediate value extracted from instruction
        o_rs1         : out std_ulogic_vector(4 downto 0); -- source register 1 address
        o_rs2         : out std_ulogic_vector(4 downto 0); -- source register 2 address
        o_rd          : out std_ulogic_vector(4 downto 0) -- designation register
    );
end entity ControlUnit;

architecture RTL of ControlUnit is 
    signal alu_op : std_ulogic_vector(3 downto 0) := (others => '0');
    signal reg_write : std_ulogic := '0';
    signal mem_read : std_ulogic := '0';
    signal mem_write : std_ulogic := '0';
    signal branch : std_ulogic := '0';
    signal jump : std_ulogic := '0';
    signal imm : std_ulogic_vector(31 downto 0) := (others => '0');
    signal rs1 : std_ulogic_vector(4 downto 0) := (others => '0');
    signal rs2 : std_ulogic_vector(4 downto 0) := (others => '0');
    signal rd  : std_ulogic_vector(4 downto 0) := (others => '0');

    signal op_code : std_ulogic_vector(6 downto 0) := (others => '0');
    signal funct7  : std_ulogic_vector(6 downto 0) := (others => '0');
    signal funct3  : std_ulogic_vector(2 downto 0) := (others => '0');


    begin
    process(i_instruction) is 
        begin 
        op_code <= i_instruction(6 downto 0);
        case op_code is
            -- R-Type (Register - Regsiter)
            when "0110011" => 
                funct7 <= i_instruction(31 downto 25);
                funct3 <= i_instruction(14 downto 12);
                rs2 <= i_instruction(24 downto 20);
                rs1 <= i_instruction(19 downto 15);
                rd <= i_instruction(11 downto 7);
                o_imm <= (others => '0');
                -- general control signals 
                reg_write <= '1'; -- register enbaled to write in the desination address
                mem_read <= '0';
                mem_write <= '0';
                branch <= '0';
                jump <= '0';
                case funct3 is 
                    when "000" => -- ADD or SUB
                        if (funct7 = "0000000") then 
                            alu_op <= "0000"; -- ADD
                        elsif (funct7 = "0100000") then 
                            alu_op <= "0001"; -- SUB
                        end if;
                    when "111" =>
                        alu_op <= "0010"; -- AND 
                    when "110" => 
                        alu_op <= "0011"; -- OR
                    when "100" => 
                        alu_op <= "0100"; -- XOR
                    when "001" =>
                        alu_op <= "0101"; -- SLL
                    when "101" =>
                        if (funct7 = "0000000") then 
                            alu_op <= "0110"; -- SRL
                        elsif (funct7 = "0100000") then 
                            alu_op <= "0111"; -- SRA
                        end if;
                    when others => 
                        null;
                end case;
            -- I-Type Immediate (Arithematic)
            when "0010011" =>
                funct7 <= (others => '0');
                funct3 <= i_instruction(14 downto 12);
                imm(11 downto 0) <= i_instruction(31 downto 20);
                o_imm <= std_ulogic_vector(signed(imm));
                rs1 <= i_instruction(19 downto 15);
                rs2 <= (others => '0');
                rd <= i_instruction(11 downto 7);
                -- general control signals
                reg_write <= '1'; -- register enbaled to write in the desination address
                mem_read <= '0';
                mem_write <= '0';
                branch <= '0';
                jump <= '0';
                case funct3 is 
                    when "000" =>
                        alu_op <= "0000";
                    when "111" =>
                        alu_op <= "0010";
                    when "110" => 
                        alu_op <= "0011";
                    when others => 
                        null;
                end case;
            
            -- I-Type Immediate (Load)
            when "0000011" =>
                funct7 <= (others => '0');
                funct3 <= i_instruction(14 downto 12);
                imm(11 downto 0) <= i_instruction(31 downto 20);
                o_imm <= std_ulogic_vector(signed(imm));
                rs1 <= i_instruction(19 downto 15);
                rs2 <= (others => '0');
                rd <= i_instruction(11 downto 7);
                -- general control signals 
                reg_write <= '1';
                mem_read <= '1';
                mem_write <= '0';
                branch <= '0';
                jump <= '0';
                if (funct3 = "010") then 
                    alu_op <= "0000";
                end if;

            -- I-Type Immediate (Jump)
            when "1100111" =>
                funct7 <= (others => '0'); 
                funct3 <= i_instruction(14 downto 12);
                imm(11 downto 0) <= i_instruction(31 downto 20);
                o_imm <= std_ulogic_vector(signed(imm));
                rs1 <= i_instruction(19 downto 15);
                rs2 <= (others => '0');
                rd <= i_instruction(11 downto 7);
                -- general control signals 
                reg_write <= '1';
                mem_read <= '0';
                mem_write <= '0';
                branch <= '0';
                jump <= '1';
                if (funct3 = "000") then 
                    alu_op <= "0000";
                end if;
            
            -- S-Type (Store) 
            when "0100011" => 
                funct7 <= (others => '0'); 
                funct3 <= i_instruction(14 downto 12);
                imm(11 downto 5) <= i_instruction(31 downto 25);
                imm(4 downto 0) <= i_instruction(11 downto 7);
                o_imm <= std_ulogic_vector(signed(imm));
                rs1 <= i_instruction(19 downto 15);
                rd <= (others => '0');
                rs2 <= i_instruction(24 downto 20);
                -- general control signals 
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '1';
                branch <= '0';
                jump <= '0';
                if (funct3 = "010") then 
                    alu_op <= "0000";
                end if;
            
            -- B-Type (Branch)
            when "1100011" => 
                funct7 <= (others => '0'); 
                funct3 <= i_instruction(14 downto 12);
                imm(12) <= i_instruction(31);
                imm(11) <= i_instruction(7);
                imm(10 downto 5) <= i_instruction(30 downto 25);
                imm(4 downto 0) <= i_instruction(11 downto 8) & '0';
                o_imm <= std_ulogic_vector(signed(imm));
                rs1 <= i_instruction(19 downto 15);
                rs2 <= i_instruction(24 downto 20);
                rd <= (others => '0');
                -- general control signals 
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '0';
                branch <= '1';
                jump <= '0';
                if (funct3 = "000") then 
                    alu_op <= "1001";
                elsif (funct3 = "001") then 
                    alu_op <= "1010";
                end if;
            
            -- J-Type (Jump)
            when "1101111" =>
                funct7 <= (others => '0'); 
                funct3 <= (others => '0');
                rs1 <= (others => '0');
                rs2 <= (others => '0');
                imm(20) <= i_instruction(31);
                imm(19 downto 12) <= i_instruction(19 downto 12);
                imm(11) <= i_instruction(20);
                imm(10 downto 0) <= i_instruction(30 downto 21) & '0';
                o_imm <= std_ulogic_vector(signed(imm));
                rd <= (i_instruction(11 downto 7));
                alu_op <= "0000";
                -- general control signals 
                reg_write <= '0';
                mem_read <= '0';
                mem_write <= '1';
                branch <= '0';
                jump <= '0';
            when others => 
                funct7 <= (others => '0');
                funct3 <=(others => '0');
                rs2 <= (others => '0');
                rs1 <= (others => '0');
                rd <= (others => '0');
                o_imm <= (others => '0');
                -- general control signals 
                reg_write <= '0'; -- register enbaled to write in the desination address
                mem_read <= '0';
                mem_write <= '0';
                branch <= '0';
                jump <= '0';  
        end case;    

    end process;
    o_alu_op <= alu_op;
    o_reg_write <= reg_write;
    o_mem_read <= mem_read;
    o_mem_write <= mem_write;
    o_branch <= branch;
    o_jump <= jump;
    o_rs1 <= rs1;
    o_rs2 <= rs2;
    o_rd <= rd;
end architecture RTL;