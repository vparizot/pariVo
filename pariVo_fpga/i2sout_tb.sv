// Victoria Parizot
// vparizot@hmc.edu
// 11/25/2024

module i2sout_tb();

    logic clk, i;
    logic dout;
    logic reset;

    
    logic [23:0] left, right;
    //logic valid;

    i2s dut( .clk(clk), .reset(reset), .dout(dout), .left(left), .right(right));
    
    always
        begin
        clk = 0; #5;
        clk = 1; #5;

        end
    initial
        begin
        //valid = 1;
        left = 24'b101010101010101010101010;
        right = 24'b111100001111000011110000;
        
        reset = 1;
        #20;
        reset = 0;
        #500;
 
   
        
        end

    // always @(posedge clk) begin
    //     if (i == 10) reset = 1; i = 0;
    //     i = i+1;

    // end

endmodule

