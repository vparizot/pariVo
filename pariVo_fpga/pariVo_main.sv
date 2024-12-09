
// Victoria Parizot
// vparizot@hmc.edu
// 10/31/2024
// Lab 7 AES Encryption main file
// Derived from Lab 7 started code for E155 FA2024


/////////////////////////////////////////////
// aes
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

		   output logic sigwin0,
		   output logic sigwin1,
		   output logic sigwin2,
		   output logic sigwin3,
		   output logic signal_en,
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
	//logic signal_en;
	logic [15:0] signalWindow [0:9];
	logic [32:0] result_o;
	logic done;
	logic clk_en_i;
	logic dspreset;
	logic dspdone;
	logic [7:0] dspfinalVal;
	
	// check what should enable this?
	assign clk_en_i = 1;
	
	always_comb begin
		dspreset = dspdone | reset;
	end
	
	//test vals 
	
	assign sigwin0 = signalWindow[0][0];
	assign sigwin1 = left[8];
	assign sigwin2 = signalWindow[0][2];
	assign sigwin3 = signalWindow[0][3];
	
	/*
	assign sigwin0 = left[8];
	assign sigwin1 = left[9];
	assign sigwin2 = left[10];
	assign sigwin3 = left[11];
*/
	eq1_spi eqspi1(sck, sdi, sdo, done, eqVals, finalVal); //left[23:16]);  
	eq1_core coretest(clk, left[23:16], load, eqVals, done, finalVal);
	//audio_deserializer plzwork(reset, clk, bclk, lrck, din, left, right, done);
	i2s nowitllwork(clk, reset, din, bclk, lrck, scki, left, right);// signal_en);
	
	/*
	new_all_taps getalltaps(clk, reset, eqVal, tapcoeff, tapnum);
	signalwindow getsignal(clk, signal_en, reset, left, signalWindow);
	dsp dspoutput(clk, clk_en_i, dspreset, tapcoeff, tapnum, signalWindow, result_o, dspdone);
	gainred getfinalVal(clk, reset, dspdone, result_o, dspfinalVal);
	*/
endmodule

module eq1_spi(
			   input  logic sck, //
               input  logic sdi, //
			   output logic sdo, //
               input  logic done, //		   
               output logic [31:0] eqVals, //
 
			   input logic [7:0] finalVal);

	logic sdodelayed, wasdone;
	logic [7:0] finalValCaptured;
	//logic [7:0] sdosreg;
	
	
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

module eq1_core(input logic clk, 
			input logic [7:0] left,
			//input logic [7:0] right,
			input  logic         load,
            input  logic [31:0] eqVals, 
            output logic         done, 
            output logic [7:0] finalVal);
			
//logic [10:0] counter; 
logic [7:0] leftTemp;
//logic [7:0] rightTemp;
always_ff @(posedge clk) begin
	if (load) begin
		done <= 0;
		//counter <= 0;
		leftTemp <= left;
		//rightTemp <= right;
	end

		
		
	
	else begin
	//	counter <= counter +1;
	//end
	
	//if (counter == 3)
	//	begin
			finalVal <= leftTemp;//, rightTemp};
			done <= 1;
		end
end	



endmodule 


module i2s(input logic         clk,
           input logic         reset,
           input logic         din, //  PCM1808 DOUT,         PB6_G12
           output logic        bck, //  bit clock,            PA7_J2
           output logic        lrck, // left/right clk,       PA6_J1
           output logic        scki, // PCM1808 system clock, PA5_H4
           output logic [23:0] left, 
           output logic [23:0] right);
		   //output logic newsample_valid);
           //output logic        done);

   /////////////////// clock ////////////////////////////////////
  
   //   Fs = 46.875 KHz
   logic [8:0]                 prescaler; // 9-bit prescaler
   assign scki = clk;          // 256 * Fs = 12 MHz
   assign bck  = prescaler[1]; // 64  * Fs = 3 MHz = 12 MHz / 4
   assign lrck = prescaler[7]; // 1   * Fs = 12 Mhz / 256

   always_ff @(posedge clk)
     begin
        if (reset)
          prescaler <= 0;
        else
          prescaler <= prescaler + 9'd1;
     end   
   /////////////////// end clock ////////////////////////////////

   // left and right shift registers
   logic [23:0]                lsreg, rsreg;

   // samples the prescaler to figure out what bit should currently be sampled.
   // sampling occurs on bit 1 and bit 24, NOT bit 0!
   logic [4:0]                 bit_state;
   assign bit_state = prescaler[6:2];
   
   // shift register enable logic
   logic                       shift_en;
   assign shift_en = ((bit_state >= 1) && (bit_state <= 24) && !reset);
   
   // shift register operation. samples DOUT only when shift_en.
   // this should be the only register that is not clocked directly from clk!!
   always_ff @(posedge bck)
     begin
        if (!lrck && shift_en)     // left
          begin
             lsreg <= {lsreg[22:0], din};
             rsreg <= rsreg;
          end
        else if (lrck && shift_en) // right
          begin
             rsreg <= {rsreg[22:0], din};
             lsreg <= lsreg;
          end
     end // shift register operation 

   // load shift regs into output regs.
   // update both regs at once, once every fs.
   // this way, left and right will always contain a valid sample.
   logic newsample;
   assign newsample = (bit_state == 25 && lrck && prescaler[1:0] == 0); // once every cycle
   //assign newsample_valid = (bit_state >= 26 && lrck && prescaler[1:0] == 0); // once we can sample it!
   always_ff @(posedge clk)
     begin
        if (reset)
          begin
             left <= 0;
             right <= 0;
			 // done <=0;
          end
        else if (newsample)
          begin // if neg, take twos complement
             left <= lsreg;
             right <= rsreg;
			 //done <= 1;
          end
	
        else
          begin
             left <= left;
             right <= right;
          end
     end
   
