module IF_ID(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic enable_i,
    input logic [31:0] pc_i,
    input logic [31:0] instr_i,
    input logic br_sel_BTB_i,
    input logic [31:0] predicted_pc_i,
    //outputs
    output logic [31:0] pc_o,
    output logic br_sel_BTB_o,
    output logic [31:0] instr_o,
    output logic [31:0] predicted_pc_o
);
    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin          //Turn on reset => NOP instruction
            pc_o    <= 32'h0;
            instr_o <= 32'h00000013;
            br_sel_BTB_o <= 1'b0;
            predicted_pc_o <= 32'h0;
        end                         //Turn on enable
        else if (enable_i) begin
            pc_o    <= pc_i;
            instr_o <= instr_i;
            br_sel_BTB_o <= br_sel_BTB_i;
            predicted_pc_o <= predicted_pc_i;
        end
    end
endmodule : IF_ID
