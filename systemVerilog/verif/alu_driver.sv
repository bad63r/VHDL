`ifndef ALU_DRIVER_SV
 `define ALU_DRIVER_SV

class alu_driver extends uvm_driver#(alu_tx);
	 `uvm_component_utils(alu_driver)

	 virtual interface alu_if vif;

   
	 function new(string name="alu_driver", uvm_component parent = null);
		  super.new(name,parent);
	 endfunction

	 //alu_tx tx;

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual alu_if)::get(this, "*", "alu_if", vif))
         `uvm_fatal("NOVIF", {"virtual interface must be set: ", get_full_name(), ".vif"})
   endfunction: connect_phase


	 task main_phase(uvm_phase phase);
		  forever begin
			   seq_item_port.get_next_item(tx);
         `uvm_info(get_type_name(), $sformatf("Driver sending... \n%s", tx.sprint()), UVM_HIGH)

				    vif.a_in <= tx.a_in;
				    vif.b_in <= tx.b_in;
            vif.op_i <= tx.op_i;

			   seq_item_port.item_done();
		  end
	 endtask: main_phase
endclass: alu_driver

`endif //  `ifndef ALU_DRIVER_SV
