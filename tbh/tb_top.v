module tb_top();
  // Declare variables -----
  reg        clk;
  reg        resetn;
  reg        start;
  wire       idle;
  reg        run;
  reg [31:0] inst_code[100];
  reg [31:0] data_code[100];
  reg [31:0] ii;
  reg [32*8-1:0] expected_value1; 
  reg [32*8-1:0] expected_value2;  
  reg [32*8-1:0] expected_value3;  
  reg [32*8-1:0] expected_value4; 
  reg [32*8-1:0] expected_value5;  
  reg [32*8-1:0] expected_value6;  
  reg [32*8-1:0] expected_value7;   
  reg [32*8-1:0] expected_value8;  
  
  // Dump waveform -----
  initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
  end  
  
  // Intantiate dut -----
  dut dut0(.resetn(resetn),
           .clk(clk),
           .start(start),
           .idle(idle));
  
  // clk -----
  initial begin
    clk = 0;
    forever begin
      #5;
      clk = ~clk;
    end
  end

  // resetn -----
  initial begin
    resetn <= 0;
    repeat(2) @(negedge clk);
    resetn <= 1;
  end

  // Input singals -----
  initial begin
    start <= 0;
    @(posedge resetn);
    repeat(5) @(posedge clk);
    // Write instructin memory :  -----
    inst_code[0]  = addi(1,0,0);
    inst_code[1]  = addi(2,0,32);
    inst_code[2]  = addi(3,0,64);
	inst_code[3]  = addi(5,0,96); 
    inst_code[4]  = vle32(1,1);   // v1
    inst_code[5]  = vle32(2,2);	  // v2
	inst_code[6]  = vle32(11,3);
	inst_code[7]  = vle32(12,5);
	inst_code[8]  = addi(4,0,1); 
    inst_code[9]  = addi(6,0,128);   // no use
    inst_code[10]  = vadd(3,2,1);  // v3 = v1 + v2
	inst_code[11]  = vsub(5,2,1);  // v5 = v1 - v2
    inst_code[12]  = vadd_vx(8,1,2);  
	inst_code[13] = vadd_vi(9,1,1);
	inst_code[14] = vsub_vx(10,1,2);
    inst_code[15] = vse32(3,6);
	inst_code[16] = vslide1up(6,3,1);
    inst_code[17] = vslide1down(7,3,1);
	inst_code[18] = vmacc_vv(1,11,12);
	inst_code[19] = vle32(4,6);
	
    inst_code[20] = 32'h00000000; // temination code
    $display("----- instruction memory -----");
    for (ii=0; ii<21; ii++) begin
      $display("inst_code[%0h]=%h",ii, inst_code[ii]);
      dut0.inst_memory.mem[ii*4+0] = inst_code[ii][7:0];
      dut0.inst_memory.mem[ii*4+1] = inst_code[ii][15:8];
      dut0.inst_memory.mem[ii*4+2] = inst_code[ii][23:16];
      dut0.inst_memory.mem[ii*4+3] = inst_code[ii][31:24];
      $display("dut0.inst_memory.mem[%h]=%h",ii*4+0, dut0.inst_memory.mem[ii*4+0]);
      $display("dut0.inst_memory.mem[%h]=%h",ii*4+1, dut0.inst_memory.mem[ii*4+1]);
      $display("dut0.inst_memory.mem[%h]=%h",ii*4+2, dut0.inst_memory.mem[ii*4+2]);
      $display("dut0.inst_memory.mem[%h]=%h",ii*4+3, dut0.inst_memory.mem[ii*4+3]);
    end
	
	
    // ----- write data memory -----
    $display("----- data memory -----");
    for (ii=0; ii<16; ii++) begin
      data_code[ii] = $urandom_range(32'h00000000, 32'h70000000); 
      $display("data_code[%0h]=%h",ii, data_code[ii]);
      dut0.data_memory.mem[ii*4+0] = data_code[ii][7:0];
      dut0.data_memory.mem[ii*4+1] = data_code[ii][15:8];
      dut0.data_memory.mem[ii*4+2] = data_code[ii][23:16];
      dut0.data_memory.mem[ii*4+3] = data_code[ii][31:24];
      $display("dut0.data_memory.mem[%h]=%h",ii*4+0, dut0.data_memory.mem[ii*4+0]);
      $display("dut0.data_memory.mem[%h]=%h",ii*4+1, dut0.data_memory.mem[ii*4+1]);
      $display("dut0.data_memory.mem[%h]=%h",ii*4+2, dut0.data_memory.mem[ii*4+2]);
      $display("dut0.data_memory.mem[%h]=%h",ii*4+3, dut0.data_memory.mem[ii*4+3]);
    end
	
	
	$display("----- for multiply add -----");
    for (ii=16; ii<32; ii++) begin
      data_code[ii] = $urandom_range(32'h00000000, 32'h00007000); 
      $display("data_code[%0h]=%h",ii, data_code[ii]);
      dut0.data_memory.mem[ii*4+0] = data_code[ii][7:0];
      dut0.data_memory.mem[ii*4+1] = data_code[ii][15:8];
      dut0.data_memory.mem[ii*4+2] = data_code[ii][23:16];
      dut0.data_memory.mem[ii*4+3] = data_code[ii][31:24];
      $display("dut0.data_memory.mem[%h]=%h",ii*4+0, dut0.data_memory.mem[ii*4+0]);
      $display("dut0.data_memory.mem[%h]=%h",ii*4+1, dut0.data_memory.mem[ii*4+1]);
      $display("dut0.data_memory.mem[%h]=%h",ii*4+2, dut0.data_memory.mem[ii*4+2]);
      $display("dut0.data_memory.mem[%h]=%h",ii*4+3, dut0.data_memory.mem[ii*4+3]);
    end
   
    // answer -----
    $display("----- answer vadd -----"); 
    expected_value1 = 0;
    for (ii=0; ii<8; ii++) begin
       $display("data[%0h] + data[%0h] = %h", ii, ii+8, data_code[ii]+data_code[ii+8]);
       expected_value1[ii*32+:32] = data_code[ii]+data_code[ii+8];
    end
	
	// sub 
    expected_value2 = 0;
    for (ii=0; ii<8; ii++) begin
       expected_value2[ii*32+:32] = data_code[ii]-data_code[ii+8];
    end
	
	// slide1up
    expected_value3 = 0;
    expected_value3 = {expected_value1[223:0],32'b0};
	
	// slide1down
    expected_value4 = 0;
    expected_value4 = {32'b0, expected_value1[255:32]};
	
	expected_value6 = 0;
    for (ii=0; ii<8; ii++) begin
       //$display("data[%0h] + data[%0h] = %h", ii, ii+8, data_code[ii]+data_code[ii+8]);
       expected_value6[ii*32+:32] = data_code[ii]+1;
    end

    // start riscv -----
    repeat(10) @(posedge clk);   
    start <= 1;
    repeat(1) @(posedge clk);
    start <= 0;
    // simulation -----
    run = 1;
    ii  = 0;
    fork
      begin
        wait (idle==0);
        wait (idle==1);
        run = 0;
        repeat(10) @(posedge clk);
      end
      while (run) begin
        @(posedge clk);
        ii = ii+1;
        if (ii > 1000) begin
          $display("TIMEOUT ERROR.");
          $finish;
        end
      end
    join
	
	expected_value5 = 0;
	for (ii=0; ii<8; ii++) begin
       //$display("data[%0h] + data[%0h] = %h", ii, ii+8, data_code[ii]+data_code[ii+8]);
       expected_value5[ii*32+:32] = x2 + data_code[ii];  
    end
    
	
	expected_value7 = 0;
    for (ii=0; ii<8; ii++) begin
       //$display("data[%0h] + data[%0h] = %h", ii, ii+8, data_code[ii]+data_code[ii+8]);
       expected_value7[ii*32+:32] = x2 - data_code[ii];
    end
	
	expected_value8 = 0;
	for (ii=0; ii<8; ii++) begin
       expected_value8[ii*32+:32] = data_code[ii] + (data_code[16+ii] * data_code[24+ii]);
    end

    // check data -----
    $display("----- result vadd-----");
    if (v4 === expected_value1) begin
      $display(" SIMULATION PASS :\n            v4=%h\nexpected_value=%h\n",  v4, expected_value1);
    end else begin
      $display(" SIMULATION FAIL :\n            v4=%h\nexpected_value=%h\n",  v4, expected_value1);
    end
	
	$display("----- result vsub -----");
	if (v5 === expected_value2) begin
      $display(" SIMULATION PASS :\n            v5=%h\nexpected_value=%h\n",  v5, expected_value2);
    end else begin
      $display(" SIMULATION FAIL :\n            v5=%h\nexpected_value=%h\n",  v5, expected_value2);
    end
	
	$display("----- result vslide1up -----"); 
	if (v6 === expected_value3) begin
      $display(" SIMULATION PASS :\n            v6=%h\nexpected_value=%h\n",  v6, expected_value3);
    end else begin
      $display(" SIMULATION FAIL :\n            v6=%h\nexpected_value=%h\n",  v6, expected_value3);
    end
	
	
	$display("----- result vslide1down -----"); 
	if (v7 === expected_value4) begin
      $display(" SIMULATION PASS :\n            v7=%h\nexpected_value=%h\n",  v7, expected_value4);
    end else begin
      $display(" SIMULATION FAIL :\n            v7=%h\nexpected_value=%h\n",  v7, expected_value4);
    end
	
	////
	$display("----- result vadd.vx -----"); 
	if (v8 === expected_value5) begin
      $display(" SIMULATION PASS :\n            v8=%h\nexpected_value=%h\n",  v8, expected_value5);
    end else begin
      $display(" SIMULATION FAIL :\n            v8=%h\nexpected_value=%h\n",  v8, expected_value5);
    end
	
	$display("----- result vadd.vi -----"); 
	if (v9 === expected_value6) begin
      $display(" SIMULATION PASS :\n            v9=%h\nexpected_value=%h\n",  v9, expected_value6);
    end else begin
      $display(" SIMULATION FAIL :\n            v9=%h\nexpected_value=%h\n",  v9, expected_value6);
    end
	
	$display("----- result vsub.vx -----"); 
	if (v10 === expected_value7) begin
      $display(" SIMULATION PASS :\n           v10=%h\nexpected_value=%h\n",  v10, expected_value7);
    end else begin
      $display(" SIMULATION FAIL :\n           v10=%h\nexpected_value=%h\n",  v10, expected_value7);
    end
	
	$display("----- result vmacc -----"); 
	if (v1 === expected_value8) begin
      $display(" SIMULATION PASS :\n            v1=%h\nexpected_value=%h\n",  v1, expected_value8);
    end else begin
      $display(" SIMULATION FAIL :\n            v1=%h\nexpected_value=%h\n",  v1, expected_value8);
    end
	
	$display("time = %0t\nSIMULATION FINISH ",  $time);
    // finish -----
    $finish;
  end

  // functions -----
  function [31:0] addi(input [4:0] rd, input [4:0] rs1, input [11:0] imm);
    reg [2:0] funct3;
    reg [6:0] opcode;
    begin
      funct3 = 3'b000;
      opcode = 7'b0010011;
      addi = (imm << 20) + (rs1 << 15) + (funct3 << 12) + (rd << 7) + opcode;
    end
  endfunction

  function [31:0] vle32(input [4:0] vd, input [4:0] rs1);
    reg [2:0] nf;
    reg       mew;
    reg [1:0] mop;
    reg       vm;
    reg [4:0] lumop;
    reg [2:0] width;
    reg [6:0] opcode;
    begin 
      nf    = 3'b000;
      mew   = 1'b0;
      mop   = 2'b00;
      vm    = 1'b0;
      lumop = 5'b00000;
      width = 3'b110;
      opcode = 7'b0000111;
      vle32 = (nf << 29) + (mew << 28) + (mop << 26) + (vm << 25) + (lumop << 20) +
              (rs1 << 15)  + (width << 12) + (vd << 7) + opcode;
    end        
  endfunction

  function [31:0] vse32(input [4:0] vs3, input [4:0] rs1);
    reg [2:0] nf;
    reg       mew;
    reg [1:0] mop;
    reg       vm;
    reg [4:0] sumop;
    reg [2:0] width;
    reg [6:0] opcode;
   
    begin
      nf    = 3'b000;
      mew   = 1'b0;
      mop   = 2'b00;
      vm    = 1'b0;
      sumop = 5'b00000;
      width = 3'b110;
      opcode = 7'b0100111;
      vse32 = (nf << 29) + (mew << 28) + (mop << 26) + (vm << 25) + (sumop << 20) +
              (rs1 << 15)  + (width << 12) + (vs3 << 7) + opcode;
    end        
  endfunction

  function [31:0] vadd(input [4:0] vd, input [4:0] vs2, input [4:0] vs1);
    reg [5:0] funct6;
    reg       vm;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b000000;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vadd = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (vs1 << 15) + (vd << 7) + opcode;
    end        
  endfunction
  
   function [31:0] vsub (input [4:0] vd, input [4:0] vs2, input [4:0] vs1);
    reg [5:0] funct6;
    reg       vm;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b000010;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vsub = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (vs1 << 15) + (vd << 7) + opcode;
    end        
  endfunction
  
  function [31:0] vslide1up (input [4:0] vd, input [4:0] vs2, input [4:0] rs1);
    reg [5:0] funct6;
	reg [2:0] funct3;
    reg       vm;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b001110;
	  funct3 = 3'b110;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vslide1up = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (rs1 << 15) + (funct3 << 12) + (vd << 7) + opcode;
    end        
  endfunction
  
  function [31:0] vslide1down (input [4:0] vd, input [4:0] vs2, input [4:0] rs1);
    reg [5:0] funct6;
    reg       vm;
	reg [2:0] funct3;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b001111;
	  funct3 = 3'b110;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vslide1down = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (rs1 << 15) + (funct3 << 12) + (vd << 7) + opcode;
    end        
  endfunction
  
  function [31:0] vadd_vx (input [4:0] vd, input [4:0] vs2, input [4:0] rs1);
    reg [5:0] funct6;
    reg       vm;
	reg [2:0] funct3;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b000000;
	  funct3 = 3'b100;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vadd_vx = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (rs1 << 15) + (funct3 << 12) + (vd << 7) + opcode;
    end        
  endfunction
  
  function [31:0] vadd_vi (input [4:0] vd, input [4:0] vs2, input [4:0] imm);
    reg [5:0] funct6;
    reg       vm;
	reg [2:0] funct3;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b000000;
	  funct3 = 3'b011;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vadd_vi = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (imm << 15) + (funct3 << 12) + (vd << 7) + opcode;
    end        
  endfunction
  
  function [31:0] vsub_vx (input [4:0] vd, input [4:0] vs2, input [4:0] rs1);
    reg [5:0] funct6;  
    reg       vm;
	reg [2:0] funct3;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b000010;
	  funct3 = 3'b100;
      vm     = 1'b0;
      opcode = 7'b1010111;
      vsub_vx = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (rs1 << 15) + (funct3 << 12) + (vd << 7) + opcode;
    end        
  endfunction
  
  function [31:0] vmacc_vv (input [4:0] vd, input [4:0] vs2, input [4:0] vs1);
    reg [5:0] funct6;  
    reg       vm;
	reg [2:0] funct3;
    reg [6:0] opcode;
  
    begin
      funct6 = 6'b101101;
	  funct3 = 3'b010; // OPMVV
      vm     = 1'b0;
      opcode = 7'b1010111;
      vmacc_vv = (funct6 << 26) + (vm << 25) + (vs2 << 20) +
             (vs1 << 15) + (funct3 << 12) + (vd << 7) + opcode;
    end        
  endfunction

  // Debug code -----
  wire [31:0]     x1;
  wire [31:0]     x2;
  wire [31:0]     x3;
  wire [31:0]     x4;
  wire [31:0]     x5;
  wire [8*32-1:0] v1;
  wire [8*32-1:0] v2;
  wire [8*32-1:0] v3;
  wire [8*32-1:0] v4;
  wire [8*32-1:0] v5;
  wire [8*32-1:0] v6;
  wire [8*32-1:0] v7;
  wire [8*32-1:0] v8;
  wire [8*32-1:0] v9;
  wire [8*32-1:0] v10;
  wire [8*32-1:0] v11;
  wire [8*32-1:0] v12;
  wire [8*32-1:0] v13;
  assign x1 = dut0.riscv0.scalar_reg0.x[1];
  assign x2 = dut0.riscv0.scalar_reg0.x[2];
  assign x3 = dut0.riscv0.scalar_reg0.x[3];
  assign x4 = dut0.riscv0.scalar_reg0.x[4];
  assign x5 = dut0.riscv0.scalar_reg0.x[5];
  assign v1 = dut0.riscv0.vector_reg0.v[1];
  assign v2 = dut0.riscv0.vector_reg0.v[2];
  assign v3 = dut0.riscv0.vector_reg0.v[3];
  assign v4 = dut0.riscv0.vector_reg0.v[4];
  assign v5 = dut0.riscv0.vector_reg0.v[5];
  assign v6 = dut0.riscv0.vector_reg0.v[6];
  assign v7 = dut0.riscv0.vector_reg0.v[7];
  assign v8 = dut0.riscv0.vector_reg0.v[8];
  assign v9 = dut0.riscv0.vector_reg0.v[9];
  assign v10 = dut0.riscv0.vector_reg0.v[10];
  assign v11 = dut0.riscv0.vector_reg0.v[11];
  assign v12 = dut0.riscv0.vector_reg0.v[12];
  assign v13 = dut0.riscv0.vector_reg0.v[13];

  /*assign v5 = { dut0.data_memory.mem[95],dut0.data_memory.mem[94],
				dut0.data_memory.mem[93],dut0.data_memory.mem[92],
				dut0.data_memory.mem[91],dut0.data_memory.mem[90],
				dut0.data_memory.mem[89],dut0.data_memory.mem[88],
				dut0.data_memory.mem[87],dut0.data_memory.mem[86],
				dut0.data_memory.mem[85],dut0.data_memory.mem[84],
				dut0.data_memory.mem[83],dut0.data_memory.mem[82],
				dut0.data_memory.mem[81],dut0.data_memory.mem[80],
				dut0.data_memory.mem[79],dut0.data_memory.mem[78],
				dut0.data_memory.mem[77],dut0.data_memory.mem[76],
				dut0.data_memory.mem[75],dut0.data_memory.mem[74],
				dut0.data_memory.mem[73],dut0.data_memory.mem[72],
				dut0.data_memory.mem[71],dut0.data_memory.mem[70],
				dut0.data_memory.mem[69],dut0.data_memory.mem[68],
				dut0.data_memory.mem[67],dut0.data_memory.mem[66],
				dut0.data_memory.mem[65],dut0.data_memory.mem[64]};*/
endmodule
