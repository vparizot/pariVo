
module signalwindow (input logic clk, en,
                    input logic [23:0] signal,
                    output logic [15:0] signalWindow [0:3]);
   
   // question: what should enable the shifting?
   // ans: enable from the adc when it gets a new signal
    logic [15:0] shortSignal;
    assign shortSignal = signal[23:8]; 
    logic [15:0] tempsignalWindow [0:3];


    always_ff @(posedge clk)
     begin
        if(en) begin
            signalWindow[3] <= signalWindow[2];
            signalWindow[2] <= signalWindow[1];
            signalWindow[1] <= signalWindow[0];
            signalWindow[0] <= shortSignal;
        end
     end // shift register operation 




endmodule 


module fakedsp(input logic clk, ce,
            input logic [15:0] tap,
            input logic [7:0] tapnum,
            input logic [15:0] signalWindow [0:3],
            output logic [32:0] result_o,
            output logic done);

    logic [15:0] A;
    logic [15:0] B;
    logic [32:0] prevValue = 0;
    

    //always_ff @(posedge clk) begin  
       assign A = tap;
       assign B = signalWindow[3-tapnum];
    //end

    always_comb begin
        if(tapnum < 3) done = 0;
        else done = 1;
    end

    logic en;
    logic reset;
    fakeMac16 fakemac(en, clk, A, B, reset, result_o);
        
endmodule 

module faketop(input logic clk, reset,
                input logic signal_en,
                input logic [23:0] signal,
                input logic [7:0] eqVal,
                output logic [32:0] result_o,
                output logic done);

logic [15:0] tapcoeff;
logic [7:0] tapnum;
logic [15:0] signalWindow [0:3];

logic ce;


assign en = 1;

logic tap;

new_all_taps getalltaps(clk, reset, eqVal, tapcoeff, tapnum);

signalwindow getsignal(clk, signal_en, signal, signalWindow);

fakedsp dspoutput(clk, ce, tapcoeff, tapnum, signalWindow, result_o, done);

endmodule


