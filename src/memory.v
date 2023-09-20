module memory#(parameter VL = 8, parameter SEW = 32 )
			  (input  clk,
			   input  rst,
			   input  stall,
			   input  reg_write,
			  
			   input  is_v,
			   input  is_s,
			   input  [ 4:0] rd,
			   input  [ 4:0] vd,
			   input  [ 3:0] sel,
			   input  [31:0] rs1_addr,
			   input  [31:0] result_s,
			   input  [VL*SEW-1:0] result_v,
			   
			   input data_access_flag,
			   input data_access_on,
			   
			   output reg reg_write_o,
			   output reg [ 4:0] sel_MEM,
			   output reg [31:0] rs1_addr_MEM,
			   output reg [VL*SEW-1:0] data_v_MEM,
			  
			   output reg is_v_o,
			   output reg is_s_o,
			   output reg [ 4:0] rd_o,
			   output reg [ 4:0] vd_o,
			   output reg [ 3:0] sel_o,
			   output reg [31:0] result_s_o,
			   output reg [VL*SEW-1:0] result_v_o);
  
  
  
  always@(*) begin
     if(data_access_flag & !data_access_on) begin
	   sel_MEM = sel;
	   rs1_addr_MEM = rs1_addr;
	   data_v_MEM = result_v;
	 end 
  end
   
  
  always@(posedge clk) begin
    if(!rst) begin
	  sel_o <= 4'b1111;
	  rd_o <= 5'b0;
	  vd_o <= 5'b0; 
	  result_s_o <= 31'b0;
	  result_v_o <= 256'b0;
	  is_s_o <= 0;
	  is_v_o <= 0;
	  reg_write_o <= 0;
	end else if (stall) begin
	  sel_o <= sel_o;
	  rd_o <= rd_o;
	  vd_o <= vd_o; 
	  result_s_o <= result_s_o;
	  result_v_o <= result_v_o;
	  is_s_o <= is_s_o;
	  is_v_o <= is_v_o;
	  reg_write_o <= reg_write_o;
	end else begin
	  sel_o <= sel;
	  rd_o <= rd;
	  vd_o <= vd; 
	  result_s_o <= result_s;
	  result_v_o <= result_v;
	  is_s_o <= is_s;
	  is_v_o <= is_v;
	  reg_write_o <= reg_write;
	end
  end
  
endmodule
  
