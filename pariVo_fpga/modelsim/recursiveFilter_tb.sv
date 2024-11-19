// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module get_all_taps_tb();
	logic clk, reset;
    logic [7:0] eqVal;
    logic [2047:0] allTaps;
    logic [127:0] expected;

	all_taps dut(.clk(clk), .reset(reset), .eqVal(eqVal), .allTaps(allTaps));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
		eqVal = 8'hF4; #10;
		expected = 128'hdFCFCFFF700100037006b;

		
		end

endmodule
