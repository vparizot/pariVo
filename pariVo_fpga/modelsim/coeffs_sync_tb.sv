// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module coeffssync_tb();
	logic [15:0] a;
	logic clk;
	logic [15:0] y;
    logic [15:0] expected;

	coeffs_sync dut( .a(a), .clk(clk), .y(y));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
		a = 16'h07f0; #10;
		expected = 16'h080;
		end

endmodule

