module signalwindow (input logic clk,
                    input logic [24:0] signal,
                    output logic [63:0] signalWindow);
   
   // question: what should enable the shifting?
    logic [15:0] shortSignal;
    assign shortSignal = signal & 0'hFFFF0; 

    always_ff @(posedge clk)
     begin
        signalWindow <= {signalWindow[47:0], shortSignal};
     end // shift register operation 




endmodule 

module dsp(input logic clk, ce,
            input logic [15:0] allTaps [0:3],
            input logic [7:0] tapnum,
            input logic [15:0] signalWindow [0:3],
            output logic [31:0] dsp_output,
            output logic done);

        logic [15:0] B;
        assign B = signalWindow[3-tapnum];
        logic [15:0] A;
        assign A = allTaps[tapnum];
        //logic [6:0] state;

        logic C;
        logic D;
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
        logic O;


        SB_MAC16 i_sbmac16
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
        );
        defparam i_sbmac16.TOPOUTPUT_SELECT = 2'b01; //add/subtractor registered
        defparam i_sbmac16.BOTOUTPUT_SELECT = 2'b01; //add/subtractor registered
        defparam i_sbmac16.TOPADDSUB_LOWERINPUT = 2'b10; // top add sub upper input 
        defparam i_sbmac16.BOTADDSUB_LOWERINPUT = 2'b10; // bot add sub upper input 
        defparam i_sbmac16.PIPELINE_16x16_MULT_REG2 = 1'b1;//Mult16x16 output registered
        defparam i_sbmac16.A_SIGNED = 1'b1; // Signed coefficient
        defparam i_sbmac16.B_SIGNED = 1'b0; // Unsigned signal


        // reset when counter get to 128
        initial begin
            tapnum = 0;
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
                A <= allTaps[tapnum];
                B <= signalWindow[3-tapnum];
                D <= 0;
                OLOADBOT <= 1; //load in accumulator for bottom (lowest 16bits)
                done <= 0;
                //tapnum <= state + 1;
                dsp_output <= O;
            end
            else if (tapnum < 3)
            begin
                A <= allTaps[tapnum];
                B <= signalWindow[3-tapnum];
                done <= 0;
                dsp_output <= O;
                //state <= state + 1;
            end
            else 
            begin
                dsp_output <= O;
                done <= 1;
            end



        end
endmodule