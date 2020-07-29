`ifndef TEST_BASE_SV
 `define TEST_BASE_SV



class test_base extends uvm_test;

   alu_env env;
   alu_config cfg;

   `uvm_component_utils(test_base)

   function new(string name = "test_base", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
		  env = alu_env::type_id::create("env",this);
      cfg = alu_config::type_id::create("cfg");
      uvm_config_db#(alu_config)::set(this,"*","alu_config",cfg);
   endfunction : build_phase

   function void end_of_elaboration_phase(umv_phase phase);
      super.end_of_elaboration_phase(phase);
      uvm_top.print_topology();
   endfunction: end_of_elaboration_phase

endclass : test_base

`endif
