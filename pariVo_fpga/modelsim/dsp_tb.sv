// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module dsp_tb();
    logic clk;
    logic ce;
    logic [15:0] tap;
	logic [7:0] tapnum;
    logic [15:0] signalWindow [0:3];
    logic [33:0] result_o;
	logic done;

	fakedsp dut(.clk(clk), .ce(ce), .tap(tap), .tapnum(tapnum), .signalWindow(signalWindow), .result_o(result_o), .done(done));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
        ce = 1;
		tapnum = 8'h00;
		tap = 16'h0004;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		 ce = 1;
		tapnum = 8'h01;
		tap = 16'h0001;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		 ce = 1;
		tapnum = 8'h02;
		tap = 16'h0002;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		 ce = 1;
		tapnum = 8'h03;
		tap = 16'h0001;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;


        end

endmodule 


module signalwindow_tb();
    logic clk;
    logic en;
    logic [24:0] signal;
	logic [15:0] signalWindow [0:3];
    

	signalwindow dut(.clk(clk), .en(en), .signal(signal), .signalWindow(signalWindow));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
        en = 1;
		signal = 24'h111111;
		//tap = 16'h1234;

		#10
		en = 0;
		signal = 24'h000000;

		#10
		en = 1;
		signal = 24'h222222;

		#10
		en = 1;
		signal = 24'h333333;

		#10
		en = 1;
		signal = 24'h444444;

		#10
		en = 1;
		signal = 24'h555555;

        end

endmodule


