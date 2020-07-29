`ifndef ALU_TX_SV
`define ALU_TX_SV

parameter WIDTH = 32;

class alu_tx extends uvm_sequence_item;
	 rand logic [WIDTH-1 : 0] a_in;
	 rand logic [WIDTH-1 : 0] b_in;
	 rand logic [2 : 0] op_i;
   logic [WIDTH-1 : 0] res_o;
   logic               zero_o;

	 `uvm_object_utils_begin(alu_tx)
		  `uvm_field_int(a_in,UVM_ALL_ON)
		  `uvm_field_int(b_in,UVM_ALL_ON)
		  `uvm_field_int(op_i,UVM_ALL_ON)
      `uvm_field_int(res_o,UVM_ALL_ON)
      `uvm_field_int(zero_o,UVM_ALL_ON)
	 `uvm_object_utils_end

	 function new(string name ="alu_tx");
		  super.new(name);
	 endfunction: new
endclass


`endif
