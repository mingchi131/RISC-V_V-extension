module vector_reg#(parameter VL = 8, parameter SEW = 32 )
				  (input clk,
				   input rst,
			
				   input write,
				   input is_v,
				   input [ 4:0] vs1_addr,
				   input [ 4:0] vs2_addr,
				   input [ 4:0] vs3_addr,
				   input [ 4:0] vd_addr,
				   input [VL*SEW-1:0] data,
				  
				   output [VL*SEW-1:0] vs1_data,
				   output [VL*SEW-1:0] vs2_data,
				   output [VL*SEW-1:0] vs3_data);
	
  
  reg [VL*SEW-1:0] v[32];
  
  assign vs1_data = v[vs1_addr];
  assign vs2_data = v[vs2_addr];
  assign vs3_data = v[vs3_addr];
		  
  always@(posedge clk) begin
    if(!rst) begin
	  v[ 0] <= 0; v[ 1] <= 0; v[ 2] <= 0; v[ 3] <= 0; v[ 4] <= 0; v[ 5] <= 0; v[ 6] <= 0; v[ 7] <= 0;
      v[ 8] <= 0; v[ 9] <= 0; v[10] <= 0; v[11] <= 0; v[12] <= 0; v[13] <= 0; v[14] <= 0; v[15] <= 0;
      v[16] <= 0; v[17] <= 0; v[18] <= 0; v[19] <= 0; v[20] <= 0; v[21] <= 0; v[22] <= 0; v[23] <= 0;
      v[24] <= 0; v[25] <= 0; v[26] <= 0; v[27] <= 0; v[28] <= 0; v[29] <= 0; v[30] <= 0; v[31] <= 0;
	end else if(write & is_v) begin
	  v[vd_addr] <= data;
	end
  end
  
  
endmodule