module adder(input  [31:0] a,
			 input  [31:0] b,
			 input  [31:0] c,
			 output [31:0] sum,
			 output [31:0] carry);
   
wire tem0, tem1;
assign carry[0] = 0;
bit_adder a0(.a(a[0]), .b(b[0]), .c(c[0]), .sum(sum[0]), .carry(carry[1]));
bit_adder a1(.a(a[1]), .b(b[1]), .c(c[1]), .sum(sum[1]), .carry(carry[2]));
bit_adder a2(.a(a[2]), .b(b[2]), .c(c[2]), .sum(sum[2]), .carry(carry[3]));
bit_adder a3(.a(a[3]), .b(b[3]), .c(c[3]), .sum(sum[3]), .carry(carry[4]));
bit_adder a4(.a(a[4]), .b(b[4]), .c(c[4]), .sum(sum[4]), .carry(carry[5]));
bit_adder a5(.a(a[5]), .b(b[5]), .c(c[5]), .sum(sum[5]), .carry(carry[6]));
bit_adder a6(.a(a[6]), .b(b[6]), .c(c[6]), .sum(sum[6]), .carry(carry[7]));
bit_adder a7(.a(a[7]), .b(b[7]), .c(c[7]), .sum(sum[7]), .carry(carry[8]));
bit_adder a8(.a(a[8]), .b(b[8]), .c(c[8]), .sum(sum[8]), .carry(carry[9]));
bit_adder a9(.a(a[9]), .b(b[9]), .c(c[9]), .sum(sum[9]), .carry(carry[10]));
bit_adder a10(.a(a[10]), .b(b[10]), .c(c[10]), .sum(sum[10]), .carry(carry[11]));
bit_adder a11(.a(a[11]), .b(b[11]), .c(c[11]), .sum(sum[11]), .carry(carry[12]));
bit_adder a12(.a(a[12]), .b(b[12]), .c(c[12]), .sum(sum[12]), .carry(carry[13]));
bit_adder a13(.a(a[13]), .b(b[13]), .c(c[13]), .sum(sum[13]), .carry(carry[14]));
bit_adder a14(.a(a[14]), .b(b[14]), .c(c[14]), .sum(sum[14]), .carry(carry[15]));
bit_adder a15(.a(a[15]), .b(b[15]), .c(c[15]), .sum(sum[15]), .carry(carry[16]));
bit_adder a16(.a(a[16]), .b(b[16]), .c(c[16]), .sum(sum[16]), .carry(carry[17]));
bit_adder a17(.a(a[17]), .b(b[17]), .c(c[17]), .sum(sum[17]), .carry(carry[18]));
bit_adder a18(.a(a[18]), .b(b[18]), .c(c[18]), .sum(sum[18]), .carry(carry[19]));
bit_adder a19(.a(a[19]), .b(b[19]), .c(c[19]), .sum(sum[19]), .carry(carry[20]));
bit_adder a20(.a(a[20]), .b(b[20]), .c(c[20]), .sum(sum[20]), .carry(carry[21]));
bit_adder a21(.a(a[21]), .b(b[21]), .c(c[21]), .sum(sum[21]), .carry(carry[22]));
bit_adder a22(.a(a[22]), .b(b[22]), .c(c[22]), .sum(sum[22]), .carry(carry[23]));
bit_adder a23(.a(a[23]), .b(b[23]), .c(c[23]), .sum(sum[23]), .carry(carry[24]));
bit_adder a24(.a(a[24]), .b(b[24]), .c(c[24]), .sum(sum[24]), .carry(carry[25]));
bit_adder a25(.a(a[25]), .b(b[25]), .c(c[25]), .sum(sum[25]), .carry(carry[26]));
bit_adder a26(.a(a[26]), .b(b[26]), .c(c[26]), .sum(sum[26]), .carry(carry[27]));
bit_adder a27(.a(a[27]), .b(b[27]), .c(c[27]), .sum(sum[27]), .carry(carry[28]));
bit_adder a28(.a(a[28]), .b(b[28]), .c(c[28]), .sum(sum[28]), .carry(carry[29]));
bit_adder a29(.a(a[29]), .b(b[29]), .c(c[29]), .sum(sum[29]), .carry(carry[30]));
bit_adder a30(.a(a[30]), .b(b[30]), .c(c[30]), .sum(sum[30]), .carry(carry[31]));
bit_adder a31(.a(a[31]), .b(b[31]), .c(c[31]), .sum(sum[31]), .carry(tem0));
    
endmodule

module bit_adder(input a,
			     input b,
				 input c,
				// input cin,
				 output sum,
				 output carry);
   
 wire tem1, tem2, tem3;
 assign tem1 = a & b;
 assign tem2 = a & c;
 assign tem3 = b & c;
 //assign tem5 = b & cin;
 //assign tem6 = c & cin;
 
 assign sum = a ^ b ^ c;
 assign carry = tem1 | tem2 | tem3;
    
endmodule