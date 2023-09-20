module vector(input         rst,
              input         clk,
              input         start,
              output  reg   idle,

              output        I_enable,
              output        I_write,
              output [31:0] I_addr,
              output [31:0] I_wdata,
              input         I_ready,
              input  [31:0] I_rdata,

              output        D_enable,
              output        D_write,
              output [31:0] D_addr,
              output [31:0] D_wdata,
              input         D_ready,
              input  [31:0] D_rdata);
			  
  
  parameter VL = 8;
  parameter SEW = 32;
  
  wire [31:0] pc;
  wire [31:0] pc_next;
  wire stall;  // wait to be considered
  reg  stall_r;
  
  assign stall = stall_r;
  
  wire [31:0] instruction_IFID;
  wire [ 3:0] sel_IDEXE;  // may have to change				
  wire [ 4:0] rd_IDEXE;
  wire [ 4:0] rs1_ID;
  wire [ 4:0] rs2_ID;
  
  // vector
  wire [4:0]  vd_IDEXE;
  wire [4:0]  imm_5_IDEXE;
  wire [4:0]  vs1_ID;
  wire [4:0]  vs2_ID;
  wire [4:0]  vs3_ID;
  wire [11:0] imm_IDEXE;
  wire [3:0] operation_IDEXE;
  wire [1:0] vci_IDEXE;
  
  wire  [31:0] rs1_data_ID;
  wire  [31:0] rs2_data_ID;
  wire  [VL*SEW-1:0] vs1_data_ID;
  wire  [VL*SEW-1:0] vs2_data_ID;
  wire  [VL*SEW-1:0] vs3_data_ID;
	
  wire  [31:0] rs1_IDEXE;
  wire  [31:0] rs2_IDEXE;
  wire  [VL*SEW-1:0] vs1_IDEXE;
  wire  [VL*SEW-1:0] vs2_IDEXE;
  wire  [VL*SEW-1:0] vs3_IDEXE;
 		
  wire is_v_EXMEM;
  wire is_s_EXMEM;
  wire [4:0]  vd_EXMEM;
  wire [4:0]  rd_EXMEM;
  wire [ 3:0] sel_EXMEM;
  wire [31:0] rs1_addr;
  wire [31:0] result_s_EXMEM;
  wire [VL*SEW-1:0] result_v_EXMEM;
  
  wire [ 4:0] sel_MEM;
  wire [31:0] rs1_addr_MEM;
  wire [VL*SEW-1:0] data_v_MEM;
  
  wire is_v_MEMWB;
  wire is_s_MEMWB;
  wire [4:0]  vd_MEMWB;
  wire [4:0]  rd_MEMWB;
  wire [ 3:0] sel_MEMWB;
  wire [31:0] result_s_MEMWB;
  wire [VL*SEW-1:0] result_v_MEMWB;
  
  wire is_v_REG;
  wire is_s_REG;
  wire [4:0]  vd_REG;
  wire [4:0]  rd_REG;
  wire [31:0] data_s_REG;
  wire [VL*SEW-1:0] data_v_REG;
  wire write_REG;
  
  reg [31:0] instruction;
  reg [VL*SEW-1:0] temp_vector;
  
  reg        I_enable;
  reg        I_write;
  reg [31:0] I_addr;
  reg [31:0] I_wdata;

  reg        D_enable;
  reg        D_write;
  reg [31:0] D_wdata;
  reg [31:0] D_addr;
  
  reg        inst_fetch_start;

  reg        data_access_start;
  reg        data_access_done;
  reg        data_access_on;
  reg [31:0] cnt;
  
  wire data_access_flagIDEXE;
  wire data_access_flagEXMEM;
  
  wire reg_write_IDEXE;
  wire reg_write_EXMEM;
  wire reg_write_MEMWB;
  
  parameter INST_ADDI  = 0;
  parameter INST_VLE32 = 1;
  parameter INST_VSE32 = 2;
  parameter INST_VADD  = 3;
  parameter INST_VSUB  = 4;
  parameter INST_SLIDE1UP = 5;
  parameter INST_SLIDE1DOwN = 6;  

  
  
