class alu_seq_10 extends alu_base_seq;
	 `uvm_object_utils(alu_seq_10)
	 function new(string name="alu_seq_10");
		  super.new(name);
		  txn = new();
	 endfunction



	 task body();
		  start_item(txn);
		  repeat(10) begin
			   
			   assert(txn.randomize());
		  end
		  finish_item(txn);
	 endtask
endclass
