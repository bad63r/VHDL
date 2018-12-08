#!/bin/bash -f
xv_path="/home/bad63r/Vivado/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim RAM_memory_tb_behav -key {Behavioral:sim_1:Functional:RAM_memory_tb} -tclbatch RAM_memory_tb.tcl -view /home/bad63r/Projects/RAM_memory/RAM_memory_tb_behav.wcfg -log simulate.log
