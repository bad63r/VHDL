# RAM memory with 2 ports
It is basically the same RAM as previous one just with 2 ports now. It was verified, just I'm not sure what will happen in case of trying to write to the same 
address from different ports(race condition?). 

Overall I think this is not big deal if you have in mind that there are write enable ports and if you know the design limitations. 

## Create project in Vivado with tcl script
Go to the directory where you downloaded the files(type `pwd` to see where you are and use `cd name_of_directory` to go to the destination).
In the Tcl console run: `source script.tcl`. It will set whole project for you :)
