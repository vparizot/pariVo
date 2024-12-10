// Victoria Parizot & Audrey Vo
// vparizot@hmc.edu & avo@g.hmc.edu
// 10/31/2024
// Derived from Lab 7 started code for E155 FA2024


/////////////////////////////////////////////
// top
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////


module top(input logic nreset,
		   input logic din, // I2S DOUT, P19
		   
		   input  logic sck, // SPI!! from MCU P21 for SPI 
           input  logic sdi, //  SPI!! mosi
		   
		   output logic       bclk, //     I2S bit clock,     P18
           output logic       lrck, //    I2S l/r clk,       P13
           output logic       scki,
		   
           output logic sdo, // SPI!!
           input  logic load, // SPI!!
		   output logic done  // SPI!!
		  );
		  
    // assign reset
	logic reset;
	assign reset = ~(nreset);
	
	logic clk;
    HSOSC #(.CLKHF_DIV ("0b01")) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));	// set divider to 0b01 get 24MHz clock
	
	logic [7:0] finalVal;
	logic [31:0] eqVals;
	logic [23:0] left, right;
	logic [7:0] eqVal;
	
	assign eqVal = 8'h0;
	
	logic [15:0] tapcoeff;
	logic [7:0] tapnum;
	logic [15:0] signalWindow [0:9];
	logic [32:0] result_o;
	logic done;
	logic clk_en_i;
	logic dspreset;
	logic dspdone;
	logic [7:0] dspfinalVal;
	
	assign clk_en_i = 1;
	
	always_comb begin
		dspreset = dspdone | reset;
	end

	eq1_spi eqspi1(sck, sdi, sdo, done, eqVals, finalVal); //left[23:16]);  
	eq1_core coretest(clk, left[23:16], load, eqVals, done, finalVal);
	i2s nowitllwork(clk, reset, din, bclk, lrck, scki, left, right);// signal_en);
	
endmodule

module eq1_spi(
			   input  logic sck, 
               input  logic sdi, 
			   output logic sdo,
               input  logic done,	   
               output logic [31:0] eqVals, 
			   input logic [7:0] finalVal);

	logic sdodelayed, wasdone;
	logic [7:0] finalValCaptured;

	always_ff @(posedge sck) begin
        if (!wasdone)  {finalValCaptured, eqVals} = {finalVal, eqVals[30:0], sdi};
        else   begin
			{finalValCaptured, eqVals} = {finalValCaptured[6:0], eqVals, sdi}; 
		end
    end
	
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = finalValCaptured[6];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo =  (done & !wasdone) ? finalVal[7] : sdodelayed;

endmodule
