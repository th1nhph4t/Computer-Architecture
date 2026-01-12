`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/forwarding/00_src/constant.sv"
/* verilator lint_off UNUSED */
module ctrl_unit(
    //inputs
    input logic [31:0] instr_i,
    //outputs
    output logic is_load_o,
    output logic is_rs2_o,
    output logic br_unsigned_o, 
    output logic rd_wren_o,
    output logic op_a_sel_o,
    output logic op_b_sel_o,
    output logic mem_wren_o,
    output logic [3:0] alu_op_o,
    output logic [2:0] mem_op_o,
    output logic [1:0] wb_sel_o,
    output logic o_insn_vld   
);

   
    localparam CLEAR = 1'b0;
    localparam SET = 1'b1;

    // Default outputs
    always_comb begin
        is_load_o     = CLEAR;
        is_rs2_o      = CLEAR;
        br_unsigned_o = CLEAR;
        rd_wren_o     = CLEAR;
        op_a_sel_o    = `CTL_ALU_A_RS1;
        op_b_sel_o    = `CTL_ALU_B_RS2;
        mem_wren_o    = CLEAR;
        alu_op_o      = `ALU_ADD;
        mem_op_o      = `FUNCT3_MEM_WORD;
        wb_sel_o      = `CTL_WRITEBACK_ALU;
        o_insn_vld    = SET; 

        case(instr_i[6:2])
            `OPCODE_LUI: begin
                rd_wren_o     = SET;
                op_b_sel_o    = `CTL_ALU_B_IMM;
                alu_op_o      = `ALU_RS2;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_AUIPC: begin
                rd_wren_o     = SET;
                op_a_sel_o    = `CTL_ALU_A_PC;
                op_b_sel_o    = `CTL_ALU_B_IMM;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_JAL: begin
                rd_wren_o     = SET;
                wb_sel_o      = `CTL_WRITEBACK_PC4;
                op_a_sel_o    = `CTL_ALU_A_PC;
                op_b_sel_o    = `CTL_ALU_B_IMM;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_JALR: begin
                rd_wren_o     = SET;
                wb_sel_o      = `CTL_WRITEBACK_PC4;
                op_b_sel_o    = `CTL_ALU_B_IMM;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_BRANCH: begin
                br_unsigned_o = ((instr_i[14:12] == `FUNCT3_BRANCH_BLTU) || (instr_i[14:12] == `FUNCT3_BRANCH_BGEU));
                op_a_sel_o    = `CTL_ALU_A_PC;
                op_b_sel_o    = `CTL_ALU_B_IMM;
                is_rs2_o      = SET;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_LOAD: begin
                rd_wren_o     = SET;
                op_b_sel_o    = `CTL_ALU_B_IMM;
                mem_op_o      = instr_i[14:12];
                wb_sel_o      = `CTL_WRITEBACK_LOAD;
                is_load_o     = SET;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_STORE: begin
                mem_wren_o    = SET;
                mem_op_o      = instr_i[14:12];
                op_b_sel_o    = `CTL_ALU_B_IMM;
                is_rs2_o      = SET;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_OP_IMM: begin
                rd_wren_o     = SET;
                alu_op_o      = {((instr_i[14:12] == 3'b001)||(instr_i[14:12] == 3'b101)) ? instr_i[30] : 1'b0, instr_i[14:12]};
                op_b_sel_o    = `CTL_ALU_B_IMM;
                o_insn_vld    = CLEAR;
            end
            `OPCODE_OP: begin
                rd_wren_o     = SET;
                alu_op_o      = {instr_i[30], instr_i[14:12]};
                is_rs2_o      = SET;
                o_insn_vld    = CLEAR;
            end
            default: begin
                o_insn_vld    = CLEAR; 
            end
        endcase
    end
endmodule : ctrl_unit

