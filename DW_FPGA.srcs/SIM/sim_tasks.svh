// This is included, so does not need to be in module.

`include "poke_cmem.svh"

task automatic pcie_write
  (
   input reg [31:0] block_offset,
   input reg [31:0] addr,
   input reg [63:0] data,
   ref   reg        clk_in,
   
   ref pcie_wr_s    bus_pcie_wr
   );
   
   begin : bus_pcie_write
      @(negedge clk_in);
      bus_pcie_wr.data = data;
      bus_pcie_wr.addr = block_offset + addr;
      bus_pcie_wr.vld  = 1'b1;
      
      @(negedge clk_in);
      bus_pcie_wr.vld  = 1'b0;
   end
endtask // while


task automatic pcie_read
  (
   input  reg [31:0] block_offset,
   input  reg [31:0] addr,
   output reg [63:0] data,
   ref    reg 	     clk_in,
   ref pcie_req_s    bus_pcie_req,
   ref pcie_rd_s     pcie_bus_rd
   );
   
   begin : bus_pcie_read
      @(negedge clk_in);
      bus_pcie_req.tag  = bus_pcie_req.tag + 1;
      bus_pcie_req.addr = block_offset + addr;
      bus_pcie_req.vld  = 1'b1;
      
      @(negedge clk_in);
      bus_pcie_req.vld  = 1'b0;
      while (pcie_bus_rd.vld == 'b0) begin
	 @(negedge clk_in);
      end
      data = pcie_bus_rd.data; 
   end // block: bus_pcie_read
endtask // while



task automatic mem_pattern_0 (output [NCMEMS-1:0] mem [3:0]);
   integer i;
   reg [11:0] val;
   mem[0] = 0;
   mem[1] = 255;
   mem[2] = 256;
   mem[3] = 511;
   
   begin : mem_patt_0
      for (i=0;i<1024;i=i+1) begin
	 // $write(" %5d, ",i);
	 val = -2048 + (i*4);
	 // $write(" %4x, ",val);
	 sim_top.top_0.coef_0.\cmem[0].coef_mem_0 .inst.\native_mem_module.blk_mem_gen_v8_3_2_inst .memory[i]   = val;
	 val = 2047 - (i*4);
	 // $write(" %4x, ",val);
	 sim_top.top_0.coef_0.\cmem[255].coef_mem_0 .inst.\native_mem_module.blk_mem_gen_v8_3_2_inst .memory[i] = val;
	 
	 if (i < 512) begin
	    val = -2048 + (i*8);
	    // $write(" %4x, ",val);
	    sim_top.top_0.coef_0.\cmem[256].coef_mem_0 .inst.\native_mem_module.blk_mem_gen_v8_3_2_inst .memory[i] = val;
	    val = 2047 - (i*8);
	    // $display(" %4x, ",val);
	    sim_top.top_0.coef_0.\cmem[511].coef_mem_0 .inst.\native_mem_module.blk_mem_gen_v8_3_2_inst .memory[i] = val;
	 end else begin
	    val = 4096  + 2047 - (i*8);
	    // $write(" %4x, ",val);
	    sim_top.top_0.coef_0.\cmem[256].coef_mem_0 .inst.\native_mem_module.blk_mem_gen_v8_3_2_inst .memory[i] = val;
	    val = -4096 - 2048 + (i*8);
	    // $display(" %4x, ",val);
	    sim_top.top_0.coef_0.\cmem[511].coef_mem_0 .inst.\native_mem_module.blk_mem_gen_v8_3_2_inst .memory[i] = val;
	 end
      end // for (i=0;i<1024;i=i+1)
   end // block: mem_patt_0
endtask // mem_pattern_0

task automatic pcie_ctrl_write
  (
   input reg [31:0]  block_offset,
   input ctrl_addr_s addr,
   input ctrl_word_s data,
   ref   reg         clk_in,
   
   ref pcie_wr_s     bus_pcie_wr
   );
   
   begin : bus_pcie_write
      addr.is_ctrl0 = 1;
      
      @(negedge clk_in);
      bus_pcie_wr.data = data.word0;
      bus_pcie_wr.addr = block_offset + addr;
      bus_pcie_wr.vld  = 1'b1;
      
      @(negedge clk_in);
      bus_pcie_wr.vld  = 1'b0;

      @(negedge clk_in);
      addr.is_ctrl0 = 0;
      
      @(negedge clk_in);
      bus_pcie_wr.data = data.word1;
      bus_pcie_wr.addr = block_offset + addr;
      bus_pcie_wr.vld  = 1'b1;
      
      @(negedge clk_in);
      bus_pcie_wr.vld  = 1'b0;
   end
endtask // while





   
