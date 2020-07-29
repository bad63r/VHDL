class alu_monitor extends uvm_monitor;

	 uvm_analysis_port#(alu_tx) ap_mon;

	 `uvm_component_utils(alu_monitor)

	 virtual interface alu_if vif;

	 alu_tx txx;

	 function new(string name="alu_monitor", uvm_component parent = null);
		  super.new(name,parent);
      ap_mon = new("ap_mon", this);
	 endfunction

	 function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
		  if(!(uvm_config_db#(virtual alu_if)::get(this,"*","alu_if",vif))) 
			   `uvm_fatal("monitor","unable to get interface")
	 endfunction: connect_phase


	 task main_phase(uvm_phase phase);


     forever begin
		    txx = alu_tx::type_id::create("txx",this);

			  txx.a_in = vif.x;
			  txx.b_in = vif.y;
			  txx.op_i = vif.op_i;
			  txx.res_o = vif.res_o;
        txx.zero_o = vif.zero_o;

			  ap_mon.write(txx);
     end

	 endtask: main_phase
endclass

