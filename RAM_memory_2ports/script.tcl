#setting value to the resultDir variable
set resultDir ./result/
#make directory
file mkdir $resultDir

#create project in resultDir variable
create_project RAM_memory_2ports $resultDir \
-part xc7z020clg484-1 -force

#adding all files needed
add_files -norecurse ./RAM_memory_2ports.vhd
add_files -norecurse ./RAM_memory_2ports_tb.vhd -fileset sim_1

#removing junk
eval file delete [glob nocomplain *.log]
eval file delete [glob nocomplain *.jou]
