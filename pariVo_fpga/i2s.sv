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
    logic [23:0] coeff[0:3] =  {24'd500, 24'd1000, 24'd1000, 24'd500};  // Coefficients for a 5-tap FIR filter
    logic [23:0] shiftReg[0:3]; // Shift registers to hold prev values WILL THIS UPDATE FOR EACH TIME THIS FUNC IS CALLED
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


module final_fpga(input logic        clk,   //   12MHz MAX1000 clk, H6
                  input logic        reset, //  global reset,      E6 (right btn)
                  input logic        din, //     I2S DOUT,          PB6_G12
                  input logic        uscki, //   SPI clk,           PB3_J12
                  input logic        umosi, //   SPI MOSI,          PB5_J13
                  input logic        uce, //     SPI CE,            PA10_L12
                  input logic [3:0]  sw1, //     threshold sel.     E1, C2, C1, D1 (DIP SW1)
                  output logic       bck, //     I2S bit clock,     PA7_J2
                  output logic       lrck, //    I2S l/r clk,       PA6_J1
                  output logic       scki, //    PCM1808 sys clk,   PA5_H4
                  output logic       fmt, //     PCM1808 FMT,       PA8_J10
                  output logic [1:0] md, //      PCM1808 MD1 & MD0, PC7_H13, PA9_H10
                  output logic       miso, //    SPI MISO,          PB4_K11
                  output logic       LEDs, //    debug LEDs         (see MAX1000 user guide)
                  output logic       beat_out // beat (to MCU)      H5 (thru a jumper to MCU)
                  );

   ///////////////////////////////// I2S/PCM1808
   //logic                             newsample;
   //logic [23:0]                      left, right;
   //i2s pcm_in(clk, reset, din, bck, lrck, scki, left, right, newsample);
   ///////////////////////////////// end I2S/PCM1808


   ///////////////////////////////// Digital Filtering
   //logic [7:0] eqHigh0, eqLow0, eqHigh1, eqLow1; // The four eq upper and lower bounds for channels 0 and 1
   //logic [23:0] 
   //logic signed [23:0]    

//    logic                             fft_start, fft_done, i2s_load, fft_load, fft_reset, fft_creset, fft_write;
//    logic [31:0]                      fft_wd;
//    logic signed [15:0]               left_msbs;
//    logic signed [15:0]               fft_rd;
//    logic [5:0]                       sample_ctr;
   
//    assign fft_reset = reset | fft_creset;
//    assign left_msbs = left[23:8];
//    assign fft_rd    = left_msbs >>> 5; // arithmetic shift right
//    fft fft(clk, fft_reset, fft_start, fft_load, fft_rd, fft_wd, fft_done);
//    fft_control i2s_fft_glue(clk, reset, newsample, fft_done, fft_start, fft_load, fft_creset, fft_write, sample_ctr);

   ///////////////////////////////// end Digital Filtering

   ///////////////////////////////// store result         
//   logic [31:0]                      res_count; // result count
//   logic                             posedge_fft_done;
//   pos_edge pos_edge_fft_done(clk, fft_done, posedge_fft_done);
//   always_ff @(posedge clk)
//     begin
//        if       (reset)    res_count <= 0;
//        else if (posedge_fft_done) res_count <= res_count + 1'b1;
//     end
//
//   logic [31:0]                       spectrum_result [0:31];
//   always_ff @(posedge clk) begin
//      if (fft_write) 
//        begin
//           spectrum_result[sample_ctr] <= fft_wd;
//        end
//   end
   ///////////////////////////////// end store result

   ///////////////////////////////// SPI
//   logic [31:0] spi_data;
//   logic [4:0]  spi_adr;
//   assign spi_data = spectrum_result[spi_adr];
//   spi_slave spi(clk, reset, uscki, umosi, uce, spi_data, spi_adr, miso);
   ///////////////////////////////// end SPI

   ///////////////////////////////// beat tracking
//   logic [7:0]  thresh, accum_stable;
//   logic        beat_ctr, posedge_beat_out;
//   assign thresh = {1'b0, sw1, 2'b0};
//   assign LEDs   = {accum_stable[7:1], beat_ctr};
//   beat_track beattrack(clk, reset, sample_ctr, fft_wd, fft_write, fft_done, thresh, beat_out, accum_stable);
//   pos_edge pos_edge_beat_out(clk, beat_out, posedge_beat_out);
   
//   always_ff @(posedge clk) begin
//      if (reset)
//        beat_ctr <= 0;
//      else if (posedge_beat_out)
//        beat_ctr <= beat_ctr + 1'b1;
//   end
   ///////////////////////////////// end beat tracking
   
endmodule // final_fpga



module i2s(input logic         clk,
           input logic         reset,
           input logic         din, //  PCM1808 DOUT,         PB6_G12
           output logic        bck, //  bit clock,            PA7_J2
           output logic        lrck, // left/right clk,       PA6_J1
           output logic        scki, // PCM1808 system clock, PA5_H4
           output logic [23:0] left, 
           output logic [23:0] right,
           output logic        newsample_valid);

   /////////////////// clock ////////////////////////////////////
  
   //   Fs = 46.875 KHz
   logic [8:0]                 prescaler; // 9-bit prescaler
   assign scki = clk;          // 256 * Fs = 12 MHz
   assign bck  = prescaler[1]; // 64  * Fs = 3 MHz = 12 MHz / 4
   assign lrck = prescaler[7]; // 1   * Fs = 12 Mhz / 256
   
	//logic dintemp;
	//assign dintemp = din;
	
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
   assign newsample_valid = (bit_state == 26 && lrck && prescaler[1:0] == 0); // once we can sample it!
   always_ff @(posedge clk)
     begin
        if (reset)
          begin
             left <= 0;
             right <= 0;
          end
        else if (newsample)
          begin
             left <= lsreg;
             right <= rsreg;
          end
        else
          begin
             left <= left;
             right <= right;
          end
     end
   
endmodule // i2s