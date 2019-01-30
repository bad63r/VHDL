#setting value to the resultDir variable
set resultDir ./result/
#make directory
file mkdir $resultDir

#create project in resultDir variable
create_project and_gate $resultDir \
    -part xc7z020clg484-1 -force

#adding all files needed
add_files -norecurse ./behavioral_model.vhd
add_files -norecurse ./test_bench.vhd -fileset sim_1

#removing junk
eval file delete [glob nocomplain *.log]
eval file delete [glob nocomplain *.jou]
