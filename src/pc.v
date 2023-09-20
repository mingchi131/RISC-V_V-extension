module pc(input clk,
		  input rst,
		  input flag,
		  input stall,
		  //input  [31:0] pc,
		  output reg [31:0] pc);
		  
  always@(posedge clk) begin
    if(!rst) begin
	  pc <= 32'b0;
	//end else if (stall)begin 
	//  pc <= pc;
	end else if(flag) begin
	  pc <= pc + 4;
	end
  end
  
  
endmodule