`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/singlecycle/00_src/constant.sv"

module immgen(
    input logic [31:0] i_instr,
    output logic [31:0] o_imm
);
    always_comb begin
        case(i_instr[6:2])
            `OPCODE_LUI,`OPCODE_AUIPC: begin
                o_imm = {i_instr[31:12],12'b0};
            end
            `OPCODE_JAL: begin
                if (i_instr[31]) o_imm = {11'h7FF,i_instr[31],i_instr[19:12],i_instr[20],i_instr[30:21],1'b0}; // Xét dấu đầu của imm để mở rộng dấu nếu là số âm vì offset để nhảy địa chỉ có thể âm
                else o_imm = {11'h0,i_instr[31],i_instr[19:12],i_instr[20],i_instr[30:21],1'b0};
            end
            `OPCODE_JALR,`OPCODE_LOAD: begin
                if (i_instr[31]) o_imm = {20'hFFFFF,i_instr[31:20]}; // Xét bit đầu imm để mở rộng dấu vì offset cũng có thể âm
                else o_imm = {20'h0,i_instr[31:20]};
            end
            `OPCODE_BRANCH: begin
                if (i_instr[31]) o_imm = {19'h7FFFF,i_instr[31],i_instr[7],i_instr[30:25],i_instr[11:8],1'b0}; // Xét bit đầu imm để mở rộng dấu vì offset cũng có thể âm
                else o_imm = {19'h0,i_instr[31],i_instr[7],i_instr[30:25],i_instr[11:8],1'b0};
            end
            `OPCODE_STORE: begin
            if (i_instr[31]) o_imm = {20'hFFFFF,i_instr[31:25],i_instr[11:7]}; // Xét bit đầu imm để mở rộng dấu vì offset cũng có thể âm
            else o_imm = {20'h0,i_instr[31:25],i_instr[11:7]};
            end
            `OPCODE_OP_IMM: begin
                if (i_instr[14:12] == 3'b001 | i_instr[14:12] == 3'b101) begin  // Xét 3 bit function xem có thuộc 3 phép shift bit không
                    o_imm = {27'h0,i_instr[24:20]};
                end else begin
							  if (i_instr[31]) o_imm = {20'hFFFFF,i_instr[31:20]}; // Còn lại không thuộc 3 TH shift thì immediate xét mở rộng dấu để tính toán như bình thường
							  else o_imm = {20'h0,i_instr[31:20]};
						 end
					 end
            default: o_imm = 32'h0;
        endcase
    end
endmodule : immgen
