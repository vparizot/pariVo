
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
             
    logic [31:0] nonsense, eqVals;
    logic clk;
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
            
    eq_spi spi(reset, sck, sdi, sdo, done, ce, eqVals, nonsense, ledTest1, ledTest2, ledTest3);   
	
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
               output logic sdo,
               output  logic done,
			   input logic ce,
               output logic [31:0] eqVals,
               input  logic [31:0] nonsense,
			   output logic ledTest1,
			   output logic ledTest2,
			   output logic ledTest3);

    //logic         sdodelayed, wasdone;
    //logic [31:0] nonsenseCaptured;
               
    // assert load
    // apply 32 sclks to shift in nonsense, starting with eqVals[31]
    // then deassert load, wait until done
    // then apply 32 sclks to shift out eqVals, starting with nonsense[31]
    // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
    // edge is a rising edge (clock going from low in the idle state to high).
   /* always_ff @(posedge sck)
        if (!wasdone)  begin {nonsenseCaptured, eqVals} = {nonsense, eqVals[30:0], sdi};
							if(eqVals[0]) ledTest <= 1;
								else ledTest <= 0;
						end
        else           {nonsenseCaptured, eqVals} = {nonsense[30:0], eqVals, sdi}; 
    
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = eqVals[30];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo = (done & !wasdone) ? eqVals[31] : sdodelayed;
	
	assign sdo = 0;
    
	*/
	logic [3:0] shiftCount, nextShiftCount;
	
	always_ff @(posedge sck, posedge reset) begin
		if(reset) begin
			eqVals <= 0;
			shiftCount <= 0;
		end
		else if (ce) begin
			eqVals <= {eqVals[30:0], sdi};
			shiftCount <= nextShiftCount;
			ledTest1 <= eqVals[0];
			ledTest2 <= eqVals[1];
			ledTest3 <= eqVals[2];
		end
	end
	
	always_comb
		if (shiftCount == 32) nextShiftCount = 0;
		else nextShiftCount = shiftCount + 1;
	assign done = ~ce; 
endmodule
