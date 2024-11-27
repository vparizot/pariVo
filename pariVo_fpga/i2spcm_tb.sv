module i2spcm_tb();

    logic clk, reset, din, bck, lrck, scki;
    logic [24:0] left, right;
    logic newsample_valid;

   logic [8:0]  i;

   initial
     forever begin
        clk = 1'b0; #5;
        clk = 1'b1; #5;
     end

   initial begin
      reset = 1'b1;
      i = 0;
   end

   i2spcm dut( .clk(clk), .reset(reset), .din(din), .bck(bck), .lrck(lrck), .scki(scki), .left(left), .right(right), .newsample_valid(newsample_valid)); //i2s dut(clk, reset, din, bck, lrck, scki, left, right);

   always @(posedge clk) begin
      if (i == 10)
        reset = 0;
      i = i + 1;
   end
endmodule // i2s_testbench

    // always
    //     begin
    //     clk = 0; #5;
    //     clk = 1; #5;
    //     end

    // initial
    //     begin
    //     //valid = 1;
    //     reset = 1;
    //     #25;
    //     reset = 0;


    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b0;
    //     #25;
    //     din = 1'b1;
    //     #25;
    //     din = 1'b1;
    //     #25;

        
//    module i2spcm(input logic         clk,
//            input logic         reset,
//            input logic         din, //  PCM1808 DOUT,         PB6
//            output logic        bck, //  bit clock,            PA7
//            output logic        lrck, // left/right clk,       PA6
//            output logic        scki, // PCM1808 system clock, PA5
//            output logic [23:0] left, 
//            output logic [23:0] right,
// 		   output logic newsample);     

   
        
   

    // always @(posedge clk) begin
    //     if (i == 10) reset = 1; i = 0;
    //     i = i+1;

    // end

//endmodule