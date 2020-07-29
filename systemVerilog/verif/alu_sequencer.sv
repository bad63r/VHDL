`ifndef ALU_SEQUENCER_SV
 `define ALU_SEQUENCER_SV

class alu_sequencer extends uvm_sequencer#(alu_tx);
	 `uvm_component_utils(alu_sequencer)

	 function new(string name="alu_sequencer", uvm_component parent = null);
		  super.new(name,parent);
	 endfunction
endclass

`endif //  `ifndef ALU_SEQUENCER_SV
