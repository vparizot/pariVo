// Victoria Parizot & Audrey Vo
// vparizot@hmc.edu & avo@g.hmc.edu
// 10/31/2024
// I2S Communication & SPI Handler


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
		  
  
   //   Fs = 92KkHz
   logic [8:0]                 prescaler; // 9-bit prescaler
   assign scki = clk;          // 256 * Fs = 24 Mhz
   assign bck  = prescaler[1]; // 64  * Fs
   assign lrck = prescaler[7]; // 1   * Fs 

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
			 
          end
        else if (newsample)
          begin // if neg, take twos complement
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

