// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module dsp_tb();
    logic clk;
    logic ce;
    logic [15:0] tap;
    logic [23:0] signal;
    logic [31:0] dsp_output;

	dsp dut( .clk(clk), .ce(ce), .tap(tap), .signal(signal), .dsp_output(dsp_output));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
        ce = 1;
		signal = 24'h123456;
		tap = 16'h1234;
        end

endmodule
