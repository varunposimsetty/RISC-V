#!/bin/bash

WORK_DIR=work
WAVE_FILE=result.ghw
GTKPROJ_FILE=result.gtkw
VCD_FILE=result.vcd
SAIF_FILE=result.saif

# create work dir if it does not exist
mkdir -p $WORK_DIR
# importing source files
ghdl -i --workdir=$WORK_DIR ../src/Single_Cycle_Core.vhd
ghdl -i --workdir=$WORK_DIR ../src/RISC_V_SC_System.vhd
ghdl -i --workdir=$WORK_DIR ../src/RegisterFile.vhd
ghdl -i --workdir=$WORK_DIR ../src/ProgramCounter.vhd
ghdl -i --workdir=$WORK_DIR ../src/Mux4x32.vhd
ghdl -i --workdir=$WORK_DIR ../src/Mux2x32.vhd
ghdl -i --workdir=$WORK_DIR ../src/JALR_Address.vhd
ghdl -i --workdir=$WORK_DIR ../src/JAL_Address.vhd
ghdl -i --workdir=$WORK_DIR ../src/InstructionMemory.vhd
ghdl -i --workdir=$WORK_DIR ../src/ImmediateGenerator.vhd
ghdl -i --workdir=$WORK_DIR ../src/DataMemory.vhd
ghdl -i --workdir=$WORK_DIR ../src/D_FF.vhd
ghdl -i --workdir=$WORK_DIR ../src/ControlUnit.vhd
ghdl -i --workdir=$WORK_DIR ../src/BranchAddress.vhd
ghdl -i --workdir=$WORK_DIR ../src/ALU.vhd

ghdl -i --workdir=$WORK_DIR ./tb_RISCV_SingleStage.vhd

# building simulation files
ghdl -m --workdir=$WORK_DIR tb

# running the simulation
ghdl -r --workdir="$WORK_DIR" tb --wave="$WORK_DIR/$WAVE_FILE" --vcd="$WORK_DIR/$VCD_FILE" --stop-time=1ms

python3 ./vcd_automation.py -i "$WORK_DIR/$VCD_FILE" --vdd 1.2 --ceff 2e-15

#python3 ./vcd2saif.py "$WORK_DIR/$VCD_FILE" "$WORK_DIR/${VCD_FILE%.vcd}.saif"

# running the simulation
#ghdl -r --workdir=$WORK_DIR tb_multi_bank_memory --wave=$WORK_DIR/result.vcd --stop-time=1ms

# open gtkwave with project with new waveform if project exists, if not then just open the waveform in new project
if [ -f $WORK_DIR/$GTKPROJ_FILE ]; then
   gtkwave $WORK_DIR/$GTKPROJ_FILE &
else
   gtkwave $WORK_DIR/$WAVE_FILE &
fi