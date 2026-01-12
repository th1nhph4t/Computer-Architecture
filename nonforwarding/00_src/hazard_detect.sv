`include"/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/nonforwarding/00_src/constant.sv"
/* verilator lint_off UNUSED */
module hazard_detect(
    //inputs
    input logic br_sel_i,
    input logic id_is_rs2_i,
    input logic ex_rd_wren_i,
    input logic mem_rd_wren_i,
    input logic wb_rd_wren_i,
    input logic [4:0] ex_rd_addr_i,
    input logic [4:0] mem_rd_addr_i,
    input logic [4:0] wb_rd_addr_i,
    input logic [4:0] id_rs1_addr_i,
    input logic [4:0] id_rs2_addr_i,
    input logic [31:0] id_instr_i,
    input logic [31:0] ex_instr_i,
    //outputs
    output logic id_enable_o,
    output logic ex_enable_o,
    output logic mem_enable_o,
    output logic wb_enable_o,
    output logic pc_enable_o,
    output logic id_reset_no,
    output logic ex_reset_no,
    output logic mem_reset_no,
    output logic wb_reset_no
);
    //instances
    logic structure_hazard,data_hazard,control_hazard;
    logic id_is_jump,ex_is_jump;
    //assign
    assign structure_hazard = (wb_rd_wren_i)  && (wb_rd_addr_i != 5'h0)  && ((wb_rd_addr_i == id_rs1_addr_i)  || ((wb_rd_addr_i == id_rs2_addr_i)  && (id_is_rs2_i)));
    assign data_hazard      = (ex_rd_wren_i)  && (ex_rd_addr_i != 5'h0)  && ((ex_rd_addr_i == id_rs1_addr_i)  || ((ex_rd_addr_i == id_rs2_addr_i)  && (id_is_rs2_i)));
    assign control_hazard   = (mem_rd_wren_i) && (mem_rd_addr_i != 5'h0) && ((mem_rd_addr_i == id_rs1_addr_i) || ((mem_rd_addr_i == id_rs2_addr_i) && (id_is_rs2_i)));
    assign id_is_jump       = (id_instr_i[6:2] == `OPCODE_JAL) || (id_instr_i[6:2] == `OPCODE_JALR) || (id_instr_i[6:2] == `OPCODE_BRANCH);
    assign ex_is_jump       = (ex_instr_i[6:2] == `OPCODE_JAL) || (ex_instr_i[6:2] == `OPCODE_JALR) || (ex_instr_i[6:2] == `OPCODE_BRANCH);
    //always_comb
    always_comb begin
        //default settings
        id_enable_o  = 1'b1;
        ex_enable_o  = 1'b1;
        mem_enable_o = 1'b1;
        wb_enable_o  = 1'b1;
        pc_enable_o  = 1'b1;
        id_reset_no  = 1'b1;
        ex_reset_no  = 1'b1;
        mem_reset_no = 1'b1;
        wb_reset_no  = 1'b1;
        //Jump/Branch or hazard setting
        if (structure_hazard || data_hazard || control_hazard) begin
            ex_reset_no = 1'b0;     //reset ID/EX register
            id_enable_o = 1'b0;     //turn off enable IF/ID register
            pc_enable_o = br_sel_i; //0: PC = PC_IF, 1: PC = ALU_DATA
        end
        else if (id_is_jump) begin
            pc_enable_o = 1'b0;
            id_reset_no = 1'b0;
        end
        else if (ex_is_jump) begin
            if (br_sel_i) id_reset_no = 1'b0;
            else id_reset_no = 1'b1;
        end
        else begin
            id_enable_o  = 1'b1;
            ex_enable_o  = 1'b1;
            mem_enable_o = 1'b1;
            wb_enable_o  = 1'b1;
            pc_enable_o  = 1'b1;
            id_reset_no  = 1'b1;
            ex_reset_no  = 1'b1;
            mem_reset_no = 1'b1;
            wb_reset_no  = 1'b1;
        end
    end
endmodule : hazard_detect