module dsp(input logic clk, ce,
            input logic [15:0] tap,
            input logic [7:0] tapnum,
            input logic [15:0] signalWindow [0:3],
            output logic [31:0] dsp_output,
            output logic done);

        
        //assign B = signalWindow[3-tapnum];
        
        //assign A = tap;
        //logic [6:0] state;
        
        
        logic [15:0] A;
        logic [15:0] B;
        logic [15:0] C;
        logic [15:0] D; 
        logic [31:0] O; 


        logic C15;
        logic C14;
        logic C13;
        logic C12;
        logic C11;
        logic C10;
        logic C9;
        logic C8;
        logic C7;
        logic C6;
        logic C5;
        logic C4;
        logic C3;
        logic C2;
        logic C1;
        logic C0;

        logic A15;
        logic A14;
        logic A13;
        logic A12;
        logic A11;
        logic A10;
        logic A9;
        logic A8;
        logic A7;
        logic A6;
        logic A5;
        logic A4;
        logic A3;
        logic A2;
        logic A1;
        logic A0;

        logic B15;
        logic B14;
        logic B13;
        logic B12;
        logic B11;
        logic B10;
        logic B9;
        logic B8;
        logic B7;
        logic B6;
        logic B5;
        logic B4;
        logic B3;
        logic B2;
        logic B1;
        logic B0;

        logic D15;
        logic D14;
        logic D13;
        logic D12;
        logic D11;
        logic D10;
        logic D9;
        logic D8;
        logic D7;
        logic D6;
        logic D5;
        logic D4;
        logic D3;
        logic D2;
        logic D1;
        logic D0;

        logic IRSTTOP;
        logic IRSTBOT;
        logic ORSTTOP;
        logic ORSTBOT;
        logic AHOLD;
        logic BHOLD;
        logic CHOLD;
        logic DHOLD;
        logic OHOLDTOP;
        logic OHOLDBOT;
        logic OLOADTOP;
        logic OLOADBOT;
        logic ADDSUBTOP;
        logic ADDSUBBOT;
        logic CO;
        logic CI;
        logic CE;

        logic O31;
        logic O30;
        logic O29;
        logic O28;
        logic O27;
        logic O26;
        logic O25;
        logic O24;
        logic O23;
        logic O22;
        logic O21;
        logic O20;
        logic O19;
        logic O18;
        logic O17;
        logic O16;
        logic O15;
        logic O14;
        logic O13;
        logic O12;
        logic O11;
        logic O10;
        logic O9;
        logic O8;
        logic O7;
        logic O6;
        logic O5;
        logic O4;
        logic O3;
        logic O2;
        logic O1;
        logic O0;

    MAC16 i_sbmac16
     (   // Port Interfaces
    .CLK(clk),
    .CE(ce),
    .C15(C15),
    .C14(C14),
    .C13(C13),
    .C12(C12),
    .C11(C11),
    .C10(C10),
    .C9(C9),
    .C8(C8),
    .C7(C7),
    .C6(C6),
    .C5(C5),
    .C4(C4),
    .C3(C3),
    .C2(C2),
    .C1(C1),
    .C0(C0),
    .A15(A15),
    .A14(A14),
    .A13(A13),
    .A12(A12),
    .A11(A11),
    .A10(A10),
    .A9(A9),
    .A8(A8),
    .A7(A7),
    .A6(A6),
    .A5(A5),
    .A4(A4),
    .A3(A3),
    .A2(A2),
    .A1(A1),
    .A0(A0),
    .B15(B15),
    .B14(B14),
    .B13(B13),
    .B12(B12),
    .B11(B11),
    .B10(B10),
    .B9(B9),
    .B8(B8),
    .B7(B7),
    .B6(B6),
    .B5(B5),
    .B4(B4),
    .B3(B3),
    .B2(B2),
    .B1(B1),
    .B0(B0),
    .D15(D15),
    .D14(D14),
    .D13(D13),
    .D12(D12),
    .D11(D11),
    .D10(D10),
    .D9(D9),
    .D8(D8),
    .D7(D7),
    .D6(D6),
    .D5(D5),
    .D4(D4),
    .D3(D3),
    .D2(D2),
    .D1(D1),
    .D0(D0),
    .AHOLD(AHOLD),
    .BHOLD(BHOLD),
    .CHOLD(CHOLD),
    .DHOLD(DHOLD),
    .IRSTTOP(IRSTTOP),
    .IRSTBOT(IRSTBOT),
    .ORSTTOP(ORSTTOP),
    .ORSTBOT(ORSTBOT),
    .OLOADTOP(OLOADTOP),
    .OLOADBOT(OLOADBOT),
    .ADDSUBTOP(ADDSUBTOP),
    .ADDSUBBOT(ADDSUBBOT),
    .OHOLDTOP(OHOLDTOP),
    .OHOLDBOT(OHOLDBOT),
    .CI(CI),
    .CO(CO),
    .ACCUMCI(ACCUMCI),
    .ACCUMCO(ACCUMCO),
    .SIGNEXTIN(SIGNEXTIN),
    .O31(O31),
    .O30(O30),
    .O29(O29),
    .O28(O28),
    .O27(O27),
    .O26(O26),
    .O25(O25),
    .O24(O24),
    .O23(O23),
    .O22(O22),
    .O21(O21),
    .O20(O20),
    .O19(O19),
    .O18(O18),
    .O17(O17),
    .O16(O16),
    .O15(O15),
    .O14(O14),
    .O13(O13),
    .O12(O12),
    .O11(O11),
    .O10(O10),
    .O9(O9),
    .O8(O8),
    .O7(O7),
    .O6(O6),
    .O5(O5),
    .O4(O4),
    .O3(O3),
    .O2(O2),
    .O1(O1),
    .O0(O0),
    .SIGNEXTOUT(SIGNEXTOUT)
    ); // Ensure this last line is correctly defined.


        /*SB_MAC16 i_sbmac16
        ( // port interfaces
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .O(O),
        .CLK(clk),
        .CE(CE),
        .IRSTTOP(IRSTTOP),
        .IRSTBOT(IRSTBOT),
        .ORSTTOP(ORSTTOP),
        .ORSTBOT(ORSTBOT),
        .AHOLD(AHOLD),
        .BHOLD(BHOLD),
        .CHOLD(CHOLD),
        .DHOLD(DHOLD),
        .OHOLDTOP(OHOLDTOP),
        .OHOLDBOT(OHOLDBOT),
        .OLOADTOP(OLOADTOP),
        .OLOADBOT(OLOADBOT),
        .ADDSUBTOP(ADDSUBTOP),
        .ADDSUBBOT(ADDSUBBOT),
        .CO(CO),
        .CI(CI),
        .ACCUMCI(),
        .ACCUMCO(),
        .SIGNEXTIN(),
        .SIGNEXTOUT()
        ); */
        defparam i_sbmac16.TOPOUTPUT_SELECT = 2'b01; //add/subtractor registered
        defparam i_sbmac16.BOTOUTPUT_SELECT = 2'b01; //add/subtractor registered
        defparam i_sbmac16.TOPADDSUB_LOWERINPUT = 2'b10; // top add sub upper input 
        defparam i_sbmac16.BOTADDSUB_LOWERINPUT = 2'b10; // bot add sub upper input 
        defparam i_sbmac16.PIPELINE_16x16_MULT_REG2 = 1'b1;//Mult16x16 output registered
        defparam i_sbmac16.A_SIGNED = 1'b1; // Signed coefficient
        defparam i_sbmac16.B_SIGNED = 1'b0; // Unsigned signal


        // reset when counter get to 128
        initial begin
            O = 0;
            CE = 1;
        end

        always @(posedge clk)
        begin
            //default for the dsp
            C <= 0;
            D <= 0;
            IRSTTOP <= 0;
            IRSTBOT <= 0;
            ORSTTOP <= 0;
            ORSTBOT <= 0;
            AHOLD <= 0;
            BHOLD <= 0;
            CHOLD <= 0;
            DHOLD <= 0;
            OHOLDTOP <= 0;
            OHOLDBOT <= 0;
            OLOADTOP <= 0;
            OLOADBOT <= 0;
            ADDSUBTOP <= 0;
            ADDSUBBOT <= 0;
            CO <= 0;
            CI <= 0;

            if(tapnum == 0) 
            begin  

               
                A0 <= tap[0];
                A1 <= tap[1];
                A2 <= tap[2];
                A3 <= tap[3];
                A4 <= tap[4];
                A5 <= tap[5];
                A6 <= tap[6];
                A7 <= tap[7];
                A8 <= tap[8];
                A9 <= tap[9];
                A10 <= tap[10];
                A11 <= tap[11];
                A12 <= tap[12];
                A13 <= tap[13];
                A14 <= tap[14];
                A15 <= tap[15];
                B0 <= signalWindow[3-tapnum][0];
                B1 <= signalWindow[3-tapnum][1];
                B2 <= signalWindow[3-tapnum][2];
                B3 <= signalWindow[3-tapnum][3];
                B4 <= signalWindow[3-tapnum][4];
                B5 <= signalWindow[3-tapnum][5];
                B6 <= signalWindow[3-tapnum][6];
                B7 <= signalWindow[3-tapnum][7];
                B8 <= signalWindow[3-tapnum][8];
                B9 <= signalWindow[3-tapnum][9];
                B10 <= signalWindow[3-tapnum][10];
                B11 <= signalWindow[3-tapnum][11];
                B12 <= signalWindow[3-tapnum][12];
                B13 <= signalWindow[3-tapnum][13];
                B14 <= signalWindow[3-tapnum][14];
                B15 <= signalWindow[3-tapnum][15];

                D0 <= 0;
                D1 <= 0;
                D2 <= 0;
                D3 <= 0;
                D4 <= 0;
                D5 <= 0;
                D6 <= 0;
                D7 <= 0;
                D8 <= 0;
                D9 <= 0;
                D10 <= 0;
                D11 <= 0;
                D12 <= 0;
                D13 <= 0;
                D14 <= 0;
                D15 <= 0;

                OLOADBOT <= 1; //load in accumulator for bottom (lowest 16bits)
                done <= 0;
                //tapnum <= state + 1;
                 dsp_output <= {O31, O30, O29, O28, O27, O26, O25, O24,
                   O23, O22, O21, O20, O19, O18, O17, O16,
                   O15, O14, O13, O12, O11, O10, O9, O8,
                   O7, O6, O5, O4, O3, O2, O1, O0};
            end
            else if (tapnum < 3)
            begin
                A[0] <= tap[0];
                A[1] <= tap[1];
                A[2] <= tap[2];
                A[3] <= tap[3];
                A[4] <= tap[4];
                A[5] <= tap[5];
                A[6] <= tap[6];
                A[7] <= tap[7];
                A[8] <= tap[8];
                A[9] <= tap[9];
                A[10] <= tap[10];
                A[11] <= tap[11];
                A[12] <= tap[12];
                A[13] <= tap[13];
                A[14] <= tap[14];
                A[15] <= tap[15];

                B0 <= signalWindow[3-tapnum][0];
                B1 <= signalWindow[3-tapnum][1];
                B2 <= signalWindow[3-tapnum][2];
                B3 <= signalWindow[3-tapnum][3];
                B4 <= signalWindow[3-tapnum][4];
                B5 <= signalWindow[3-tapnum][5];
                B6 <= signalWindow[3-tapnum][6];
                B7 <= signalWindow[3-tapnum][7];
                B8 <= signalWindow[3-tapnum][8];
                B9 <= signalWindow[3-tapnum][9];
                B10 <= signalWindow[3-tapnum][10];
                B11 <= signalWindow[3-tapnum][11];
                B12 <= signalWindow[3-tapnum][12];
                B13 <= signalWindow[3-tapnum][13];
                B14 <= signalWindow[3-tapnum][14];
                B15 <= signalWindow[3-tapnum][15];
                done <= 0;
                 dsp_output <= {O31, O30, O29, O28, O27, O26, O25, O24,
                   O23, O22, O21, O20, O19, O18, O17, O16,
                   O15, O14, O13, O12, O11, O10, O9, O8,
                   O7, O6, O5, O4, O3, O2, O1, O0};
                //state <= state + 1;
            end
            else 
            begin
                dsp_output <= {O31, O30, O29, O28, O27, O26, O25, O24,
                   O23, O22, O21, O20, O19, O18, O17, O16,
                   O15, O14, O13, O12, O11, O10, O9, O8,
                   O7, O6, O5, O4, O3, O2, O1, O0};
                done <= 1;
            end

        

        end
endmodule

