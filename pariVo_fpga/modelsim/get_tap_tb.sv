// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module gettap_tb();
    logic clk;
    logic [3:0] filterNum;
    logic [2:0] tapnum;
    logic [15:0] tapcoeff;
    logic [15:0] expected;

	get_tap dut( .clk(clk), .filterNum(filterNum), .tapnum(tapnum), .tapcoeff(tapcoeff));
	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
		filterNum = 4'h0; #10;
		tapnum = 3'b010;
        expected = 16'h2;

        #20

        filterNum = 4'ha; #10;
		tapnum = 3'b010;
        expected = 16'h1312;
		end

endmodule


