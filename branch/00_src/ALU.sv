`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/branch/00_src/constant.sv"
module ALU(
    //inputs
    input signed [31:0] operand_a_i,
    input signed [31:0] operand_b_i,
    input logic [3:0] alu_op_i,
    //outputs
    output logic [31:0] alu_data
);
    logic [31:0] tmp_sub_data;
    logic [31:0] tmp_sll_data;
    logic [31:0] tmp_srl_data;
    logic [31:0] tmp_sra_data;
    logic [31:0] tmp_op_b_sub;
    //module
    logic_shift_left_32bit SLL(
        .data_i   (operand_a_i),
        .shamt_i  (operand_b_i[4:0]),
        .data_o   (tmp_sll_data)
    );
    logic_shift_right_32bit SRL(
        .data_i   (operand_a_i),
        .shamt_i  (operand_b_i[4:0]),
        .data_o   (tmp_srl_data)
    );
    arithmetic_shift_right_32bit SRA(
        .data_i   (operand_a_i),
        .shamt_i  (operand_b_i[4:0]),
        .data_o   (tmp_sra_data)
    );
    //Output
    assign tmp_sub_data = operand_a_i + (~(operand_b_i) + 32'd1);
    always_comb begin
        case(alu_op_i)
            `ALU_ADD: alu_data = operand_a_i + operand_b_i;
            `ALU_SUB: alu_data = tmp_sub_data;
            `ALU_SLT: begin
                if (operand_a_i[31] ^ operand_b_i[31]) begin
                    alu_data = (operand_a_i[31])?(32'd1):(32'd0);
                end
                else begin
                    alu_data = (tmp_sub_data[31])?(32'd1):(32'd0);
                end
            end
            `ALU_SLTU: begin 
                if (operand_a_i[31] ^ operand_b_i[31]) begin
                    alu_data = {31'b0,operand_b_i[31]};
                end
                else begin
                    alu_data  = (tmp_sub_data[31])?(32'd1):(32'd0);
                end
            end
            `ALU_XOR: alu_data = operand_a_i ^ operand_b_i;
            `ALU_OR:  alu_data = operand_a_i | operand_b_i;
            `ALU_AND: alu_data = operand_a_i & operand_b_i;
            `ALU_SLL: alu_data = tmp_sll_data;
            `ALU_SRL: alu_data = tmp_srl_data;
            `ALU_SRA: alu_data = tmp_sra_data;
				`ALU_RS2 : alu_data = operand_b_i;
            default:  alu_data = 32'd0;
        endcase
    end
endmodule : ALU
