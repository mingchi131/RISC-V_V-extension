module write_back#(parameter VL = 8, parameter SEW = 32 )
				  (input stall,
				   input reg_write,
				   input  [31:0] data_m_s,
				   input  [31:0] data_alu_s,
				   
				   input  [VL*SEW-1:0] data_m_v,
				   input  [VL*SEW-1:0] data_alu_v,
				   input  [ 4:0] vd,
				   input  [ 4:0] rd,
				   input  [ 3:0] sel,
				   input  is_v,
				   input  is_s,
				   
				   output  is_v_o,
				   output  is_s_o,
				   output [31:0] data_s,
				   output [VL*SEW-1:0] data_v,
				   output [ 4:0] vd_o,
				   output [ 4:0] rd_o,
				   output write);  // for store

 
  parameter INST_ADDI  = 0;
  parameter INST_VLE32 = 1;
  parameter INST_VSE32 = 2;
  parameter INST_ARITH  = 3;
 
  assign write = reg_write;
  assign is_s_o = is_s;
  assign is_v_o = is_v;
  assign vd_o = vd;
  assign rd_o = rd;
  assign data_s = (sel == INST_ADDI) ? data_alu_s : data_m_s; // since no support scalar store 
  assign data_v = (sel == INST_ARITH) ? data_alu_v : 
				  (sel == INST_VLE32) ? data_m_v : 256'b0;

endmodule