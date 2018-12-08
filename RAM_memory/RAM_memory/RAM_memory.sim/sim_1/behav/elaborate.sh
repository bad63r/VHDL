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
ExecStep $xv_path/bin/xelab -wto 7ab39d9c511e42c6a8ceadc75ec7a573 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot RAM_memory_tb_behav xil_defaultlib.RAM_memory_tb -log elaborate.log
