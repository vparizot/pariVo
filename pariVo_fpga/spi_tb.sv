`timescale 10ns/1ns
/////////////////////////////////////////////
// spi_tb
// Tests spi communication with MCU
// Simulates full system with SPI load
/////////////////////////////////////////////

module spi_tb();
    logic clk, load, done, sck, sdi, sdo;
    logic [31:0] nonsense, eqVals, expected;
	  logic [255:0] comb;
    logic [8:0] i;

    // Added delay
    logic delay;
    
    // device under test
    eq_spi dut(sck, sdi, sdo, done, eqVals, nonsense)
    
    // test case
    initial begin   
    
    // Test case from FIPS-197 Appendix A.1, B
        eqVals       <= 32'h12345678;
        expected  <= 32'h12345678;

    end

 // Create dumpfile
 initial
   begin
     $dumpfile("spi_tb.vcd");
     $dumpvars(0, spi_tb);
   end
    
    // generate clock and load signals
		always begin
				clk = 1'b0; #5;
				clk = 1'b1; #5;
		end
        
    initial begin
      i = 0;
      load = 1'b1;
      // set delay to true
      delay = 1;
    end

    

    // shift in test vectors, wait until done, and shift out result
    always @(posedge clk) begin
      if (i == 32) load = 1'b0;
      if (i<32) begin
        #1; sdi = eqVals[31-i];
        #1; sck = 1; #5; sck = 0;
        i = i + 1;
      end else if (done && delay) begin
        #100; // Delay to make sure that the answer is held correctly on the cyphertext before shifting out
        delay = 0;
      end 
            $stop();
      
      
    end
    
endmodule


