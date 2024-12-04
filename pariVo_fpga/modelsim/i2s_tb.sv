module i2s_testbench();
   logic clk, reset, din, bck, lrck, scki;
   logic [23:0] left, right; // 23 + 1 msb pad
   logic [8:0]  i;
   logic load;
   logic newsample_valid;
    
    i2spcm dut(clk, reset, load, din, bck, lrck, left, right, newsample_valid);

   initial
     forever begin // defines sck
        clk = 1'b0; #1;
        clk = 1'b1; #1;
     end

    initial 
        forever begin
        bck = 1'b0; #4;
        bck = 1'b1; #4;
        end

    initial 
        forever begin
        lrck = 1'b0; #256;
        lrck = 1'b1; #256;
        end

   initial begin

reset = 1'b0; #10;   
reset = 1'b1; #10; 
    reset = 1'b0;
    i = 0;
    #8; // wait one bclk before sending dout

    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    // add more din values w/ #8 wait between, where 24 vals are read, but 32 vals per WS signal
  

    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;

    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
    din = 1; #8;
    din = 0; #8;
    din = 0; #8;
   end

   

//    always @(posedge clk) begin
//       if (i == 10)
//         reset = 0;
//       i = i + 1;
//    end
endmodule // i2s_testbench