//  #(.ENTRY_NUM(BPU_ENTRY_NUM), .XLEN(XLEN))  
  pc pc0(.clk(clk),
		 .rst(rst),
		 .flag(inst_fetch_done & !inst_fetch_done_record),
		 .stall(stall),
		 .pc(pc));
		
  instruction_fetch IF(.clk(clk),
					   .rst(rst),
					   .stall(stall),
					   .instruction_i(instruction),
					   .instruction_o(instruction_IFID));
  
  decoder  #(.VL(8), .SEW(32)) ID
			(.clk(clk),
			 .rst(rst),
			 .stall(stall),
			 .instruction(instruction_IFID),
			 .sel_o(sel_IDEXE),
			 .operation_o(operation_IDEXE),
			 .vci_o(vci_IDEXE),
			 .reg_write(reg_write_IDEXE),
			 .rs1_data(rs1_data_ID),
			 .rs2_data(rs2_data_ID),
			 .vs1_data(vs1_data_ID),
			 .vs2_data(vs2_data_ID),
			 .vs3_data(vs3_data_ID),
			 .data_access(data_access_flagIDEXE),
			 .rd(rd_IDEXE),
			 .rs1(rs1_ID),
			 .imm_5_o(imm_5_IDEXE),
			 .vd(vd_IDEXE),
			 .vs1(vs1_ID),
			 .vs2(vs2_ID),
			 .vs3(vs3_ID),
			 .imm_o(imm_IDEXE),
			 .rs1_o(rs1_IDEXE),
			 .rs2_o(rs2_IDEXE),
			 .vs1_o(vs1_IDEXE),
			 .vs2_o(vs2_IDEXE),
			 .vs3_o(vs3_IDEXE));
  
  execute #(.VL(8), .SEW(32)) EX
			 (.clk(clk),
			  .rst(rst),
			  .stall(stall),
			  .data_access(data_access_flagIDEXE),
			  .reg_write(reg_write_IDEXE),
			  .sel(sel_IDEXE),  
			  .operation(operation_IDEXE),
			  .vci(vci_IDEXE),
			  .rd(rd_IDEXE),
			  .imm_5(imm_5_IDEXE),
			  .vd(vd_IDEXE),
			  .imm(imm_IDEXE),
			  .rs1_data(rs1_IDEXE),
			  .rs2_data(rs2_IDEXE),
			  .vs1_data(vs1_IDEXE),
			  .vs2_data(vs2_IDEXE),
			  .vs3_data(vs3_IDEXE),
			  .data_access_o(data_access_flagEXMEM),
			  .reg_write_o(reg_write_EXMEM),
			  .is_v(is_v_EXMEM),
			  .is_s(is_s_EXMEM),
			  .rd_o(rd_EXMEM),
			  .vd_o(vd_EXMEM),
			  .sel_o(sel_EXMEM),
			  .rs1_data_o(rs1_addr),
			  .result_s(result_s_EXMEM),
			  .result_v(result_v_EXMEM));
	
  memory #(.VL(8), .SEW(32)) MEM
			 (.clk(clk),
			  .rst(rst),
			  .stall(stall),
			  .reg_write(reg_write_EXMEM),
			  .is_v(is_v_EXMEM),
			  .is_s(is_s_EXMEM),
			  .sel(sel_EXMEM),
			  .rd(rd_EXMEM),
			  .vd(vd_EXMEM),
			  .rs1_addr(rs1_addr),
			  .result_s(result_s_EXMEM),
			  .result_v(result_v_EXMEM),
			  .reg_write_o(reg_write_MEMWB),
			  .data_access_flag(data_access_flagEXMEM),
			  .data_access_on(data_access_on),
			  .sel_MEM(sel_MEM),
			  .rs1_addr_MEM(rs1_addr_MEM),
			  .data_v_MEM(data_v_MEM),
			  .is_v_o(is_v_MEMWB),
			  .is_s_o(is_s_MEMWB),
			  .rd_o(rd_MEMWB),
			  .vd_o(vd_MEMWB),
			  .sel_o(sel_MEMWB),
			  .result_s_o(result_s_MEMWB),
			  .result_v_o(result_v_MEMWB));
				
  write_back #(.VL(8), .SEW(32)) WB // a signal for load store scalar not yet
			    (.stall(stall),
				 .reg_write(reg_write_MEMWB),
			 	 .data_m_s(32'b0),
				 .data_alu_s(result_s_MEMWB),
				 .data_m_v(temp_vector),
				 .data_alu_v(result_v_MEMWB),
				 .vd(vd_MEMWB),
				 .rd(rd_MEMWB),
				 .sel(sel_MEMWB),
				 .is_v(is_v_MEMWB),
				 .is_s(is_s_MEMWB),
				 .is_v_o(is_v_REG),
				 .is_s_o(is_s_REG),
				 .data_s(data_s_REG),
				 .data_v(data_v_REG),
				 .vd_o(vd_REG),
				 .rd_o(rd_REG),
				 .write(write_REG));  // for load		
		
  scalar_reg scalar_reg0 (.clk(clk),
			 .rst(rst),
			 .write(write_REG),
			 .is_s(is_s_REG),
			 .rs1_addr(rs1_ID),
			 .rs2_addr(rs2_ID),
			 .rd_addr(rd_REG),
			 .data(data_s_REG),
			 .rs1_data(rs1_data_ID),
			 .rs2_data(rs2_data_ID));
  
  vector_reg#(.VL(8), .SEW(32)) vector_reg0
			 (.clk(clk),
			  .rst(rst),
			  .write(write_REG),
			  .is_v(is_v_REG),
			  .vs1_addr(vs1_ID),
			  .vs2_addr(vs2_ID),
			  .vs3_addr(vs3_ID),
			  .vd_addr(vd_REG),
			  .data(data_v_REG),
			  .vs1_data(vs1_data_ID),
			  .vs2_data(vs2_data_ID),
			  .vs3_data(vs3_data_ID));
	
  always @(posedge clk) begin
    if (!rst) begin
      inst_fetch_start <= 0;
	  stall_r <= 1;
	end else if(start) begin
	  stall_r <= 0;
    end else begin
      if (!stall_r) begin
        inst_fetch_start <= 1;
		stall_r <= 1;
      end else begin
        inst_fetch_start <= 0;
		if(stall_r & (inst_fetch_done_record | inst_fetch_done) & !data_access_on)begin // may have problem
          stall_r <= 0;
      end
      end
    end
  end
  
  reg [2:0] state;
  reg [2:0] next_state;
  
  parameter START     = 0;
  parameter WORKING   = 1;
  parameter LAST_INST = 2;
  parameter FINSISH   = 3;
  
  always@(posedge clk) begin
    if (!rst) 
	  state <= 0;
	else
	  state <= next_state;
  end
	
	always@(*) begin
	  case(state)
	    START: 
		  begin
		    if(start)
		      next_state = WORKING;
			idle = 0;
		  end
		WORKING:
  		  begin
		    if (inst_fetch_done_record & (instruction == 32'b0))
			  next_state = LAST_INST;
		  end
		LAST_INST:
		  begin
		    if ((sel_MEMWB == 4))
			  next_state = FINSISH;
		  end
		FINSISH:
		  begin
		    idle = 1; 
		  end
		default:
		  begin
		    next_state = START;
		  end
	  endcase
	end
  
  wire inst_fetch_done;
  reg inst_fetch_done_record;
  reg data_access_done_record;
  
  assign inst_fetch_done = (I_enable && I_ready);
  
  always@(posedge clk) begin // may need to consider of data cycle minimize
    if(!rst) begin
	  inst_fetch_done_record <= 0;
	  //data_access_done_record <= 0;
	end else begin
	  if(inst_fetch_done)
	    inst_fetch_done_record <= 1;
	  else if(!data_access_on)
	    inst_fetch_done_record <= 0;
		
	  //if(data_access_done)
	    //data_access_done_record <= 1;
	  end
  end

  // inst_fetch transacton -----
  always @(posedge clk) begin
    if (!rst) begin
      I_enable <= 0;
      I_write <= 0;
      I_addr  <= 32'b0;
      I_wdata <= 32'b0;
    end else begin
      if (!stall) begin
        I_enable <= 1;
        I_write <= 0;
        I_addr  <= pc;
        I_wdata <= 32'b0;
      end else if (I_ready && !inst_fetch_start) begin
        I_enable <= 0;        
      end
     // if (inst_fetch_done) 
	   // instruction <= I_rdata;
    end
  end
  
  always@(*) begin
    if(!rst)
	  instruction = 32'b0;
    else if(inst_fetch_done & !inst_fetch_done_record)
	  instruction = I_rdata;
  end
  

  // data_access transacton -----
  always @(posedge clk) begin
    if (!rst) begin
      D_enable <= 0;
      D_write <= 0;
      D_addr  <= 0;
      D_wdata <= 0;
      data_access_done <= 0;  //
      data_access_on <= 0;  //
      cnt <= 0;
    end else begin
      if ((!stall & data_access_flagEXMEM) || data_access_on) begin
	    data_access_on <= 1;
        if (sel_MEM == INST_VLE32) begin  // finally!!!!
          D_enable <= 1;
          D_write <= 0;
          D_addr  <= rs1_addr_MEM + cnt*4;
          D_wdata <= 0;
        end else begin // INST_VSE32
          D_enable <= 1;
          D_write <= 1;
          D_addr  <= rs1_addr_MEM + cnt*4;
          D_wdata <= data_v_MEM[(32*cnt)+:32];  //v[vs3][(32*cnt)+:32];
        end
        if (D_enable && D_ready) begin
          if (sel_MEM == INST_VLE32) begin
            temp_vector[(32*cnt)+:32] <= D_rdata;
          end

          if (cnt == (VL-1)) begin
            cnt <= 0;
            data_access_on <= 0;
            data_access_done <= 1;
          end else begin 
            cnt <= cnt + 1;
          end
          D_enable <= 0;
        end
      end else begin
        data_access_done <= 0;
      end
    end
  end

  
endmodule            
