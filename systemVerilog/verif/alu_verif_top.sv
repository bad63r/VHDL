module alu_verif_top;

   import umv_pkg::*;
`include "uvm_macros.svh"

   import alu_verif_pkg::*;

   //interface
   alu_if alu_vif;

   //DUT

   ALU_simple DUT(.a_in(alu_vif.a_in),
                  .b_in(alu_vif.b_in),
                  .op_i(alu_vif.op_i),
                  .res_o(alu_vif.res_o),
                  .zero_o(alu_vif.zero_o));


   //run test
   initial begin
      run_test();
   end

endmodule:alu_verif_top
