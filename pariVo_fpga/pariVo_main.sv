
// Victoria Parizot
// vparizot@hmc.edu
// 10/31/2024
// Lab 7 AES Encryption main file
// Derived from Lab 7 started code for E155 FA2024


/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////
module top(input logic reset,
		   input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
		   input  logic ce,
           output logic done, 
		   output logic ledTest1,
		   output logic ledTest2,
		   output logic ledTest3);
             
    logic [31:0] eqVals;
    logic clk;
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
            
    eq_spi eqspi(reset, sck, sdi, done, ce, eqVals, ledTest1, ledTest2, ledTest3);   
	
	//hardware_test ht(clk, eqVals, ledTest);
   
endmodule

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////
module eq_spi(input logic reset, 
			   input  logic sck, 
               input  logic sdi,
               output  logic done,
			   input logic ce,
               output logic [31:0] eqVals,
			   output logic ledTest1,
			   output logic ledTest2,
			   output logic ledTest3);

	logic [5:0] shiftCount, nextShiftCount;
	
	// shift 32 bits at posedge of sck
	always_ff @(posedge sck, posedge reset) begin
		if(reset) begin
			eqVals <= 0;
			shiftCount <= 0;
		end
		else if (ce) begin
			eqVals <= {eqVals[30:0], sdi};
			shiftCount <= nextShiftCount;
			// test LEDs
			ledTest1 <= eqVals[0];
			ledTest2 <= eqVals[1];
			ledTest3 <= eqVals[2];
		end
	end
	
	always_comb
		// reset shiftCount after 32 bits
		if (shiftCount == 32) nextShiftCount = 0;
		else nextShiftCount = shiftCount + 1;
	assign done = ~ce; 
endmodule
