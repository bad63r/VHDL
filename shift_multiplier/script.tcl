#setting value to the resultDir variable
set resultDir ./result/
#make directory
file mkdir $resultDir

#create project in resultDir variable
create_project shift_multiplier $resultDir \
-part xc7z020clg484-1 -force

# adding all files needed
add_files -norecurse ./shift_multiplier.vhd
add_files ./shift_multiplier_tb.vhd -fileset sim_1

#removing junk shit
eval file delete [glob nocomplain *.log]
eval file delete [glob nocomplain *.jou]
