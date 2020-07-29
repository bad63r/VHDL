class alu_agent extends uvm_agent;

   //components
	 alu_driver driver;
	 alu_sequencer sqr;
	 alu_monitor mon;
   //config
   alu_config cfg;


	 `uvm_component_utils(alu_agent)
      `uvm_field_object(cfg, UVM_DEFAULT)
   `uvm_component_utils_end


	 function new(string name="alu_agent",uvm_component parent=null);
		  super.new(name,parent);
	 endfunction

   

	 function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(alu_config)::get(this,"","alu_config",cfg))
         `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})

		  mon = alu_monitor::type_id::create("mon",this);
      if (cfg.is_active == UVM_ACTIVE) begin
		     driver = alu_driver::type_id::create("driver",this);
		     sqr = alu_sequencer::type_id::create("sqr",this);
      end
      
	 endfunction: build_phase

	 function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (cfg.is_active == UVM_ACTIVE) begin
		     driver.seq_item_port.connect(sqr.seq_item_export);
      end
	 endfunction:connect_phase

endclass: alu_agent
