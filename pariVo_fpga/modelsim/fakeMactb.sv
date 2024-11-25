// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module fakeMac16_tb();
    logic clk_en_i;        
    logic clk_i;
    logic [32:0] prevValue;
    logic [15:0] data_a_i;
    logic [15:0] data_b_i;
    logic rst_i;
    logic [32:0] result_o;

	fakeMac16 dut( .clk_en_i(clk_en_i), .clk_i(clk_i), .prevValue(prevValue), .data_a_i( data_a_i), .data_b_i(data_b_i), .rst_i(rst_i), .result_o(result_o));
	always
		begin
		clk_i = 0; #5;
		clk_i = 1; #5;
		end
	initial
		begin
        #5
        prevValue = 33'h0;
		data_a_i = 16'h0000;
		data_b_i = 16'h0000;

        #10
        prevValue = 33'h0;
        data_a_i = 16'h6e71;
		data_b_i = 16'h6a02; 

        #10
        prevValue = 33'h2dbba6e2;
        data_a_i = 16'hef9e;
		data_b_i = 16'h22ae; 

		end

endmodule