endmodule // i2s





























/*
module audio_deserializer ( 
    input   logic           reset, clk, //clk aka 
    // I2S Interface
    output   logic           bclk,  // bclk
    output   logic           lrck,  // lrck
    input   logic           i_codec_adc_data, //din
    // Parallel Data Output
    output  logic [23 : 0]  o_data_left, //left
    output  logic [23 : 0]  o_data_right, //right
    output  logic           o_data_valid //done flag
);

    timeunit 1ns;
    timeprecision 1ps;

    //   Fs = 46.875 KHzk 
   logic [8:0]                 prescaler; // 9-bit prescaler
   //assign scki = clk;          // 256 * Fs = 12 MHz
   assign bclk  = prescaler[1]; // 64  * Fs = 3 MHz = 12 MHz / 4
   assign lrck = prescaler[7]; // 1   * Fs = 12 Mhz / 256
  
   always_ff @(posedge clk)
     begin
        if (reset)
          prescaler <= 0;
        else
          prescaler <= prescaler + 9'd1;
     end  

    logic codec_adc_data_meta;
    logic codec_adc_data_stable;
    logic codec_bit_clock_meta;
    logic codec_bit_clock_stable;
    logic codec_bit_clock_delay;
    logic codec_bit_clock_rising;
    logic codec_bit_clock_falling;
    logic codec_lr_clock_meta;
    logic codec_lr_clock_stable;
    logic codec_lr_clock_delay;
    logic codec_lr_clock_rising;
    logic codec_lr_clock_falling;
    logic [4 : 0] bit_counter;
    logic signed [23 : 0] shift_register_left;
    logic signed [23 : 0] shift_register_right;
    logic data_valid;

    // Edge detection for the bit and lr clocks
    always_ff @(posedge clk) begin
        // Synchronize the audio signals to i_clock, delay the codec lr and bit clock signals
        codec_adc_data_meta <= i_codec_adc_data;
        codec_adc_data_stable <= codec_adc_data_meta;
        codec_bit_clock_meta <= bclk;
        codec_bit_clock_stable <= codec_bit_clock_meta;
        codec_bit_clock_delay <= codec_bit_clock_stable;
        codec_lr_clock_meta <= lrck;
        codec_lr_clock_stable <= codec_lr_clock_meta;
        codec_lr_clock_delay <= codec_lr_clock_stable;
        // Detect bit clock rising/falling
        if ((codec_bit_clock_stable == 1) & (codec_bit_clock_delay == 0)) begin
            codec_bit_clock_rising <= 1;
        end else begin
            codec_bit_clock_rising <= 0;
        end
        if ((codec_bit_clock_stable == 0) & (codec_bit_clock_delay == 1)) begin
            codec_bit_clock_falling <= 1;
        end else begin
            codec_bit_clock_falling <= 0;
        end
        // Detect lr clock rising/falling
        if ((codec_lr_clock_stable == 1) & (codec_lr_clock_delay == 0)) begin
            codec_lr_clock_rising <= 1;
        end else begin
            codec_lr_clock_rising <= 0;
        end
        if ((codec_lr_clock_stable == 0) & (codec_lr_clock_delay == 1)) begin
            codec_lr_clock_falling <= 1;
        end else begin
            codec_lr_clock_falling <= 0;
        end
    end

    // Main FSM
    enum logic [2 : 0]  {IDLE,
                        LR_CLOCK_FALLING,
                        LEFT_DATA_SHIFT,
                        WAIT_LR_CLOCK_RISING,
                        LR_CLOCK_RISING,
                        RIGHT_DATA_SHIFT,
                        OUTPUT_GEN} fsm_state = IDLE;

    always_ff @(posedge clk) begin
        case (fsm_state)
            IDLE : begin
                bit_counter <= 0;
                shift_register_left <= 0;
                shift_register_right <= 0;
                o_data_left <= 0;
                o_data_right <= 0;
                o_data_valid <= 0;
                data_valid <= 0;
                if (codec_lr_clock_falling == 1) begin
                    fsm_state <= LR_CLOCK_FALLING;
                end
            end

            LR_CLOCK_FALLING : begin
                if (codec_bit_clock_rising == 1) begin
                    fsm_state <= LEFT_DATA_SHIFT;
                end
            end

            LEFT_DATA_SHIFT : begin
                if (codec_bit_clock_rising == 1) begin
                    bit_counter <= bit_counter + 1;
                    shift_register_left <= {shift_register_left[22:0], codec_adc_data_stable};
                end
                if (bit_counter == 24) begin
                    bit_counter <= 0;
                    fsm_state <= WAIT_LR_CLOCK_RISING;
                end
            end

            WAIT_LR_CLOCK_RISING : begin
                if (codec_lr_clock_rising == 1) begin
                    fsm_state <= LR_CLOCK_RISING;
                end
            end

            LR_CLOCK_RISING : begin
                if (codec_bit_clock_rising == 1) begin
                    fsm_state <= RIGHT_DATA_SHIFT;
                end
            end

            RIGHT_DATA_SHIFT : begin
                if (codec_bit_clock_rising == 1) begin
                    bit_counter <= bit_counter + 1;
                    shift_register_right <= {shift_register_right[22:0], codec_adc_data_stable};
                end
                if (bit_counter == 24) begin
                    bit_counter <= 0;
                    fsm_state <= OUTPUT_GEN;
                end
            end

            OUTPUT_GEN : begin
                o_data_left <= shift_register_left;
                o_data_right <= shift_register_right;
                o_data_valid <= 1;
                data_valid <= 1;
                fsm_state <= IDLE;
            end

            default : begin
                fsm_state <= IDLE;
                o_data_left <= 0;
                o_data_right <= 0;
                o_data_valid <= 0;
                data_valid <= 0;
            end
        endcase
    end

endmodule

*/

	
	//eq1_core core(clk, load, eqVals, done, finalVal);
	
	//i2spcm try(clk, reset, load, din, bck, lrck, scki, left, right, done);
	
	
	
    //logic [31:0] eqVals;
	/*
	logic done;
	logic eqDone;
	assign done = 1;
    logic clk;
	logic clk_i;
	logic [7:0] tapnum;
	logic [15:0] tapcoeff;
	logic [15:0] signalWindow [0:9];
	logic clk_en_i;
	logic dspreset;
	logic result_o; */
 	
	//HSOSC #(.CLKHF_DIV ("0b10")) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk_i));	// set divider to 0b10 to get 12MHz clock
	//logic [23:0] left, right;
	//logic newsample_valid;
	
	//i2spcm pcm_in(clk_i, reset, din, bck, lrck, scki, left, right, newsample_valid);
	
	//logic [7:0] finalVal;
	//assign finalVal = left[23:17];
	
	//always_comb begin
	//	dspreset = done | reset;
	//end	
	
	
    //eq_spi eqspi(reset, sck, sdi, sdo, done, eqDone, ce, eqVals, ledTest1, ledTest2, ledTest3, 8'b01010110);
	
	/*
	logic [7:0] lefteqVal;
	assign lefteqVal = eqVals[7:0];
	assign testTap = tapnum[0];
	assign testCoeff = tapcoeff[0];
	assign testSig = signalWindow[0];
	assign clk_en_i = 1;
	
	new_all_taps getalltaps(clk_i, reset, lefteqVal, tapcoeff, tapnum);
	
	signalwindow getsignal(clk_i, newsample_valid, reset, left, signalWindow);
	
	//dsp dspoutput(clk_i, clk_en_i, dspreset, tapcoeff, tapnum, signalWindow, result_o, done);


		
	// where [23:0] left and right are 24-bit amplitude sample
	


	
	
	//hardware_test ht(clk, eqVals, ledTest);
	/*
	logic [15:0] data_a_i;
	logic [15:0] data_b_i;
	logic [32:0] result_o;
	logic clk_en_i;
	//logic clk_i;
	logic rst_i;
	assign rst_i = ~reset;
	assign clk_en_i = 1;
	

    //always_ff @(posedge clk_i) begin  
       assign data_a_i = 16'h0001;
       assign data_b_i = 16'h0001;
    //end
	
	SB_MAC16 realmac(.clk_i(clk_i), .clk_en_i(clk_en_i), .rst_i(rst_i), .data_a_i(data_a_i), .data_b_i(data_b_i), .result_o(result_o));
	
	assign ledTest = result_o[0]; */
   


