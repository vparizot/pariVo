// digitalFiltering d1(clk, reset, filterCoefficients, eqLow0, eqHigh0, audioIn, audioOut)
// Implement FIR (Finite Impulse Response)
module digitalFiltering(input logic clk, 
                        input logic reset,
                        //input logic filterCoefficients, // 
                        input logic [7:0] eq, // Corner freq for low pass and high pass filter The four eq upper and lower bounds for channels 0 and 1
                        input logic [23:0] musicPacketIn, // 24-bit block of the music to process
                        output logic [23:0] musicPacketOut); 
	// Define internal variables
	//logic [23:0] filteredOutput;
    //logic [23:0] audioIn;
    logic [23:0] coeff[3:0] =  {24'd500, 24'd1000, 24'd1000, 24'd500};  // Coefficients for a 5-tap FIR filter
    logic [23:0] shiftReg[3:0]; // Shift registers to hold prev values WILL THIS UPDATE FOR EACH TIME THIS FUNC IS CALLED
    logic [3:0] i = 0;
    logic [3:0] numTaps = 5;

	// determine coefficients

// hard code selections
// make potentiometer a rotary switch
// matlab simulation to determine TAPS for filter design
    // miore taps we have between 5 and 10
    // program multipliers
    // look at ice40 website
// on i2c ADC acts slave
// DSP functional blocks and DSP functional useage guide

// LOW PASS FILTER w/ FIR
    always @(posedge clk) begin
        // Shift register to hold previous samples
        for (i = numTaps; i > 0; i = i - 1)
            shiftReg[i] <= shiftReg[i-1];
        shiftReg[0] <= musicPacketIn;

        // FIR filtering - multiply and accumulate
        musicPacketOut <= 0;
        for (i = 0; i <= numTaps; i = i + 1)
            musicPacketOut <= musicPacketOut + (shiftReg[i] * coeff[i]);
    end 


endmodule

