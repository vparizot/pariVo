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

            assign baseAddr = (filterNum << 2);
            assign currentAddr =  baseAddr + (tapnum);
            // assign baseAddr = (filterNum << 4) << 3; // baseAddress = size of each tap (16 bits) * number of taps (8 taps) * filter #
            // assign  currentAddr = baseAddr + (tapnum << 4); // baseAddress + currentTap# * size of tap (16 bit)
            coeffs_sync gettap(currentAddr, clk, tempCoeff);

            assign tapcoeff = tempCoeff;
endmodule

module new_all_taps(input logic clk, reset,
                input logic [7:0] eqVal,
                output logic [63:0] allTaps,
                output logic [7:0] tapnum);
    
    logic[3:0] filterNum;
    logic [15:0] tapcoeff;
    logic [7:0] counter = 0;

    logic [15:0] returnTaps [0:3];

    always_ff @(posedge clk)
        if(reset) begin
            tapnum <= 0;
            returnTaps[tapnum] <= tapcoeff;
            counter <= counter + 1;
        end
        else if (counter < 4) begin
            tapnum <= 0;
            returnTaps[tapnum] <= tapcoeff;
            counter <= counter + 1;
            end
        else begin
            tapnum <= counter;
            returnTaps[tapnum] <= tapcoeff; // h0 for state 0
            counter <= counter + 1;
        end
    

    // get filter number
    always_comb 
            if      (eqVal < 20)  filterNum = 4'h0;
            else                  filterNum = 4'h1;
    

    get_tap gettaps(clk, filterNum, tapnum, tapcoeff);

    assign allTaps = returnTaps;

endmodule

