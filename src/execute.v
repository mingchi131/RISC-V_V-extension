module execute#(parameter VL = 8, parameter SEW = 32 )
			   (input  clk,
				input  rst,
				input  stall,
				input  data_access,
				input  reg_write,
				input [ 3:0] sel, // instruction sel
				input [ 3:0] operation,
				input [ 1:0] vci,
				
				input [4:0]  rd,
				input [4:0]  imm_5,
  
				// vector
				input [4:0]  vd,
				//input [4:0]  vs1;
				//input [4:0]  vs2;
				//input [4:0]  vs3;
				input [11:0] imm,
				
				input  [31:0] rs1_data,
				input  [31:0] rs2_data,
				input  [VL*SEW-1:0] vs1_data,
				input  [VL*SEW-1:0] vs2_data,
				input  [VL*SEW-1:0] vs3_data,
				
				output reg data_access_o,
				output reg reg_write_o,
				output reg is_v,
				output reg is_s,
				output reg [ 4:0] rd_o,
				output reg [ 4:0] vd_o,
				output reg [ 3:0] sel_o,
				output reg [31:0] rs1_data_o,
				output reg [31:0] result_s,
				output reg [VL*SEW-1:0] result_v);
  
  
  //reg [31:0] x[32];
  //reg [VL*SEW-1:0] v[32];

  parameter INST_ADDI  = 0;
  parameter INST_VLE32 = 1;
  parameter INST_VSE32 = 2;
  parameter INST_VADD  = 3;
  
  parameter VEC_VEC = 0;
  parameter VEC_SCA = 1;
  parameter VEC_IMM = 2;
  
  parameter MULADD = 5;

  wire [31:0] sign_extended_imm5;
  wire [31:0] result_scalar;
  wire [31:0] alu_b;
  wire [VL*SEW-1:0] result_vector;
  wire [VL*SEW-1:0] result_mac;
  wire [VL*SEW-1:0] vector_a;
  wire is_vector;
  wire is_scalar;
  wire mac_valid;
  wire done_mac;
  
  assign mac_valid = (operation == MULADD);
  
  assign is_vector = (sel == 1 || sel == 2 || sel == 3);
  assign is_scalar = (sel == 0);
  assign alu_b = imm[11] ? {20'b1, imm} : {20'b0, imm};  // sign extension
  
  assign sign_extended_imm5 = imm_5[4] ? {27'b1, imm_5} : {27'b0, imm_5};
  
  assign vector_a = (vci == VEC_VEC) ? vs1_data :
				    (vci == VEC_SCA) ? {8{rs1_data}} : 
					(vci == VEC_IMM) ? {8{sign_extended_imm5}} : 256'b0;
  
  always@(posedge clk) begin
    if(!rst) begin
	  sel_o <= 4'b1111;
	  rd_o <= 5'b0;
	  vd_o <= 5'b0; 
	  result_s <= 31'b0;
	  result_v <= 256'b0;
	  is_s <= 0;
	  is_v <= 0;
	  rs1_data_o <= 32'b0;
	  data_access_o <= 0;
	  reg_write_o <= 0;
	end else if (stall) begin
	  sel_o <= sel_o;
	  rd_o <= rd_o;
	  vd_o <= vd_o; 
	  result_s <= result_s;
	  result_v <= result_v;
	  is_s <= is_s;
	  is_v <= is_v;
	  rs1_data_o <= rs1_data_o;
	  data_access_o <= data_access_o;
	  reg_write_o <= reg_write_o;
	end else begin
	  sel_o <= sel;
	  rd_o <= rd;
	  vd_o <= vd; 
	  is_s <= is_scalar;
	  is_v <= is_vector;
	  rs1_data_o <= rs1_data;
	  data_access_o <= data_access;
	  reg_write_o <= reg_write;
	  
	  if(sel == INST_ADDI)
	    result_s <= result_scalar;
		
	  if(sel == INST_VADD)
	    if(operation == MULADD)
		  result_v <= result_mac;
		else
	      result_v <= result_vector;
	  else if(sel == INST_VSE32) 
	    result_v <= vs3_data;
	 // else if(sel == INST_VLE32)
	   // result_v <= 
	end
  end
  
   alu #(.VL(8), .SEW(32)) alu0
		   (.scalar_a(rs1_data),
			.scalar_b(alu_b),
			.vector_a(vector_a),
			.vector_b(vs2_data),
				
			.operation(operation), // 0 is add
			.is_v(is_vector), // is vector
			.is_s(is_scalar), // is scalar
				
			.result_s(result_scalar),
			.result_v(result_vector));
			
	mac #(.VL(8), .SEW(32)) mac0
			(.clk(clk),
			 .vector_a(vs1_data),
			 .vector_b(vs2_data),
			 .valid(mac_valid),
			 .vd(vs3_data),
			 .done(done_mac),
			 .result_v(result_mac));

  

endmodule