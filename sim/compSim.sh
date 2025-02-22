#!/bin/bash

WORK_DIR=work
WAVE_FILE=result.ghw
GTKPROJ_FILE=result.gtkw

# create work dir if it does not exist
mkdir -p $WORK_DIR

# importing source files
ghdl -i --workdir=$WORK_DIR ../src/ProgramCounter.vhd
ghdl -i --workdir=$WORK_DIR ../src/InstructionMemory.vhd
ghdl -i --workdir=$WORK_DIR ../src/ControlUnit.vhd
ghdl -i --workdir=$WORK_DIR ../src/RegisterFile.vhd
ghdl -i --workdir=$WORK_DIR ../src/ALU.vhd
ghdl -i --workdir=$WORK_DIR ../src/DataMemory.vhd

ghdl -i --workdir=$WORK_DIR ./tb_RISCV_SingleStage.vhd

# building simulation files
ghdl -m --workdir=$WORK_DIR tb

# running the simulation
ghdl -r --workdir=$WORK_DIR tb --wave=$WORK_DIR/$WAVE_FILE --stop-time=5ms

# open gtkwave with project with new waveform if project exists, if not then just open the waveform in new project
if [ -f $WORK_DIR/$GTKPROJ_FILE ]; then
   gtkwave $WORK_DIR/$GTKPROJ_FILE &
else
   gtkwave $WORK_DIR/$WAVE_FILE &
fi