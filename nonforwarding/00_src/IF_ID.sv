module IF_ID(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic enable_i,
    input logic [31:0] pc_i,
    input logic [31:0] instr_i,
    //outputs
    output logic [31:0] pc_o,
    output logic [31:0] instr_o
);
    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin          //Turn on reset => NOP instruction
            pc_o    <= 32'h0;
            instr_o <= 32'h00000013;
        end                         //Turn on enable
        else if (enable_i) begin
            pc_o    <= pc_i;
            instr_o <= instr_i;
        end
    end
endmodule : IF_ID
