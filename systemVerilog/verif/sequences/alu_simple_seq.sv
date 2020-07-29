`ifndef ALU_SIMPLE_SEQ_SV
 `define ALU_SIMPLE_SEQ_SV

class alu_simple_seq extends alu_base_seq;
	 `uvm_object_utils(alu_simple_seq)

	 function new(string name="alu_simple_seq");
		  super.new(name);
	 endfunction


	 task body();
      //first step
      `uvm_do(req);
	 endtask: body
   

endclass: alu_simple_seq

`endif //  `ifndef ALU_SIMPLE_SEQ_SV

