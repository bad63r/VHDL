`ifndef ALU_IF_SV
 `define ALU_IF_SV

interface alu_if();

   parameter WIDTH = 32;

	 logic [WIDTH-1 : 0] a_in;
	 logic [WIDTH-1 : 0] b_in;
	 logic [2 : 0] op_i;
	 logic [WIDTH-1 : 0] res_o;
   logic               zero_o;
endinterface: alu_if

`endif //  `ifndef ALU_IF_SV
