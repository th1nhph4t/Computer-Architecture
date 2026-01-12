`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/branch/00_src/constant.sv"
module immgen(
    input logic [31:0] instr_i,
    output logic [31:0] imm_o
);
    always_comb begin
        case(instr_i[6:2])
            `OPCODE_LUI,`OPCODE_AUIPC: begin
                imm_o = {instr_i[31:12],12'b0};
            end
            `OPCODE_JAL: begin
                if (instr_i[31]) imm_o = {11'h7FF,instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
                else imm_o = {11'h0,instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21],1'b0};
            end
            `OPCODE_JALR,`OPCODE_LOAD: begin
                if (instr_i[31]) imm_o = {20'hFFFFF,instr_i[31:20]};
                else imm_o = {20'h0,instr_i[31:20]};
            end
            `OPCODE_BRANCH: begin
                if (instr_i[31]) imm_o = {19'h7FFFF,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
                else imm_o = {19'h0,instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
            end
            `OPCODE_STORE: begin
            if (instr_i[31]) imm_o = {20'hFFFFF,instr_i[31:25],instr_i[11:7]};
            else imm_o = {20'h0,instr_i[31:25],instr_i[11:7]};
            end
            `OPCODE_OP_IMM: begin
                if (instr_i[14:12] == 3'b001 | instr_i[14:12] == 3'b101) begin
                    imm_o = {27'h0,instr_i[24:20]};
                end 
                else begin
                    if (instr_i[31]) imm_o = {20'hFFFFF,instr_i[31:20]};
                    else imm_o = {20'h0,instr_i[31:20]};
                end
            end
            default: imm_o = 32'h0;
        endcase
    end
endmodule : immgen
