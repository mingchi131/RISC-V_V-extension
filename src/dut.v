module dut(input  resetn,
           input  clk,
           input  start,
           output idle);

  wire         resetn;
  wire         clk;

  wire         Itrans;
  wire         Iwrite;
  wire [31:0]  Iaddr;
  wire [31:0]  Iwdata;
  wire         Iready;
  wire [31:0]  Irdata;

  wire         Dtrans;
  wire         Dwrite;
  wire [31:0]  Daddr;
  wire [31:0]  Dwdata;
  wire         Dready;
  wire [31:0]  Drdata;

  mem inst_memory(.rst     (resetn),
                     .clk     (clk   ),
                     .enable  (Itrans ),
                     .rw	  (Iwrite ),
                     .addr    (Iaddr  ),
                     .data_in (Iwdata ),
                     .ready   (Iready ),
                     .data_out(Irdata ));

  mem data_memory(.rst  	  (resetn),
                     .clk     (clk   ),
                     .enable  (Dtrans ),
                     .rw   	  (Dwrite ),
                     .addr    (Daddr  ),
                     .data_in (Dwdata ),
                     .ready   (Dready ),
                     .data_out(Drdata ));

  vector riscv0(.rst	 	(resetn),
               .clk     (clk   ),
               .start   (start ),
               .idle    (idle  ),
                               
               .I_enable(Itrans),
               .I_write  (Iwrite),
               .I_addr   (Iaddr ),
               .I_wdata  (Iwdata),
               .I_ready  (Iready),
               .I_rdata  (Irdata),
                               
               .D_enable(Dtrans),
               .D_write  (Dwrite),
               .D_addr   (Daddr ),
               .D_wdata  (Dwdata),
               .D_ready  (Dready),
               .D_rdata  (Drdata));
endmodule

