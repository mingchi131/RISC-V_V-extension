module instruction_fetch(input  clk,
						 input  rst,
						 input  [31:0]instruction_i,
						 input  stall,
						 
						 //input  [31:0] pc_addr,
						 output reg [31:0] instruction_o);

  
  always@(posedge clk) begin
    if(!rst) begin
	  instruction_o <= 32'b0;
	end else begin
	  if(stall)
	    instruction_o <= instruction_o;
	  else 
	    instruction_o <= instruction_i;
	end
  end
  
endmodule
  
