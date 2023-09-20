module decoder #(parameter VL = 8, parameter SEW = 32 )
			   (input  clk,
				input  rst,
				input  stall,
				
				input      [31:0] instruction,
				input      [31:0] rs1_data,
				input      [31:0] rs2_data,
				input  [VL*SEW-1:0] vs1_data,
				input  [VL*SEW-1:0] vs2_data,
				input  [VL*SEW-1:0] vs3_data,
				output reg [ 3:0] sel_o,  // instruction sel
				output reg [ 3:0] operation_o, // for alu
				output reg [ 1:0] vci_o, // v or x or imm
				
				output reg reg_write,
				output reg data_access,
				output reg [ 4:0]  rd,
				output     [ 4:0]  rs1,
				output reg [ 4:0]  imm_5_o,
  
				// vector
				output reg [4:0]  vd,
				output [4:0]  vs1,
				output [4:0]  vs2,
				output [4:0]  vs3,
				output reg [11:0] imm_o,
				
				output reg [31:0] rs1_o,
				output reg [31:0] rs2_o,
				output reg [VL*SEW-1:0] vs1_o,
				output reg [VL*SEW-1:0] vs2_o,
				output reg [VL*SEW-1:0] vs3_o);

  // opcode
  parameter OP_ADDI  = 7'b0010011;
  parameter OP_VLE32 = 7'b0000111; // VL*unit-stride
  parameter OP_VSE32 = 7'b0100111; // VS*unit-stride
  parameter OP_ARITH = 7'b1010111; // Vector Arithmetic
  
  // funct3
  parameter OPIVV = 3'b000; // vector and vector
  parameter OPIVX = 3'b100; // vector and scalar
  parameter OPIVI = 3'b011; // vector and imm
  parameter OPMVX = 3'b110; // slide up and slide 
  
  // funct6
  parameter VADD  = 6'b000000;
  parameter VSUB  = 6'b000010;
  parameter VRSUB = 6'b000011;
  parameter VSLIDE1UP   = 6'b001110;
  parameter VSLIDE1DOWN = 6'b001111;
  parameter VMULADD = 6'b101101;
  
  // instruction
  parameter INST_ADDI  = 0;
  parameter INST_VLE32 = 1;
  parameter INST_VSE32 = 2;
  parameter INST_ARITH = 3;
  parameter OTHER = 4;
  
  parameter VEC_VEC = 0;
  parameter VEC_SCA = 1;
  parameter VEC_IMM = 2;
  
  //operation
  parameter SUB = 0;
  parameter ADD = 1;
  parameter SLIDE1UP = 2;
  parameter SLIDE1DOWN = 3;
  parameter MULADD = 5;
 
  wire [6:0] op_code;
  wire [2:0] func3;
  wire [5:0] func6;
  wire [3:0] sel;
  wire [3:0] operation;
  wire [1:0] vci; // vector or scalar or imm
  wire [4:0] imm_5;
  wire [11:0] imm;
  wire data_acc;
  
  assign op_code = instruction[6:0];
  assign func3 = instruction[14:12];
  assign func6 = instruction[31:26];
  assign rs1 = instruction[19:15];
  assign imm_5 = instruction[19:15];
  assign vs1 = instruction[19:15];
  assign vs2 = instruction[24:20];
  assign vs3 = instruction[11: 7];
  assign imm = instruction[31:20];
  
  assign sel = (op_code == OP_ADDI)  ? INST_ADDI :
			   (op_code == OP_VLE32) ? INST_VLE32 :	
			   (op_code == OP_VSE32) ? INST_VSE32 :
			   (op_code == OP_ARITH)  ? INST_ARITH : OTHER; // 4 is other
			   
  assign operation = (func6 == VADD) ? ADD :
					 (func6 == VSUB) ? SUB :
					 (func6 == VSLIDE1UP)   ? SLIDE1UP :
					 (func6 == VSLIDE1DOWN) ? SLIDE1DOWN :
					 (func6 == VMULADD)   ? MULADD :OTHER; // 4 is other
  assign vci = (func3 == OPIVV) ? VEC_VEC : 
			   (func3 == OPIVX) ? VEC_SCA :
			   (func3 == OPIVI) ? VEC_IMM : 3;
	
   	
  always@(posedge clk) begin
    if(!rst) begin
	  sel_o <= 4'b1111;
	  rd <= 5'b0;
	  vd <= 5'b0; 
	  data_access <= 0;
	  imm_o <= 12'b0;
	  rs1_o <= 32'b0;
	  rs2_o <= 32'b0;
	  vs1_o <= 32'b0;
	  vs2_o <= 32'b0;
	  vs3_o <= 32'b0;
	  operation_o <= 3'b111;
	  vci_o <= 2'b11;
	  imm_5_o <= 5'b0;
	end else if (stall) begin
	  sel_o <= sel_o;
	  rd <= rd;
	  vd <= vd; 
	 // data_access <= 0;
	//  reg_write <= 0;
	  imm_o <= imm_o;
	  rs1_o <= rs1_o;
	  rs2_o <= rs2_o;
	  vs1_o <= vs1_o;
	  vs2_o <= vs2_o;
	  vs3_o <= vs3_o;
	  operation_o <= operation_o;
	  vci_o <= vci_o;
	  imm_5_o <= imm_5_o;
	end else begin
	  sel_o <= sel;
	  rd <= instruction[11:7];
	  vd <= instruction[11:7];
	  rs1_o <= rs1_data;
	  rs2_o <= rs2_data;
	  imm_o <= imm;
	  vs1_o <= vs1_data;
	  vs2_o <= vs2_data;
	  vs3_o <= vs3_data;
	  operation_o <= operation;
	  vci_o <= vci;
	  imm_5_o<= imm_5;
	  
	  if (sel == INST_VLE32 | sel == INST_VSE32)
	    data_access <= 1;
	  else 
	    data_access <= 0;
	  if(sel != INST_VSE32 && sel != OTHER)
	    reg_write <= 1;
	  else 
	    reg_write <= 0;
	  
	end
  end
  
endmodule