/*
module all_taps(input logic clk, reset,
                input logic [7:0] eqVal,
                output logic [2047:0] allTaps);
            
	logic [3:0] filterNum;
    logic [7:0] tapnum;
    logic [15:0] h0,  h1,  h2,  h3,  h4,  h5,  h6,  h7;
    logic [15:0] h8,  h9,  h10, h11, h12, h13, h14, h15;
    logic [15:0] h16, h17, h18, h19, h20, h21, h22, h23;
    logic [15:0] h24, h25, h26, h27, h28, h29, h30, h31;
    logic [15:0] h32, h33, h34, h35, h36, h37, h38, h39;
    logic [15:0] h40, h41, h42, h43, h44, h45, h46, h47;
    logic [15:0] h48, h49, h50, h51, h52, h53, h54, h55;
    logic [15:0] h56, h57, h58, h59, h60, h61, h62, h63;
    logic [15:0] h64, h65, h66, h67, h68, h69, h70, h71;
    logic [15:0] h72, h73, h74, h75, h76, h77, h78, h79;
    logic [15:0] h80, h81, h82, h83, h84, h85, h86, h87;
    logic [15:0] h88, h89, h90, h91, h92, h93, h94, h95;
    logic [15:0] h96, h97, h98, h99, h100, h101, h102, h103;
    logic [15:0] h104,h105,h106,h107,h108,h109,h110,h111;
    logic [15:0] h112,h113,h114,h115,h116,h117,h118,h119;
    logic [15:0] h120,h121,h122,h123,h124,h125,h126,h127;

    logic [15:0] tapcoeff;

	// define the states
	typedef enum logic [7:0] {
    S0  = 8'b00000000, 
    S1  = 8'b00000001, 
    S2  = 8'b00000010, 
    S3  = 8'b00000011, 
    S4  = 8'b00000100, 
    S5  = 8'b00000101, 
    S6  = 8'b00000110, 
    S7  = 8'b00000111, 
    S8  = 8'b00001000, 
    S9  = 8'b00001001, 
    S10 = 8'b00001010, 
    S11 = 8'b00001011, 
    S12 = 8'b00001100, 
    S13 = 8'b00001101, 
    S14 = 8'b00001110, 
    S15 = 8'b00001111, 
    S16 = 8'b00010000, 
    S17 = 8'b00010001, 
    S18 = 8'b00010010, 
    S19 = 8'b00010011, 
    S20 = 8'b00010100, 
    S21 = 8'b00010101, 
    S22 = 8'b00010110, 
    S23 = 8'b00010111, 
    S24 = 8'b00011000, 
    S25 = 8'b00011001, 
    S26 = 8'b00011010, 
    S27 = 8'b00011011, 
    S28 = 8'b00011100, 
    S29 = 8'b00011101, 
    S30 = 8'b00011110, 
    S31 = 8'b00011111, 
    S32 = 8'b00100000, 
    S33 = 8'b00100001, 
    S34 = 8'b00100010, 
    S35 = 8'b00100011, 
    S36 = 8'b00100100, 
    S37 = 8'b00100101, 
    S38 = 8'b00100110, 
    S39 = 8'b00100111, 
    S40 = 8'b00101000, 
    S41 = 8'b00101001, 
    S42 = 8'b00101010, 
    S43 = 8'b00101011, 
    S44 = 8'b00101100, 
    S45 = 8'b00101101, 
    S46 = 8'b00101110, 
    S47 = 8'b00101111, 
    S48 = 8'b00110000, 
    S49 = 8'b00110001, 
    S50 = 8'b00110010, 
    S51 = 8'b00110011, 
    S52 = 8'b00110100, 
    S53 = 8'b00110101, 
    S54 = 8'b00110110, 
    S55 = 8'b00110111, 
    S56 = 8'b00111000, 
    S57 = 8'b00111001, 
    S58 = 8'b00111010, 
    S59 = 8'b00111011, 
    S60 = 8'b00111100, 
    S61 = 8'b00111101, 
    S62 = 8'b00111110, 
    S63 = 8'b00111111, 
    S64 = 8'b01000000, 
    S65 = 8'b01000001, 
    S66 = 8'b01000010, 
    S67 = 8'b01000011, 
    S68 = 8'b01000100, 
    S69 = 8'b01000101, 
    S70 = 8'b01000110, 
    S71 = 8'b01000111, 
    S72 = 8'b01001000, 
    S73 = 8'b01001001, 
    S74 = 8'b01001010, 
    S75 = 8'b01001011, 
    S76 = 8'b01001100, 
    S77 = 8'b01001101, 
    S78 = 8'b01001110, 
    S79 = 8'b01001111, 
    S80 = 8'b01010000, 
    S81 = 8'b01010001, 
    S82 = 8'b01010010, 
    S83 = 8'b01010011, 
    S84 = 8'b01010100, 
    S85 = 8'b01010101, 
    S86 = 8'b01010110, 
    S87 = 8'b01010111, 
    S88 = 8'b01011000, 
    S89 = 8'b01011001, 
    S90 = 8'b01011010, 
    S91 = 8'b01011011, 
    S92 = 8'b01011100, 
    S93 = 8'b01011101, 
    S94 = 8'b01011110, 
    S95 = 8'b01011111, 
    S96 = 8'b01100000, 
    S97 = 8'b01100001, 
    S98 = 8'b01100010, 
    S99 = 8'b01100011, 
    S100 = 8'b01100100, 
    S101 = 8'b01100101, 
    S102 = 8'b01100110, 
    S103 = 8'b01100111, 
    S104 = 8'b01101000, 
    S105 = 8'b01101001, 
    S106 = 8'b01101010, 
    S107 = 8'b01101011, 
    S108 = 8'b01101100, 
    S109 = 8'b01101101, 
    S110 = 8'b01101110, 
    S111 = 8'b01101111, 
    S112 = 8'b01110000, 
    S113 = 8'b01110001, 
    S114 = 8'b01110010, 
    S115 = 8'b01110011, 
    S116 = 8'b01110100, 
    S117 = 8'b01110101, 
    S118 = 8'b01110110, 
    S119 = 8'b01110111, 
    S120 = 8'b01111000, 
    S121 = 8'b01111001, 
    S122 = 8'b01111010, 
    S123 = 8'b01111011, 
    S124 = 8'b01111100, 
    S125 = 8'b01111101, 
    S126 = 8'b01111110, 
    S127 = 8'b01111111  // S127
} statetype;

	statetype state, nextstate;

	// state register
	always_ff @(posedge clk, posedge reset)
		if (reset) state <= S0;
		else state <= nextstate;

	// Next state logic
	always_comb
		case (state)
			S0: nextstate = S1;
            S1: nextstate = S2;
            S2: nextstate = S3;	
            S3: nextstate = S4;
            S4: nextstate = S5;
            S5: nextstate = S6;	
            S6: nextstate = S7;
            S7: nextstate = S8;
            S8: nextstate = S9;
            S9: nextstate = S10;
            S10: nextstate = S11;
            S11: nextstate = S12;
            S12: nextstate = S13;
            S13: nextstate = S14;
            S14: nextstate = S15;
            S15: nextstate = S16;
            S16: nextstate = S17;
            S17: nextstate = S18;
            S18: nextstate = S19;
            S19: nextstate = S20;
            S20: nextstate = S21;
            S21: nextstate = S22;
            S22: nextstate = S23;
            S23: nextstate = S24;
            S24: nextstate = S25;
            S25: nextstate = S26;
            S26: nextstate = S27;
            S27: nextstate = S28;
            S28: nextstate = S29;
            S29: nextstate = S30;
            S30: nextstate = S31;
            S31: nextstate = S32;
            S32: nextstate = S33;
            S33: nextstate = S34;
            S34: nextstate = S35;
            S35: nextstate = S36;
            S36: nextstate = S37;
            S37: nextstate = S38;
            S38: nextstate = S39;
            S39: nextstate = S40;
            S40: nextstate = S41;
            S41: nextstate = S42;
            S42: nextstate = S43;
            S43: nextstate = S44;
            S44: nextstate = S45;
            S45: nextstate = S46;
            S46: nextstate = S47;
            S47: nextstate = S48;
            S48: nextstate = S49;
            S49: nextstate = S50;
            S50: nextstate = S51;
            S51: nextstate = S52;
            S52: nextstate = S53;
            S53: nextstate = S54;
            S54: nextstate = S55;
            S55: nextstate = S56;
            S56: nextstate = S57;
            S57: nextstate = S58;
            S58: nextstate = S59;
            S59: nextstate = S60;
            S60: nextstate = S61;
            S61: nextstate = S62;
            S62: nextstate = S63;
            S63: nextstate = S64;
            S64: nextstate = S65;
            S65: nextstate = S66;
            S66: nextstate = S67;
            S67: nextstate = S68;
            S68: nextstate = S69;
            S69: nextstate = S70;
            S70: nextstate = S71;
            S71: nextstate = S72;
            S72: nextstate = S73;
            S73: nextstate = S74;
            S74: nextstate = S75;
            S75: nextstate = S76;
            S76: nextstate = S77;
            S77: nextstate = S78;
            S78: nextstate = S79;
            S79: nextstate = S80;
            S80: nextstate = S81;
            S81: nextstate = S82;
            S82: nextstate = S83;
            S83: nextstate = S84;
            S84: nextstate = S85;
            S85: nextstate = S86;
            S86: nextstate = S87;
            S87: nextstate = S88;
            S88: nextstate = S89;
            S89: nextstate = S90;
            S90: nextstate = S91;
            S91: nextstate = S92;
            S92: nextstate = S93;
            S93: nextstate = S94;
            S94: nextstate = S95;
            S95: nextstate = S96;
            S96: nextstate = S97;
            S97: nextstate = S98;
            S98: nextstate = S99;
            S99: nextstate = S100;
            S100: nextstate = S101;
            S101: nextstate = S102;
            S102: nextstate = S103;
            S103: nextstate = S104;
            S104: nextstate = S105;
            S105: nextstate = S106;
            S106: nextstate = S107;
            S107: nextstate = S108;
            S108: nextstate = S109;
            S109: nextstate = S110;
            S110: nextstate = S111;
            S111: nextstate = S112;
            S112: nextstate = S113;
            S113: nextstate = S114;
            S114: nextstate = S115;
            S115: nextstate = S116;
            S116: nextstate = S117;
            S117: nextstate = S118;
            S118: nextstate = S119;
            S119: nextstate = S120;
            S120: nextstate = S121;
            S121: nextstate = S122;
            S122: nextstate = S123;
            S123: nextstate = S124;
            S124: nextstate = S125;
            S125: nextstate = S126;
            S126: nextstate = S127;
            S127: nextstate = S0;
			default: nextstate = S0;
		endcase

    // get tap number
    always_ff @(posedge clk)
	    case (state)
        S0: begin 
            tapnum <= 8'b00000000;
            h126 <= tapcoeff; // h0 for state 0
        end
        S1: begin 
            tapnum <= 8'b00000001;
            h127 <= tapcoeff; // h1 for state 1
        end
        S2: begin 
            tapnum <= 8'b00000010;
            h0 <= tapcoeff; // h0 for state 2
        end
        S3: begin 
            tapnum <= 8'b00000011;
            h1 <= tapcoeff; // h1 for state 3
        end
        S4: begin 
            tapnum <= 8'b00000100;
            h2 <= tapcoeff; // h2 for state 4
        end
        S5: begin 
            tapnum <= 8'b00000101;
            h3 <= tapcoeff; // h3 for state 5
        end
        S6: begin 
            tapnum <= 8'b00000110;
            h4 <= tapcoeff; // h4 for state 6
        end
        S7: begin 
            tapnum <= 8'b00000111;
            h5 <= tapcoeff; // h5 for state 7
        end
        S8: begin 
            tapnum <= 8'b00001000;
            h6 <= tapcoeff; // h6 for state 8
        end
        S9: begin 
            tapnum <= 8'b00001001;
            h7 <= tapcoeff; // h7 for state 9
        end
        S10: begin 
            tapnum <= 8'b00001010;
            h8 <= tapcoeff; // h8 for state 10
        end
        S11: begin 
            tapnum <= 8'b00001011;
            h9 <= tapcoeff; // h9 for state 11
        end
        S12: begin 
            tapnum <= 8'b00001100;
            h10 <= tapcoeff; // h10 for state 12
        end
        S13: begin 
            tapnum <= 8'b00001101;
            h11 <= tapcoeff; // h11 for state 13
        end
        S14: begin 
            tapnum <= 8'b00001110;
            h12 <= tapcoeff; // h12 for state 14
        end
        S15: begin 
            tapnum <= 8'b00001111;
            h13 <= tapcoeff; // h13 for state 15
        end
        S16: begin 
            tapnum <= 8'b00010000;
            h14 <= tapcoeff; // h14 for state 16
        end
        S17: begin 
            tapnum <= 8'b00010001;
            h15 <= tapcoeff; // h15 for state 17
        end
        S18: begin 
            tapnum <= 8'b00010010;
            h16 <= tapcoeff; // h16 for state 18
        end
        S19: begin 
            tapnum <= 8'b00010011;
            h17 <= tapcoeff; // h17 for state 19
        end
        S20: begin 
            tapnum <= 8'b00010100;
            h18 <= tapcoeff; // h18 for state 20
        end
        S21: begin 
            tapnum <= 8'b00010101;
            h19 <= tapcoeff; // h19 for state 21
        end
        S22: begin 
            tapnum <= 8'b00010110;
            h20 <= tapcoeff; // h20 for state 22
        end
        S23: begin 
            tapnum <= 8'b00010111;
            h21 <= tapcoeff; // h21 for state 23
        end
        S24: begin 
            tapnum <= 8'b00011000;
            h22 <= tapcoeff; // h22 for state 24
        end
        S25: begin 
            tapnum <= 8'b00011001;
            h23 <= tapcoeff; // h23 for state 25
        end
        S26: begin 
            tapnum <= 8'b00011010;
            h24 <= tapcoeff; // h24 for state 26
        end
        S27: begin 
            tapnum <= 8'b00011011;
            h25 <= tapcoeff; // h25 for state 27
        end
        S28: begin 
            tapnum <= 8'b00011100;
            h26 <= tapcoeff; // h26 for state 28
        end
        S29: begin 
            tapnum <= 8'b00011101;
            h27 <= tapcoeff; // h27 for state 29
        end
        S30: begin 
            tapnum <= 8'b00011110;
            h28 <= tapcoeff; // h28 for state 30
        end
        S31: begin 
            tapnum <= 8'b00011111;
            h29 <= tapcoeff; // h29 for state 31
        end
        S32: begin 
            tapnum <= 8'b00100000;
            h30 <= tapcoeff; // h30 for state 32
        end
        S33: begin 
            tapnum <= 8'b00100001;
            h31 <= tapcoeff; // h31 for state 33
        end
        S34: begin 
            tapnum <= 8'b00100010;
            h32 <= tapcoeff; // h32 for state 34
        end
        S35: begin 
            tapnum <= 8'b00100011;
            h33 <= tapcoeff; // h33 for state 35
        end
        S36: begin 
            tapnum <= 8'b00100100;
            h34 <= tapcoeff; // h34 for state 36
        end
        S37: begin 
            tapnum <= 8'b00100101;
            h35 <= tapcoeff; // h35 for state 37
        end
        S38: begin 
            tapnum <= 8'b00100110;
            h36 <= tapcoeff; // h36 for state 38
        end
        S39: begin 
            tapnum <= 8'b00100111;
            h37 <= tapcoeff; // h37 for state 39
        end
        S40: begin 
            tapnum <= 8'b00101000;
            h38 <= tapcoeff; // h38 for state 40
        end
        S41: begin 
            tapnum <= 8'b00101001;
            h39 <= tapcoeff; // h39 for state 41
        end
        S42: begin 
            tapnum <= 8'b00101010;
            h40 <= tapcoeff; // h40 for state 42
        end
        S43: begin 
            tapnum <= 8'b00101011;
            h41 <= tapcoeff; // h41 for state 43
        end
        S44: begin 
            tapnum <= 8'b00101100;
            h42 <= tapcoeff; // h42 for state 44
        end
        S45: begin 
            tapnum <= 8'b00101101;
            h43 <= tapcoeff; // h43 for state 45
        end
        S46: begin 
            tapnum <= 8'b00101110;
            h44 <= tapcoeff; // h44 for state 46
        end
        S47: begin 
            tapnum <= 8'b00101111;
            h45 <= tapcoeff; // h45 for state 47
        end
        S48: begin 
            tapnum <= 8'b00110000;
            h46 <= tapcoeff; // h46 for state 48
        end
        S49: begin 
            tapnum <= 8'b00110001;
            h47 <= tapcoeff; // h47 for state 49
        end
        S50: begin 
            tapnum <= 8'b00110010;
            h48 <= tapcoeff; // h48 for state 50
        end
        S51: begin 
            tapnum <= 8'b00110011;
            h49 <= tapcoeff; // h49 for state 51
        end
        S52: begin 
            tapnum <= 8'b00110100;
            h50 <= tapcoeff; // h50 for state 52
        end
        S53: begin 
            tapnum <= 8'b00110101;
            h51 <= tapcoeff; // h51 for state 53
        end
        S54: begin 
            tapnum <= 8'b00110110;
            h52 <= tapcoeff; // h52 for state 54
        end
        S55: begin 
            tapnum <= 8'b00110111;
            h53 <= tapcoeff; // h53 for state 55
        end
        S56: begin 
            tapnum <= 8'b00111000;
            h54 <= tapcoeff; // h54 for state 56
        end
        S57: begin 
            tapnum <= 8'b00111001;
            h55 <= tapcoeff; // h55 for state 57
        end
        S58: begin 
            tapnum <= 8'b00111010;
            h56 <= tapcoeff; // h56 for state 58
        end
        S59: begin 
            tapnum <= 8'b00111011;
            h57 <= tapcoeff; // h57 for state 59
        end
        S60: begin 
            tapnum <= 8'b00111100;
            h58 <= tapcoeff; // h58 for state 60
        end
        S61: begin 
            tapnum <= 8'b00111101;
            h59 <= tapcoeff; // h59 for state 61
        end
        S62: begin 
            tapnum <= 8'b00111110;
            h60 <= tapcoeff; // h60 for state 62
        end
        S63: begin 
            tapnum <= 8'b00111111;
            h61 <= tapcoeff; // h61 for state 63
        end
        S64: begin 
            tapnum <= 8'b01000000;
            h62 <= tapcoeff; // h62 for state 64
        end
        S65: begin 
            tapnum <= 8'b01000001;
            h63 <= tapcoeff; // h63 for state 65
        end
        S66: begin 
            tapnum <= 8'b01000010;
            h64 <= tapcoeff; // h64 for state 66
        end
        S67: begin 
            tapnum <= 8'b01000011;
            h65 <= tapcoeff; // h65 for state 67
        end
        S68: begin 
            tapnum <= 8'b01000100;
            h66 <= tapcoeff; // h66 for state 68
        end
        S69: begin 
            tapnum <= 8'b01000101;
            h67 <= tapcoeff; // h67 for state 69
        end
        S70: begin 
            tapnum <= 8'b01000110;
            h68 <= tapcoeff; // h68 for state 70
        end
        S71: begin 
            tapnum <= 8'b01000111;
            h69 <= tapcoeff; // h69 for state 71
        end
        S72: begin 
            tapnum <= 8'b01001000;
            h70 <= tapcoeff; // h70 for state 72
        end
        S73: begin 
            tapnum <= 8'b01001001;
            h71 <= tapcoeff; // h71 for state 73
        end
        S74: begin 
            tapnum <= 8'b01001010;
            h72 <= tapcoeff; // h72 for state 74
        end
        S75: begin 
            tapnum <= 8'b01001011;
            h73 <= tapcoeff; // h73 for state 75
        end
        S76: begin 
            tapnum <= 8'b01001100;
            h74 <= tapcoeff; // h74 for state 76
        end
        S77: begin 
            tapnum <= 8'b01001101;
            h75 <= tapcoeff; // h75 for state 77
        end
        S78: begin 
            tapnum <= 8'b01001110;
            h76 <= tapcoeff; // h76 for state 78
        end
        S79: begin 
            tapnum <= 8'b01001111;
            h77 <= tapcoeff; // h77 for state 79
        end
        S80: begin 
            tapnum <= 8'b01010000;
            h78 <= tapcoeff; // h78 for state 80
        end
        S81: begin 
            tapnum <= 8'b01010001;
            h79 <= tapcoeff; // h79 for state 81
        end
        S82: begin 
            tapnum <= 8'b01010010;
            h80 <= tapcoeff; // h80 for state 82
        end
        S83: begin 
            tapnum <= 8'b01010011;
            h81 <= tapcoeff; // h81 for state 83
        end
        S84: begin 
            tapnum <= 8'b01010100;
            h82 <= tapcoeff; // h82 for state 84
        end
        S85: begin 
            tapnum <= 8'b01010101;
            h83 <= tapcoeff; // h83 for state 85
        end
        S86: begin 
            tapnum <= 8'b01010110;
            h84 <= tapcoeff; // h84 for state 86
        end
        S87: begin 
            tapnum <= 8'b01010111;
            h85 <= tapcoeff; // h85 for state 87
        end
        S88: begin 
            tapnum <= 8'b01011000;
            h86 <= tapcoeff; // h86 for state 88
        end
        S89: begin 
            tapnum <= 8'b01011001;
            h87 <= tapcoeff; // h87 for state 89
        end
        S90: begin 
            tapnum <= 8'b01011010;
            h88 <= tapcoeff; // h88 for state 90
        end
        S91: begin 
            tapnum <= 8'b01011011;
            h89 <= tapcoeff; // h89 for state 91
        end
        S92: begin 
            tapnum <= 8'b01011100;
            h90 <= tapcoeff; // h90 for state 92
        end
        S93: begin 
            tapnum <= 8'b01011101;
            h91 <= tapcoeff; // h91 for state 93
        end
        S94: begin 
            tapnum <= 8'b01011110;
            h92 <= tapcoeff; // h92 for state 94
        end
        S95: begin 
            tapnum <= 8'b01011111;
            h93 <= tapcoeff; // h93 for state 95
        end
        S96: begin 
            tapnum <= 8'b01100000;
            h94 <= tapcoeff; // h94 for state 96
        end
        S97: begin 
            tapnum <= 8'b01100001;
            h95 <= tapcoeff; // h95 for state 97
        end
        S98: begin 
            tapnum <= 8'b01100010;
            h96 <= tapcoeff; // h96 for state 98
        end
        S99: begin 
            tapnum <= 8'b01100011;
            h97 <= tapcoeff; // h97 for state 99
        end
        S100: begin 
            tapnum <= 8'b01100100;
            h98 <= tapcoeff; // h98 for state 100
        end
        S101: begin 
            tapnum <= 8'b01100101;
            h99 <= tapcoeff; // h99 for state 101
        end
        S102: begin 
            tapnum <= 8'b01100110;
            h100 <= tapcoeff; // h100 for state 102
        end
        S103: begin 
            tapnum <= 8'b01100111;
            h101 <= tapcoeff; // h101 for state 103
        end
        S104: begin 
            tapnum <= 8'b01101000;
            h102 <= tapcoeff; // h102 for state 104
        end
        S105: begin 
            tapnum <= 8'b01101001;
            h103 <= tapcoeff; // h103 for state 105
        end
        S106: begin 
            tapnum <= 8'b01101010;
            h104 <= tapcoeff; // h104 for state 106
        end
        S107: begin 
            tapnum <= 8'b01101011;
            h105 <= tapcoeff; // h105 for state 107
        end
        S108: begin 
            tapnum <= 8'b01101100;
            h106 <= tapcoeff; // h106 for state 108
        end
        S109: begin 
            tapnum <= 8'b01101101;
            h107 <= tapcoeff; // h107 for state 109
        end
        S110: begin 
            tapnum <= 8'b01101110;
            h108 <= tapcoeff; // h108 for state 110
        end
        S111: begin 
            tapnum <= 8'b01101111;
            h109 <= tapcoeff; // h109 for state 111
        end
        S112: begin 
            tapnum <= 8'b01110000;
            h110 <= tapcoeff; // h110 for state 112
        end
        S113: begin 
            tapnum <= 8'b01110001;
            h111 <= tapcoeff; // h111 for state 113
        end
        S114: begin 
            tapnum <= 8'b01110010;
            h112 <= tapcoeff; // h112 for state 114
        end
        S115: begin 
            tapnum <= 8'b01110011;
            h113 <= tapcoeff; // h113 for state 115
        end
        S116: begin 
            tapnum <= 8'b01110100;
            h114 <= tapcoeff; // h114 for state 116
        end
        S117: begin 
            tapnum <= 8'b01110101;
            h115 <= tapcoeff; // h115 for state 117
        end
        S118: begin 
            tapnum <= 8'b01110110;
            h116 <= tapcoeff; // h116 for state 118
        end
        S119: begin 
            tapnum <= 8'b01110111;
            h117 <= tapcoeff; // h117 for state 119
        end
        S120: begin 
            tapnum <= 8'b01111000;
            h118 <= tapcoeff; // h118 for state 120
        end
        S121: begin 
            tapnum <= 8'b01111001;
            h119 <= tapcoeff; // h119 for state 121
        end
        S122: begin 
            tapnum <= 8'b01111010;
            h120 <= tapcoeff; // h120 for state 122
        end
        S123: begin 
            tapnum <= 8'b01111011;
            h121 <= tapcoeff; // h121 for state 123
        end
        S124: begin 
            tapnum <= 8'b01111100;
            h122 <= tapcoeff; // h122 for state 124
        end
        S125: begin 
            tapnum <= 8'b01111101;
            h123 <= tapcoeff; // h123 for state 125
        end
        S126: begin 
            tapnum <= 8'b01111110;
            h124 <= tapcoeff; // h124 for state 126
        end
        S127: begin 
            tapnum <= 8'b01111111;
            h125 <= tapcoeff; // h125 for state 127
        end


		endcase

    // get filter number
    always_comb 
			if      (eqVal < 16) filterNum = 4'h0;
            else if (eqVal < 32) filterNum = 4'h1;
            else if (eqVal < 48) filterNum = 4'h2;
            else if (eqVal < 64) filterNum = 4'h3;
            else if (eqVal < 80) filterNum = 4'h4;
            else if (eqVal < 96) filterNum = 4'h5;
            else if (eqVal < 112) filterNum = 4'h6;
            else if (eqVal < 128) filterNum = 4'h7;
            else if (eqVal < 144) filterNum = 4'h8;
            else if (eqVal < 160) filterNum = 4'h9;
            else if (eqVal < 176) filterNum = 4'ha;
            else if (eqVal < 192) filterNum = 4'hb;
            else if (eqVal < 208) filterNum = 4'hc;
            else if (eqVal < 224) filterNum = 4'hd;
            else if (eqVal < 240) filterNum = 4'he;
            else                  filterNum = 4'hf;
	

	get_tap gettaps(clk, filterNum, tapnum, tapcoeff);

    assign allTaps = {h0,  h1,  h2,  h3,  h4,  h5,  h6,  h7,
                  h8,  h9,  h10, h11, h12, h13, h14, h15,
                  h16, h17, h18, h19, h20, h21, h22, h23,
                  h24, h25, h26, h27, h28, h29, h30, h31,
                  h32, h33, h34, h35, h36, h37, h38, h39,
                  h40, h41, h42, h43, h44, h45, h46, h47,
                  h48, h49, h50, h51, h52, h53, h54, h55,
                  h56, h57, h58, h59, h60, h61, h62, h63,
                  h64, h65, h66, h67, h68, h69, h70, h71,
                  h72, h73, h74, h75, h76, h77, h78, h79,
                  h80, h81, h82, h83, h84, h85, h86, h87,
                  h88, h89, h90, h91, h92, h93, h94, h95,
                  h96, h97, h98, h99, h100,h101,h102,h103,
                  h104,h105,h106,h107,h108,h109,h110,h111,
                  h112,h113,h114,h115,h116,h117,h118,h119,
                  h120,h121,h122,h123,h124,h125,h126,h127};
endmodule
/*
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
    logic [23:0] coeff[3:0] =  {24'd500, 24'd1000, 24'd1000, 24'd500};  // Coefficients for a 5-tap FIR filter
    logic [23:0] shiftReg[3:0]; // Shift registers to hold prev values WILL THIS UPDATE FOR EACH TIME THIS FUNC IS CALLED
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

*/