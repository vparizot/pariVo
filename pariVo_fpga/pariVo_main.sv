
// Victoria Parizot
// vparizot@hmc.edu
// 10/31/2024
// Lab 7 AES Encryption main file
// Derived from Lab 7 started code for E155 FA2024


/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////
module top(//input  logic clk,
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
             
    logic [31:0] nonsense, eqVals;
    //logic clksig;
    HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
            
    eq_spi spi(sck, sdi, sdo, done, nonsense, eqVals);   
   
endmodule

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////
module eq_spi(input  logic sck, 
               input  logic sdi,
               output logic sdo,
               input  logic done,
               output logic [31:0] nonsense,
               input  logic [31:0] eqVals);

    logic         sdodelayed, wasdone;
    logic [31:0] eqValscaptured;
               
    // assert load
    // apply 32 sclks to shift in nonsense, starting with nonsense[31]
    // then deassert load, wait until done
    // then apply 32 sclks to shift out eqVals, starting with eqVals[31]
    // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
    // edge is a rising edge (clock going from low in the idle state to high).
    always_ff @(posedge sck)
        if (!wasdone)  {eqValscaptured, nonsense} = {eqVals, nonsense[31:0], sdi};
        else           {eqValscaptured, nonsense} = {eqValscaptured[31:0], nonsense, sdi}; 
    
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = eqValscaptured[31];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo = (done & !wasdone) ? eqVals[32] : sdodelayed;
endmodule
