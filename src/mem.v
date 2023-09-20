module mem( input  clk,
			input  rst,
			input  enable,  // result
			input  rw,      // read  0 write 1 
			output ready,
				
			input  [31:0] addr,
			input  [31:0] data_in,
			output [31:0] data_out
);
  
  reg [7:0] mem [1024];
  reg [31:0] data_out;
  reg ready;
  
  integer i;
  
  // read
  always @(posedge clk) begin
    if(!rst) begin
	  data_out <= 32'b0;
	  ready <= 0;
	end else if(!enable)begin  // if is not enable here works
	  data_out <= 32'b0;
	  ready <= 0;
	end else begin
	  if(enable & !(rw)) begin
	    data_out <= {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};
		ready <= 1;
	  end
	end
  end
  
  // write
  always @(posedge clk) begin
    if(!rst) begin
	  for (i = 0; i < 1024; i = i + 1)
		mem[i] <= 7'b0;
	  ready <= 0;
	end else begin 
	  if(enable & rw) begin
	    {mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]} <= data_in;
		ready <= 1;
	  end 
	end
  end
  

  
   
  
  
endmodule