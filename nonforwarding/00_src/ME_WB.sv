module ME_WB(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic enable_i,
    input logic rd_wren_i,
    input logic is_load_i,
    input logic mem_wren_i,
    input logic [1:0] wb_sel_i,
    input logic [31:0] pc_i,
    input logic [31:0] imm_i,
    input logic [31:0] instr_i,
    input logic [31:0] alu_data_i,
    input logic [31:0] ld_data_i,
    //outputs
    output logic rd_wren_o,
    output logic is_load_o,
    output logic mem_wren_o,
    output logic [1:0] wb_sel_o,
    output logic [31:0] pc_o,
    output logic [31:0] imm_o,
    output logic [31:0] instr_o,
    output logic [31:0] alu_data_o,
    output logic [31:0] ld_data_o
);
    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin
            rd_wren_o   <= 1'h0;
            is_load_o   <= 1'h0;
            mem_wren_o  <= 1'h0;
            wb_sel_o    <= 2'h0;
            pc_o        <= 32'h0;
            imm_o       <= 32'h0;
            instr_o     <= 32'h00000013;
            alu_data_o  <= 32'h0;
            ld_data_o   <= 32'h0;
        end
        else if (enable_i) begin
            rd_wren_o   <= rd_wren_i;
            is_load_o   <= is_load_i;
            mem_wren_o  <= mem_wren_i;
            wb_sel_o    <= wb_sel_i;
            pc_o        <= pc_i;
            imm_o       <= imm_i;
            instr_o     <= instr_i;
            alu_data_o  <= alu_data_i;
            ld_data_o   <= ld_data_i;
        end
    end  
endmodule : ME_WB
