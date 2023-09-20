module mac#(parameter VL = 8, parameter SEW = 32 )
(
				input clk,
				input  [VL*SEW-1:0] vector_a,
				input  [VL*SEW-1:0] vector_b,
				input  [VL*SEW-1:0] vd,
				input				valid,
				output done,
				output [VL*SEW-1:0] result_v
);
 
 
 reg [15:0] a0;
 reg [15:0] a1;
 reg [15:0] a2;
 reg [15:0] a3;
 reg [15:0] a4;
 reg [15:0] a5;
 reg [15:0] a6;
 reg [15:0] a7;
 
 reg [15:0] b0;
 reg [15:0] b1;
 reg [15:0] b2;
 reg [15:0] b3;
 reg [15:0] b4;
 reg [15:0] b5;
 reg [15:0] b6;
 reg [15:0] b7;
 
 wire [31:0] c0;
 wire [31:0] c1;
 wire [31:0] c2;
 wire [31:0] c3;
 wire [31:0] c4;
 wire [31:0] c5;
 wire [31:0] c6;
 wire [31:0] c7;
 
 reg [31:0] temp0;
 reg [31:0] temp1;
 reg [31:0] temp2;
 reg [31:0] temp3;
 reg [31:0] temp4;
 reg [31:0] temp5;
 reg [31:0] temp6;
 reg [31:0] temp7;
 
 wire [VL*SEW-1:0] ans;
 
 always@(posedge clk) begin
   if(valid) begin
   a0 = vector_a[0  +:16];
   a1 = vector_a[32 +:16];
   a2 = vector_a[64 +:16];
   a3 = vector_a[96 +:16];
   a4 = vector_a[128+:16];
   a5 = vector_a[160+:16];
   a6 = vector_a[192+:16];
   a7 = vector_a[224+:16];
   
   b0 = vector_b[0  +:16];
   b1 = vector_b[32 +:16];
   b2 = vector_b[64 +:16];
   b3 = vector_b[96 +:16];
   b4 = vector_b[128+:16];
   b5 = vector_b[160+:16];
   b6 = vector_b[192+:16];
   b7 = vector_b[224+:16];
   
   temp0 = vd[0  +:32];
   temp1 = vd[32 +:32];
   temp2 = vd[64 +:32];
   temp3 = vd[96 +:32];
   temp4 = vd[128+:32];
   temp5 = vd[160+:32];
   temp6 = vd[192+:32];
   temp7 = vd[224+:32];
   end
 end
 
 wallace w0(.ai(a0), .bi(b0), .result(c0));
 wallace w1(.ai(a1), .bi(b1), .result(c1));
 wallace w2(.ai(a2), .bi(b2), .result(c2));
 wallace w3(.ai(a3), .bi(b3), .result(c3));
 wallace w4(.ai(a4), .bi(b4), .result(c4));
 wallace w5(.ai(a5), .bi(b5), .result(c5));
 wallace w6(.ai(a6), .bi(b6), .result(c6));
 wallace w7(.ai(a7), .bi(b7), .result(c7));
 
 assign ans = {c7+temp7, c6+temp6, c5+temp5, c4+temp4, c3+temp3, c2+temp2, c1+temp1, c0+temp0};
 assign result_v = (valid) ? ans : 256'b0;

endmodule