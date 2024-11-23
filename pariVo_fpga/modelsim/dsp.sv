module dsp(input logic clk, 
            input logic ce,
            input logic [2047:0] tap,
            input logic [23:0] signal,
            output logic [31:0] dsp_output);

        logic [15:0] B;
        assign B = signal & 0'hFFFF0;
        logic [15:0] A;
        assign A = tap;
        logic [6:0] state;

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


        SB_MAC16 i_sbmac16
        ( // port interfaces
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .O(dsp_output),
        .CLK(clk),
        .CE(ce),
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
            state = 0;
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
            AHOLD <= 0
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

            if(state == 0) 
            begin  
                A <= tap[state];
                B <= signal;
                D <= 0;
                OLOADBOT <= 1; //load in accumulator for bottom (lowest 16bits)
                state <= state + 1;
                //dsp_output <= O;
            end
            else if (state < 5)
            begin
                A <= tap[state];
                B <= signal
                dsp_output <= O;
                //state <= state + 1;
            end
            else 
            begin
                state <= 0;
                dsp_output <= O;
            end



        end
endmodule
