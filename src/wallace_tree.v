module wallace#(parameter VL = 8, parameter SEW = 32 )
(
				input  [SEW/2-1:0] ai,  // 16
				input  [SEW/2-1:0] bi,  // 16
				
				output [SEW-1:0] result
);
 
 wire [31:0] sum1_3;     // 1
 wire [31:0] carry1_3;   // 2
 wire [31:0] sum4_6;     // 3
 wire [31:0] carry4_6;   // 4
 wire [31:0] sum7_9;     // 5
 wire [31:0] carry7_9;   // 6
 wire [31:0] sum10_12;   // 7
 wire [31:0] carry10_12; // 8
 wire [31:0] sum13_15;   // 9
 wire [31:0] carry13_15; // 10 
 
 //wire [31:0] sum16;      // 11
 
 wire [31:0] sum2_1_3;     // 1
 wire [31:0] carry2_1_3;   // 2
 wire [31:0] sum2_4_6;     // 3
 wire [31:0] carry2_4_6;   // 4
 wire [31:0] sum2_7_9;     // 5
 wire [31:0] carry2_7_9;   // 6
 wire [31:0] sum2_10_11;   // 7
 wire [31:0] carry2_10_11; // 8
 
 wire [31:0] sum3_1_3;     // 1
 wire [31:0] carry3_1_3;   // 2
 wire [31:0] sum3_4_6;     // 3
 wire [31:0] carry3_4_6;   // 4
 wire [31:0] sum3_7_8;     // 5
 wire [31:0] carry3_7_8;   // 6
 
 wire [31:0] sum4_1_3;     // 1
 wire [31:0] carry4_1_3;   // 2
 wire [31:0] sum4_4_6;     // 3
 wire [31:0] carry4_4_6;   // 4
 
 wire [31:0] sum5_1_3;     // 1
 wire [31:0] carry5_1_3;   // 2
 //wire [31:0] sum5_4;       // 3  // 
 
 wire [31:0] sum6_1_3;     // 1
 wire [31:0] carry6_1_3;   // 2
 
 wire [15:0] r1;
 wire [15:0] r2;
 wire [15:0]r3; 
 wire [15:0]r4; 
 wire [15:0]r5; 
 wire [15:0]r6; 
 wire [15:0]r7; 
 wire [15:0]r8; 
 wire [15:0]r9; 
 wire [15:0]r10; 
 wire [15:0]r11; 
 wire [15:0]r12; 
 wire [15:0]r13; 
 wire [15:0]r14; 
 wire [15:0]r15; 
 wire [15:0]r16;
 wire [31:0] p0; 
 wire [31:0]p1;
 wire [31:0]p2; 
 wire [31:0]p3; 
 wire [31:0]p4; 
 wire [31:0]p5; 
 wire [31:0]p6; 
 wire [31:0]p7; 
 wire [31:0]p8; 
 wire [31:0]p9; 
 wire [31:0]p10; 
 wire [31:0]p11; 
 wire [31:0]p12; 
 wire [31:0]p13; 
 wire [31:0]p14; 
 wire [31:0]p15;
 
 assign r1[15:0] =  {16{bi[0]}};
 assign r2[15:0] =  {16{bi[1]}};
 assign r3[15:0] =  {16{bi[2]}};
 assign r4[15:0] =  {16{bi[3]}};
 assign r5[15:0] =  {16{bi[4]}};
 assign r6[15:0] =  {16{bi[5]}};
 assign r7[15:0] =  {16{bi[6]}};
 assign r8[15:0] =  {16{bi[7]}};
 assign r9[15:0] =  {16{bi[8]}};
 assign r10[15:0] =  {16{bi[9]}};
 assign r11[15:0] =  {16{bi[10]}};
 assign r12[15:0] =  {16{bi[11]}};
 assign r13[15:0] =  {16{bi[12]}};
 assign r14[15:0] =  {16{bi[13]}};
 assign r15[15:0] =  {16{bi[14]}};
 assign r16[15:0] =  {16{bi[15]}};
	 
 assign p0={16'b0,ai&r1};
 assign p1={15'b0,ai&r2,1'b0};
 assign p2={14'b0,ai&r3,2'b0};
 assign p3={13'b0,ai&r4,3'b0};
 assign p4={12'b0,ai&r5,4'b0};
 assign p5={11'b0,ai&r6,5'b0};
 assign p6={10'b0,ai&r7,6'b0};
 assign p7={9'b0,ai&r8,7'b0};
 assign p8={8'b0,ai&r9,8'b0};
 assign p9={7'b0,ai&r10,9'b0};
 assign p10={6'b0,ai&r11,10'b0};
 assign p11={5'b0,ai&r12,11'b0};
 assign p12={4'b0,ai&r13,12'b0};
 assign p13={3'b0,ai&r14,13'b0};
 assign p14={2'b0,ai&r15,14'b0};
 assign p15={1'b0,ai&r16,15'b0};
 
 adder a0(.a(p0), .b(p1), .c(p2), .sum(sum1_3), .carry(carry1_3));
 adder a1(.a(p3), .b(p4), .c(p5), .sum(sum4_6), .carry(carry4_6));
 adder a2(.a(p6), .b(p7), .c(p8), .sum(sum7_9), .carry(carry7_9));
 adder a3(.a(p9), .b(p10), .c(p11), .sum(sum10_12), .carry(carry10_12));
 adder a4(.a(p12), .b(p13), .c(p14), .sum(sum13_15), .carry(carry13_15));  //16
 
 adder a5(.a(sum1_3), .b(carry1_3), .c(sum4_6), .sum(sum2_1_3), .carry(carry2_1_3));
 adder a6(.a(carry4_6), .b(sum7_9), .c(carry7_9), .sum(sum2_4_6), .carry(carry2_4_6));
 adder a7(.a(sum10_12), .b(carry10_12), .c(sum13_15), .sum(sum2_7_9), .carry(carry2_7_9));
 adder a8(.a(carry13_15), .b(p15), .c(32'b0), .sum(sum2_10_11), .carry(carry2_10_11));
 
 adder a9(.a(sum2_1_3), .b(carry2_1_3), .c(sum2_4_6), .sum(sum3_1_3), .carry(carry3_1_3));
 adder a10(.a(carry2_4_6), .b(sum2_7_9), .c(carry2_7_9), .sum(sum3_4_6), .carry(carry3_4_6));
 adder a11(.a(sum2_10_11), .b(carry2_10_11), .c(32'b0), .sum(sum3_7_8), .carry(carry3_7_8));
 
 adder a12(.a(sum3_1_3), .b(carry3_1_3), .c(sum3_4_6), .sum(sum4_1_3), .carry(carry4_1_3));
 adder a13(.a(carry3_4_6), .b(sum3_7_8), .c(carry3_7_8), .sum(sum4_4_6), .carry(carry4_4_6));
 
 adder a14(.a(sum4_1_3), .b(carry4_1_3), .c(sum4_4_6), .sum(sum5_1_3), .carry(carry5_1_3));
 
 adder a15(.a(sum5_1_3), .b(carry5_1_3), .c(carry4_4_6), .sum(sum6_1_3), .carry(carry6_1_3));
 
 //adder a16(.a(sum6_1_3), .b(carry6_1_3), .c(32'b0), .sum(sum1_3), .carry(carry1_3));
 assign result = sum6_1_3 + carry6_1_3;
 
 
 
 

endmodule

