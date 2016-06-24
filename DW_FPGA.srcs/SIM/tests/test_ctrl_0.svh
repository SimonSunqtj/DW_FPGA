//Program controller, start running

mem_pattern_0(rnd_mem);

// force_pattern_0(clk_input);

ctrl_word.word0.next 	     = 'b0;
ctrl_word.word0.flips        = 'h2;
ctrl_word.word0.temperature  = 'h3;
ctrl_word.word0.cutoff       = {1'b1,{SUM_W{1'b0}}};
ctrl_word.word1.count        = 'h5;

ctrl_addr 	       = 'b0;

pcie_ctrl_write(CTRL_BAR_START,
		ctrl_addr,
		ctrl_word,
		clk_input,
		bus_pcie_wr);

repeat (NRUNS-1) @(negedge clk_input);

ctrl_cmd      = 'b0;
ctrl_cmd.init = 'b1;

ctrl_addr        = 'b0;
ctrl_addr.is_cmd = 'b1;

pcie_write(CTRL_BAR_START,
	   ctrl_addr,
	   ctrl_cmd,
	   clk_input,
	   bus_pcie_wr);

repeat (NRUNS-1) @(negedge clk_input);

ctrl_cmd       = 'b0;
ctrl_cmd.start = 'b1;

ctrl_addr        = 'b0;
ctrl_addr.is_cmd = 'b1;

pcie_write(CTRL_BAR_START,
	   ctrl_addr,
	   ctrl_cmd,
	   clk_input,
	   bus_pcie_wr);

repeat ((5+5) * NRUNS-1) @(negedge clk_input);




