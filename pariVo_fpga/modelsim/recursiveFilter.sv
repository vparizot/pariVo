module coeffs_sync(
    input       logic [15:0] a,
    input       logic           clk,
    output  logic [15:0] y);
            
  // sbox implemented as a ROM
  // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [15:0] coeffs [0:2047];

  initial   $readmemh("filename.txt", coeffs);
    
    // Synchronous version
    always_ff @(posedge clk) begin
        y <= coeffs[a];
    end
endmodule

module get_tap(input logic clk,
                input logic [3:0] filterNum,
                input logic [7:0] tapnum,
                output logic [15:0] tapcoeff);
    
            logic [15:0] baseAddr;
            logic [15:0] currentAddr;
            logic [15:0] tempCoeff;

            assign baseAddr = (filterNum << 2); // baseAddress = size of each tap (16 bits) * number of taps (4 taps) * filter #
            assign currentAddr =  baseAddr + (tapnum); // baseAddress + currentTap#
            coeffs_sync gettap(currentAddr, clk, tempCoeff);

            assign tapcoeff = tempCoeff;
endmodule

module new_all_taps(input logic clk, reset,
                input logic [7:0] eqVal,
                output logic [15:0] tapcoeff,
                output logic [7:0] outputTapnum);
    
    logic [3:0] filterNum;
    logic [15:0] currenttapcoeff;
    logic [7:0] counter = 0;
    logic [7:0] nextCounter = 0;
    logic [7:0] tapnum;
   
    //logic [15:0] returnTaps [0:3];

    always_ff @(posedge clk)
        if(reset) begin
            counter <= 0;
        end
        else begin
            counter <= nextCounter;
        end
    

    // get filter number based on eqVals
    always_comb 
            begin
            if      (eqVal < 20)  filterNum = 4'h0;
            else                  filterNum = 4'h1; 
            if(counter < 9) nextCounter = counter + 1;
            else nextCounter = 0;
    end

    get_tap gettaps(clk, filterNum, tapnum, tapcoeff);
    assign tapnum = counter;
    assign outputTapnum = counter;
   
endmodule
