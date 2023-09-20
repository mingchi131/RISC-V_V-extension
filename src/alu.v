module alu#(parameter VL = 8, parameter SEW = 32 )
(
				input  [31:0] scalar_a,
				input  [31:0] scalar_b,
				input  [VL*SEW-1:0] vector_a,
				input  [VL*SEW-1:0] vector_b,
				
				input  [3:0] operation, // 0 is add
				input  is_v, // is vector
				input  is_s, // is scalar
				
				output reg [31:0] result_s,
				output reg [VL*SEW-1:0] result_v
);
 
 parameter SUB = 0;
 parameter ADD = 1;
 parameter SLIDE1UP = 2;
 parameter SLIDE1DOWN = 3;
 
 
 always@(*) begin
   if(is_s) 
       result_s = scalar_a + scalar_b;
   else if(operation == ADD) begin
      if(is_v) begin
       //result_v = vector_a + vector_b; // check whether over time slice
	   result_v[0  +:32] = vector_a[0  +:32] + vector_b[0  +:32];
       result_v[32 +:32] = vector_a[32 +:32] + vector_b[32 +:32];
       result_v[64 +:32] = vector_a[64 +:32] + vector_b[64 +:32];
       result_v[96 +:32] = vector_a[96 +:32] + vector_b[96 +:32];
       result_v[128+:32] = vector_a[128+:32] + vector_b[128+:32];
       result_v[160+:32] = vector_a[160+:32] + vector_b[160+:32];
       result_v[192+:32] = vector_a[192+:32] + vector_b[192+:32];
	   result_v[224+:32] = vector_a[224+:32] + vector_b[224+:32];
	 end
   end else if(operation == SUB) begin
     if(is_s) begin
       result_s = scalar_a - scalar_b;
	 end else if (is_v) begin
	   result_v[0  +:32] = vector_a[0  +:32] - vector_b[0  +:32];
       result_v[32 +:32] = vector_a[32 +:32] - vector_b[32 +:32];
       result_v[64 +:32] = vector_a[64 +:32] - vector_b[64 +:32];
       result_v[96 +:32] = vector_a[96 +:32] - vector_b[96 +:32];
       result_v[128+:32] = vector_a[128+:32] - vector_b[128+:32];
       result_v[160+:32] = vector_a[160+:32] - vector_b[160+:32];
       result_v[192+:32] = vector_a[192+:32] - vector_b[192+:32];
	   result_v[224+:32] = vector_a[224+:32] - vector_b[224+:32];
	 end
   end else if(operation == SLIDE1UP) begin
     result_v[0  +:32] = scalar_a;
     result_v[32 +:32] = vector_b[0  +:32];
     result_v[64 +:32] = vector_b[32 +:32];
     result_v[96 +:32] = vector_b[64 +:32];
     result_v[128+:32] = vector_b[96 +:32];
     result_v[160+:32] = vector_b[128+:32];
     result_v[192+:32] = vector_b[160+:32];
	 result_v[224+:32] = vector_b[192+:32];
   end else if(operation == SLIDE1DOWN) begin
     result_v[0  +:32] = vector_b[32 +:32];
     result_v[32 +:32] = vector_b[64 +:32];
     result_v[64 +:32] = vector_b[96 +:32];
     result_v[96 +:32] = vector_b[128+:32];
     result_v[128+:32] = vector_b[160+:32];
     result_v[160+:32] = vector_b[192+:32];
     result_v[192+:32] = vector_b[224+:32];
	 result_v[224+:32] = scalar_a;
   end
 end

endmodule