module scalar_reg(input clk,
				  input rst,
			
				  input write,
				  input is_s,
				  input [ 4:0] rs1_addr,
				  input [ 4:0] rs2_addr,
				  input [ 4:0] rd_addr,
				  input [31:0] data,
				  
				  output [31:0] rs1_data,
				  output [31:0] rs2_data);
				  
  reg [31:0] x[32];
  
  assign rs1_data = x[rs1_addr];
  assign rs2_data = x[rs2_addr];
		  
  always@(posedge clk) begin
    if(!rst) begin
	  x[ 0] <= 0; x[ 1] <= 0; x[ 2] <= 0; x[ 3] <= 0; x[ 4] <= 0; x[ 5] <= 0; x[ 6] <= 0; x[ 7] <= 0;
      x[ 8] <= 0; x[ 9] <= 0; x[10] <= 0; x[11] <= 0; x[12] <= 0; x[13] <= 0; x[14] <= 0; x[15] <= 0;
      x[16] <= 0; x[17] <= 0; x[18] <= 0; x[19] <= 0; x[20] <= 0; x[21] <= 0; x[22] <= 0; x[23] <= 0;
      x[24] <= 0; x[25] <= 0; x[26] <= 0; x[27] <= 0; x[28] <= 0; x[29] <= 0; x[30] <= 0; x[31] <= 0;
	end else if(write & is_s) begin
	  x[rd_addr] <= data;
	end
  end
  
  
endmodule