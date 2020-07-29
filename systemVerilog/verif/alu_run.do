# Creating library
if [ file exists work ] {
   vdel -all
}
vlib work

# compile DUT
vcom ALU_simple.vhd

# compile testbench
vlog +acc +incdir+$env(UVM_HOME) -sv \
     ./*alu_verif_pkg.sv \
     ./*alu_verif_top.sv

