// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module get_all_taps_tb();
	logic clk, reset;
    logic [7:0] eqVal;
    logic [15:0] tapcoeff;
	logic [7:0] outputTapnum;
	logic [63:0] expected;
    //logic [127:0] expected;

	new_all_taps dut(.clk(clk), .reset(reset), .eqVal(eqVal), .tapcoeff(tapcoeff), .outputTapnum(outputTapnum));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
			
		reset = 0;
		#5;
		reset = 1;
		#5;
		reset = 0;
		eqVal = 8'h0;
		expected = 64'h0004000500060007;
		end

endmodule


