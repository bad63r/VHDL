#setting value for the resultDir variable
set resultDir ./result/
#make directory
file mkdir $resultDir

#create project in resultDir variable
create_project SP_generic_CONVERTER $resultDir \
-part xc7z020clg484-1 -force

#adding all files needed
add_files ./sp_converter_for_generate.vhd
add_files ./sp_converter_for_generate_tb.vhd -fileset sim_1

#removing junk
eval file delete [glob nocomplain *.log]
eval file delete [glob nocomplain *.jou]
