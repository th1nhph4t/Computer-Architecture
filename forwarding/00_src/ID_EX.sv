module ID_EX(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic enable_i,
    input logic is_rs2_i,
    input logic rd_wren_i,
    input logic is_load_i,
    input logic mem_wren_i,
    input logic op_sel_a_i,
    input logic op_sel_b_i,
    input logic br_unsigned_i,
    input logic [1:0] wb_sel_i,
    input logic [2:0] mem_op_i,
    input logic [3:0] alu_op_i,
    input logic [31:0] pc_i,
    input logic [31:0] instr_i,
    input logic [31:0] rs1_data_i,
    input logic [31:0] rs2_data_i,
    //outputs
    output logic is_rs2_o,
    output logic rd_wren_o,
    output logic is_load_o,
    output logic mem_wren_o,
    output logic op_sel_a_o,
    output logic op_sel_b_o,
    output logic br_unsigned_o,
    output logic [1:0] wb_sel_o,
    output logic [2:0] mem_op_o,
    output logic [3:0] alu_op_o,
    output logic [31:0] pc_o,
    output logic [31:0] instr_o,
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o
);
    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin              //Turn on reset
            is_rs2_o      <= 1'b0;
            rd_wren_o     <= 1'b0;
            is_load_o     <= 1'b0;
            mem_wren_o    <= 1'b0;
            op_sel_a_o    <= 1'b0;
            op_sel_b_o    <= 1'b0;
            br_unsigned_o <= 1'b0;
            wb_sel_o      <= 2'h0;
            mem_op_o      <= 3'h0;
            alu_op_o      <= 4'h0;
            pc_o          <= 32'h0;
            instr_o       <= 32'h00000013;
            rs1_data_o    <= 32'h0;
            rs2_data_o    <= 32'h0;
        end
        else if (enable_i) begin        //Turn on enable
            is_rs2_o      <= is_rs2_i;
            rd_wren_o     <= rd_wren_i;
            is_load_o     <= is_load_i;
            mem_wren_o    <= mem_wren_i;
            op_sel_a_o    <= op_sel_a_i;
            op_sel_b_o    <= op_sel_b_i;
            br_unsigned_o <= br_unsigned_i;
            wb_sel_o      <= wb_sel_i;
            mem_op_o      <= mem_op_i;
            alu_op_o      <= alu_op_i;
            pc_o          <= pc_i;
            instr_o       <= instr_i;
            rs1_data_o    <= rs1_data_i;
            rs2_data_o    <= rs2_data_i;
        end
    end
endmodule : ID_EX