//	eq1_core core(clk, load, eqVals, done, finalVal);















































////////////////////////////////////
//Victoria's top module 11/26
/////////////////////////////////////
/*
module top( input logic        nreset, //  global reset,      P34
            input logic			din, //     I2S DOUT,          P19
            output logic       bck, //     I2S bit clock,     P18
            output logic       lrck, //    I2S l/r clk,       P13
            output logic       scki,
			//output logic bck, 
            output logic dout, left1, right1, newsample_valid);
			//output logic lrck);    
			
	HSOSC #(.CLKHF_DIV ("0b10")) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));	// set divider to 0b10 to get 12MHz clock
	
	// assign reset
	logic reset;
	assign reset = ~(nreset);
	
	// logic [23:0] left, right;
	i2spcm pcm_in(clk, reset, din, bck, lrck, scki, left1, right1, newsample_valid);

	//logic [15:0] leftOut;
	//assign leftOut = left[15:0];
	//logic [15:0] rightOut;
	//assign rightOut = right[15:0];
	
	
	i2sOut audio_out(clk, reset, dout, left1, right1);// newsample_valid); 

	//i2sOut audio_out(clk, bck, lrck, dout, left1, right1, newsample);
	//i2sOut audio_out(clk, bck, lrck, reset, left1, right1, dout);
	
endmodule
*/


