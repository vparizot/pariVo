module fakeMac16(input logic clk_en_i,        
                input logic clk_i,
                input logic [15:0] data_a_i,
                input logic [15:0] data_b_i,
                input logic rst_i,
                output logic [32:0] result_o);

logic [32:0] tempResult1 = 0;
logic [32:0] tempResult2;
logic [32:0] tempResult3;
// logic [32:0] tempResult4;

always_ff @(posedge clk_i) begin
    tempResult1 <= tempResult1 + (data_a_i * data_b_i);
    tempResult2 <= tempResult1;
    result_o <= tempResult2;
    //tempResult4 <= tempResult3;
    //result_o <= tempResult3;
end
/*
always_comb begin
    tempResult1 = result_o + (data_a_i * data_b_i);
end 
*/

endmodule
