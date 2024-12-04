module i2spcm(input logic      clk,
           input logic         reset,
		   input logic         load,
           input logic         din, //  PCM1808 DOUT,         PB6
           output logic        bck, //  bit clock,            PA7
           output logic        lrck, // left/right clk,       PA6
           output logic        scki, // PCM1808 system clock, PA5
           output logic [23:0] left, 
           output logic [23:0] right,
		   //output logic done);

   /////////////////// clock ////////////////////////////////////
  
   //   Fs = 46.875 KHzk 
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
   logic [23:0]                lsreg2, rsreg2;
   
   logic lselec, rselec;

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
				 if(lselec) begin
				 lsreg <= {lsreg[22:0], din};
				 rsreg <= rsreg;
				 lsreg2 <= lsreg2;
				 rsreg2 <= rsreg2;
			 end
				 else begin
				 lsreg2 <= {lsreg2[22:0], din};
				 rsreg2 <= rsreg2;
				 lsreg <= lsreg;
				 rsreg <= rsreg;
				 end
			 end

        else if (lrck && shift_en) // right

			 if(rselec) begin 
             rsreg <= {rsreg[22:0], din};
             lsreg <= lsreg;
			 lsreg2 <= lsreg2;
			 rsreg2 <= rsreg2;
          end
			 else begin
			 rsreg2 <= {rsreg2[22:0], din};
             lsreg <= lsreg;
			 lsreg2 <= lsreg2;
			 rsreg <= rsreg;
		  end
		  else begin
			  rsreg <= 24'd0;
			  lsreg <= 24'd0;
			  rsreg2 <= 24'd0;
			  lsreg2 <= 24'd0;
			end
     end // shift register operation 

   // load shift regs into output regs.
   // update both regs at once, once every fs.
   // this way, left and right will always contain a valid sample.
   logic newsample;
   assign newsample = (bit_state == 25 && lrck && prescaler[1:0] == 0); // once every cycle
   assign done = (bit_state == 26 && lrck && prescaler[1:0] == 0); // once we can sample it!
   logic counter;
   
   always_ff @(posedge clk)
     begin
        if (reset|load)
          begin  
             left <= 0;
             right <= 0;
			 
          end
        else if (newsample)
          begin
			 if(lselec) left <= lsreg2;
		     else left <= lsreg;
             if(rselec) right <= rsreg2;
		     else right <= rsreg;
          end
        else
          begin
             left <= left;
             right <= right;
          end
     end
endmodule 
/*
module i2sOut( 
    input   logic           clk, //clk
    input   logic           reset,
    output  logic           dout, // dout
    // Parallel Data Input
    input   logic [23 : 0]  left, //left
    input   logic [23 : 0]  right //right
    //input   logic           valid //valid?
);

    // Main FSM
    typedef enum logic [3:0]  {S0 = 0, S1 = 1, S2 = 2} statetype;
    statetype state, nextstate;

   //   Fs = 46.875 KHzk 
   logic [8:0] prescaler; // 9-bit prescaler
   logic bclk, ws;
   assign bclk  = prescaler[1]; // 64  * Fs = 3 MHz = 12 MHz / 4
   assign ws = prescaler[7]; // 1   * Fs = 12 Mhz / 256
   logic valid;
   always_ff @(posedge clk)
     begin
        if (reset) begin
          prescaler <= 0;
	        valid <= 1;
        end else begin
          prescaler <= prescaler + 9'd1;
        end
     end   




    logic [4 : 0] bit_counter, nextbit_counter;
    logic signed [23 : 0] shift_register_left;
    logic signed [23 : 0] shift_register_right;
    
    always_ff @(posedge bclk) begin
        if (reset) begin
            state <= S0;
            //bit_counter <= 0;
        end 
        state <= nextstate;
        bit_counter = nextbit_counter;
    end

    always_comb 
        case (state)
            S0 : begin
                nextbit_counter <= 0;
                shift_register_left <= 0;
                shift_register_right <= 0;
                dout <= 0;
                if (valid == 1) begin
                    nextstate <= S1;
                    shift_register_left <= left;
                    shift_register_right <= right;
                end
            end

            S1 : begin
                dout <= shift_register_left[23];
                nextbit_counter <= bit_counter + 1;
                if (bit_counter == 23) begin
                    nextstate <= S2;
                    nextbit_counter <= 0;
                end else begin
                    shift_register_left <= {shift_register_left[22:0], 1'b0};
                    nextstate <= state;
                end
            end

            S2 : begin
                dout <= shift_register_right[23];
    
                nextbit_counter <= bit_counter + 1;
                if (bit_counter == 23) begin
                    nextstate <= S0;
                    nextbit_counter <= 0;
                end else begin
                    shift_register_right <= {shift_register_right[22:0], 1'b0};
                    nextstate <= state;
                end
            end
            default : begin
                nextstate <= S0;
                dout <= 0;
                nextbit_counter <= 0;
            end
        endcase

        // assign 
    

endmodule
*/