/*
module shift_out(
    input wire sck,                   // Serial clock input
    input wire [7:0] finalVal,    // 128-bit ciphertext input
    output reg sdo                    // Serial data output
);

// Internal signals
reg [7:0] bit_counter;  // 8-bit counter to track the number of bits shifted
reg [7:0] shift_reg;   // Register holding the data to shift out

// Initializing shift register and counter
initial begin
    shift_reg = 8'd0;    // Initialize the shift register to zero
    bit_counter = 8'd0;    // Initialize the bit counter to zero
    sdo = 1'b0;            // Initial state of serial output (optional)
end

// Always block triggered on the negative edge of sck (to shift data)
always_ff @(negedge sck) begin
    if (bit_counter < 8) begin
        // Shift the data and increment the counter
        sdo <= shift_reg[7];  // Output the MSB of the shift register
        shift_reg <= {shift_reg[6:0], 1'b0};  // Shift left by 1 bit
        bit_counter <= bit_counter + 1;  // Increment the bit counter
    end else begin
        // When all 128 bits are shifted, keep sdo at 0 (or any other final value)
        sdo <= 1'b0;  // Optional: keep sdo low after all bits are shifted
		bit_counter <= 0;
    end
end

// Initialize the shift register with the ciphertext once
always_ff @(posedge sck) begin
    if (bit_counter == 0) begin
        shift_reg <= finalVal;  // Load the ciphertext into the shift register at the start
    end
end

endmodule

*/

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
///////////////////////////////////////////// 





/*
/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
///////////////////////////////////////////// 
module eq_spi(input logic reset, 
	
			   input  logic sck, //
               input  logic sdi, //
			   output logic sdo, //
               input  logic done, //
			   
			   output logic eqDone,
			   input logic ce,
			   
               output logic [31:0] eqVals, //
			   
			   output logic ledTest1,
			   output logic ledTest2,
			   output logic ledTest3,
			   
			   input logic [7:0] finalVal //
			   );

	logic sdodelayed, wasdone;
	logic [7:0] finalValCaptured;
	
	logic [5:0] shiftCount, nextShiftCount;

	 // TODO: DONE WILL BE DSP ENABLE
	
	// eqVals SPI -- shift 32 bits at posedge of sck
	always_ff @(posedge sck, posedge reset) begin
		if(reset) begin
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
	
	always_ff @(posedge sck)
        if (!wasdone)  {finalValCaptured} = {finalVal[7:0]}; //, plaintext[126:0], key, sdi};
        else           {finalValCaptured} = {finalValCaptured[6:0]};
    
	
	
	// sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = finalValCaptured[6];
    end
    
    // when done is first asserted, shift out msb before clock edge
    //assign sdo = (done & !wasdone) ? finalVal[7] : sdodelayed;
	assign sdo = finalVal;

	always_comb
		// reset shiftCount after 32 bits
		if (shiftCount == 32) nextShiftCount = 0;
		else nextShiftCount = shiftCount + 1;
	assign eqDone = ~ce; 
	
endmodule
*/
