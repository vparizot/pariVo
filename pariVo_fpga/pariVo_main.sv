
// Victoria Parizot
// vparizot@hmc.edu
// 10/31/2024
// Lab 7 AES Encryption main file
// Derived from Lab 7 started code for E155 FA2024


/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

/*
module top(input logic reset,
		   input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
		   input  logic ce,
		   output logic ledTest1,
		   output logic ledTest2,
		   output logic ledTest3);
             
    logic [31:0] eqVals;
	logic done;
    logic clk;
 	
	
    eq_spi eqspi(reset, sck, sdi, done, ce, eqVals, ledTest1, ledTest2, ledTest3);   
	
	//hardware_test ht(clk, eqVals, ledTest);
   
endmodule
*/


module top( //input logic        clk,   //   12MHz MAX1000 clk, P12
            input logic        nreset, //  global reset,      P34
            input logic			din, //     I2S DOUT,          P19
            output logic       bck, //     I2S bit clock,     P18
            output logic       lrck, //    I2S l/r clk,       P13
            output logic       scki,
			output logic left, 
            output logic right,
			output logic clk); //    PCM1808 sys clk,   P4
           
			
	HSOSC #(.CLKHF_DIV ("0b10")) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));	// set divider to 0b10 to get 12MHz clock
	
	// assign reset
	logic reset;
	assign reset = ~(nreset);
	
	// logic [23:0] left, right;
	
	i2s pcm_in(clk, reset, din, bck, lrck, scki, left, right);

	logic [15:0] leftOut = left[23:7];
	logic [15:0] rightOut = right[23:7];

	i2sOut audio_out(clk, reset, leftOut, rightOut, bckout, lrckout, dout);
	 
	
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
			   output logic ledTest3
			   );

	logic [5:0] shiftCount, nextShiftCount;
	logic realReset;
	assign realReset = ~reset;
	
	// shift 32 bits at posedge of sck
	always_ff @(posedge sck, posedge realReset) begin
		if(realReset) begin
			eqVals <= 0;
			shiftCount <= 0;
		end
		else if (ce) begin
			// shift for 32 sclks to eqVals
			eqVals <= {eqVals[30:0], sdi};
			shiftCount <= nextShiftCount;
			// test LEDs
			ledTest1 <= eqVals[0];
			ledTest2 <= eqVals[1];
			if(eqVals[31:0] == 32'h12345678) ledTest3 <= 1;
			else ledTest3 <= 0;
		end
	end
	
	always_comb
		// reset shiftCount after 32 bits
		if (shiftCount == 32) nextShiftCount = 0;
		else nextShiftCount = shiftCount + 1;
	assign done = ~ce; 
endmodule
