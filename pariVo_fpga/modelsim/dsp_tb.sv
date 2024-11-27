// Victoria Parizot and Audrey Vo
// vparizot@hmc.edu avo@g.hmc.edu
// 11/18/2024
// Filtering Testbench
`timescale 1ns/1ns

module dsp_tb();
    logic clk_i;
    logic clk_en_i;
    logic [15:0] tap;
	logic [7:0] tapnum;
    logic [15:0] signalWindow [0:3];
    logic [32:0] result_o;
	logic done;
	logic rst_i;

	dsp dut(.clk_i(clk_i), .clk_en_i(clk_en_i), .rst_i(rst_i), .tap(tap), .tapnum(tapnum), .signalWindow(signalWindow), .result_o(result_o), .done(done));
	always
		begin
		clk_i = 0; #5;
		clk_i = 1; #5;
		end
	initial
		begin

		rst_i = 0; #10;
		rst_i = 1; #10;
		rst_i = 0;

        clk_en_i = 1;
		tapnum = 8'h00;
		tap = 16'h0004;
		signalWindow[0] = 16'h0005;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#5
	
		tapnum = 8'h01;
		tap = 16'h0001;
		signalWindow[0] = 16'h0005;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		tapnum = 8'h02;
		tap = 16'h0002;
		signalWindow[0] = 16'h0005;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;
		
		#15 
		tapnum = 8'h03;
		tap = 16'h0001;
		signalWindow[0] = 16'h0005;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#50
		rst_i = 1;
		tapnum = 8'h03;
		tap = 16'h0001;
		signalWindow[0] = 16'h0005;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004; #10
		rst_i = 0;

        end

endmodule 



module faketop_tb();
	logic clk;
	logic reset;
	logic rst_i;
	logic clk_en_i;
	logic signal_en;
    logic [23:0] signal;
    logic [7:0] eqVal;
    logic [32:0] result_o;
    logic done;

	faketop dut(.clk(clk), .reset(reset), .rst_i(rst_i), .clk_en_i(clk_en_i), .signal_en(signal_en), .signal(signal), .eqVal(eqVal), .result_o(result_o), .done(done));

	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
		eqVal = 8'h00;
		reset = 0;
		rst_i = 0;
		#10;
		reset = 1;
		rst_i = 1;
		#10;
		reset = 0;
		rst_i = 0;
		

		clk_en_i = 1;
		signal_en = 1;
		signal = 24'h000111;
		#10 
		signal = 24'h000400;
		#10 
		signal = 24'h000200;
		#10 
		signal = 24'h000300;
	
        //eqVal = 8'h01;
		//tap = 16'h1234;

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

module gain_tb();
    logic clk_i, clk_en_i, rst_i;
    logic [15:0] tap;
    logic [7:0] tapnum;
    logic [15:0] signalWindow [0:3];
    logic [15:0] finalVal;

	//secondtop dut(.clk_i(clk_i), .clk_en_i(clk_en_i), .rst_i(rst_i), .tap(tap), .tapnum(tapnum), .signalWindow(signalWindow), .finalVal(finalVal));

	secondtop dut(.clk_i(clk_i), .clk_en_i(clk_en_i), .rst_i(rst_i), .tap(tap), .tapnum(tapnum), .signalWindow(signalWindow), .finalVal(finalVal));

	always
		begin
		clk_i = 0; #5;
		clk_i = 1; #5;
		end
	initial
		begin
		rst_i = 0; #5;
		rst_i = 1; #5;
		rst_i = 0; 

        clk_en_i = 1;
		tapnum = 8'h00;
		tap = 16'h0004;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#5 
	
		tapnum = 8'h01;
		tap = 16'h0001;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		tapnum = 8'h02;
		tap = 16'h0002;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		tapnum = 8'h03;
		tap = 16'h0001;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;

		#10 
		tapnum = 8'h00;
		tap = 16'h0002;
		signalWindow[0] = 16'h0001;
		signalWindow[1] = 16'h0002;
		signalWindow[2] = 16'h0003;
		signalWindow[3] = 16'h0004;


        end




endmodule

/*
module secondtop_tb();
 	logic clk;
	logic reset;
    logic clk_en_i;
	logic signal_en;
	logic [23:0] signal;
	logic [15:0] tapcoeff;
	logic [7:0] tapnum;
	logic [32:0] result_o;
	logic done;


	secondtop dut(.clk(clk), .reset(reset), .clk_en_i(clk_en_i), .signal_en(signal_en), .signal(signal), .tapcoeff(tapcoeff), .tapnum(tapnum), .result_o(result_o), .done(done));

	always
		begin
		clk = 0; #5;
		clk = 1; #5;
		end
	initial
		begin
		reset = 0; #5;
		reset = 1; #5;
		reset = 0; 

        signal_en = 1;
		clk_en_i = 1;
		signal = 24'h111111;
		//tap = 16'h1234;

		#10
		signal = 24'h000000;
		tapcoeff = 16'h0004;
		tapnum = 8'h01;

		#10
		signal = 24'h222222;
		tapcoeff = 16'h0003;
		tapnum = 8'h02;

		#10
		signal = 24'h333333;
		tapcoeff = 16'h0003;
		tapnum = 8'h03;

		#10
		signal = 24'h444444;
		tapcoeff = 16'h0003;
		tapnum = 8'h00;

		#10
		signal = 24'h555555;
		tapcoeff = 16'h0003;
		tapnum = 8'h01;

        end

endmodule



*/
