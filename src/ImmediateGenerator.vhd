library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity ImmediateGenerator is 
    generic (
        PC_WIDTH  : integer := 32;  -- instruction width 
        MEM_DEPTH : integer := 128   -- instruction depth 
    );
    port (
        i_instruction     : in std_ulogic_vector(PC_WIDTH-1 downto 0);
        i_immediate_type  : in std_ulogic_vector(1 downto 0); -- Immediate insturction select - "00" -> I-type immediate "01" -> Shift immediate
                                                              -- "10" -> Store type immediate, "11" -> Load type immediate.
        o_immediate       : out std_ulogic_vector(PC_WIDTH-1 downto 0)
    );
end entity ImmediateGenerator;

architecture RTL of ImmediateGenerator is 
    function imm_gen(inst : std_ulogic_vector(PC_WIDTH-1 downto 0),alui : std_ulogic_vector(1 downto 0)) return std_ulogic_vector is 
        variable imm : std_ulogic_vector(PC_WIDTH-1 downto 0);
        begin 
            case(alui) is   
                when "00" => 
                    imm := (31 downto 11 => inst(31)) & inst(30 downto 20);
                when "01" => 
                    imm := (31 downto 5 => '0') & inst(24 downto 20);
                when "10" => 
                    imm := (31 downto 11 => inst(31)) & inst(30 downto 25) & inst(11 downto 7);
                when "11" => 
                    imm := inst(31 downto 12) & (11 downto 0 => '0');
                when others => 
                    null;
            end case;
        return imm;
    end function imm_gen;

    begin 
        o_immediate <= imm_gen(i_instruction,i_immediate_type);
end architecture RTL;

    