module signalwindow (input logic clk, en, reset,
                    input logic [23:0] signal,
                    output logic [15:0] signalWindow [0:9]);
   
   // question: what should enable the shifting?
   // ans: enable from the adc when it gets a new signal
    logic [15:0] shortSignal;
    assign shortSignal = signal[23:8]; 
    logic [15:0] tempsignalWindow [0:3];
	
	// creates a signal window of past 10 inputs to be used for FIR filtering 
    always_ff @(posedge clk)
      if (reset) begin
            signalWindow[9] <= 0;
            signalWindow[8] <= 0;
            signalWindow[7] <= 0;
            signalWindow[6] <= 0;
            signalWindow[5] <= 0;
            signalWindow[4] <= 0;
            signalWindow[3] <= 0;
            signalWindow[2] <= 0;
            signalWindow[1] <= 0;
            signalWindow[0] <= 0;
      end
      else if(en) begin
            signalWindow[9] <= signalWindow[8];
            signalWindow[8] <= signalWindow[7];
            signalWindow[7] <= signalWindow[6];
            signalWindow[6] <= signalWindow[5];
            signalWindow[5] <= signalWindow[4];
            signalWindow[4] <= signalWindow[3];
            signalWindow[3] <= signalWindow[2];
            signalWindow[2] <= signalWindow[1];
            signalWindow[1] <= signalWindow[0];
            signalWindow[0] <= shortSignal;
        end
		else begin
            signalWindow[9] <= signalWindow[9];
            signalWindow[8] <= signalWindow[8];
            signalWindow[7] <= signalWindow[7];
            signalWindow[6] <= signalWindow[6];
            signalWindow[5] <= signalWindow[5];
            signalWindow[4] <= signalWindow[4];
            signalWindow[3] <= signalWindow[3];
            signalWindow[2] <= signalWindow[2];
            signalWindow[1] <= signalWindow[1];
            signalWindow[0] <= signalWindow[0];
        end
     //end // shift register operation 
     

endmodule 


module dsp(input logic clk_i, clk_en_i, rst_i,
            input logic [15:0] tap,
            input logic [7:0] tapnum,
            input logic [15:0] signalWindow [0:9],
            output logic [32:0] result_o,
            output logic done);

    logic [15:0] data_a_i;
    logic [15:0] data_b_i;
    
	// sets inputs of MAC to be the tap and its corresponding signal
    always_ff @(posedge clk_i) begin  
       if(rst_i) begin
       data_a_i <= 0;
       data_b_i <= 0;
       end 
       else begin
       data_a_i <= tap;
       data_b_i <= signalWindow[9-tapnum];
       end
    end

    always_comb begin
        if(tapnum != 3) done = 0;  // wait until after data is done sending
        else done = 1;
   
    end
	
	// utilizes on-board MAC block 
    SB_MAC16 realmac(.clk_i(clk_i), .clk_en_i(clk_en_i), .rst_i(rst_i), .data_a_i(data_a_i), .data_b_i(data_b_i), .result_o(result_o));

   
        
endmodule 

module gainred(input logic clk, reset, 
            input logic done,
            input logic [32:0] result,
            output logic [7:0] finalVal);

    logic [32:0] tempResult;
    logic[3:0] gain;
	
	// hard coded gain value
    assign gain = 4'h0;

	// divides final result from MAC by gain of filters
    always_ff @(posedge clk) begin
        if(reset) begin 
            tempResult <= 0;
        end
        else begin 
            tempResult <= result >> gain;
        end
    end

    always_ff @(negedge clk) begin
        if(reset) finalVal <= 0;
        // change this to msb (previously 32:17)
        else if (done) finalVal <= tempResult[7:0];
    end


endmodule

module faketop(input logic clk, reset, rst_i,
                input logic clk_en_i,
                input logic signal_en,
                input logic [23:0] signal,
                input logic [7:0] eqVal,
                output logic [15:0] finalVal,
                output logic done);

// top module for only digital filtering

logic [15:0] tapcoeff;
logic [7:0] tapnum;
logic [15:0] signalWindow [0:9];

logic dspreset;
logic tapReset;
logic [7:0] resetCounter = 0;
logic [7:0] nextresetCounter = 0;
logic dataDone;
logic [32:0] result_o;
logic newsamplevalid;

always_comb begin
    dspreset = done | rst_i;
end

logic tap;

new_all_taps getalltaps(clk, reset, eqVal, tapcoeff, tapnum);

signalwindow getsignal(clk, signal_en, reset, signal, signalWindow);

dsp dspoutput(clk, clk_en_i, dspreset, tapcoeff, tapnum, signalWindow, result_o, done);

gainred getfinalVal(clk, reset, done, result_o, finalVal);


endmodule
