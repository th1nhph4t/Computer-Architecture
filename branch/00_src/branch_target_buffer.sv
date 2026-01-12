`include "/earth/class/comparch/ee3043/ca131/Downloads/thu/branch/00_src/constant.sv"
module branch_target_buffer#(parameter SIZE = 128, WIDTH = 32, BIT_STATE = 2)(
    input logic clk_i,
    input logic rst_ni,
    //inputs
    input logic [31:0] alu_data_i, // PC value is calculated by ALU module (get from alu_data_o)
    input logic [31:0] instr_IF_i,
    input logic [31:0] instr_EX_i,
    input logic [31:0] pc_IF_i, //use for jump instruction index when read
    input logic [31:0] pc_EX_i, //use for jump instruction index when write
    input logic taken_i, //1 if jump is correct, 0 if jump is wrong (get from br_sel_o)
    //outputs
    output logic [31:0] pc_o,
    output logic br_sel_BTB_o,
	input logic [31:0] pc_WB
  
);
    logic [WIDTH-1:0] predicted_pc [SIZE];
    logic [22:0] tag [SIZE];
    logic [BIT_STATE-1:0] pred_taken [SIZE]; //00 01 10 11
    //Address of buffer
    logic [6:0] index_W;
    logic [6:0] index_R;
    assign index_W = pc_EX_i[8:2];
    assign index_R = pc_IF_i[8:2];
    //-----------------------------------------------------------------------------------------------------//
    //Write the branch info if find no branch info in the buffer
    always_ff @(posedge clk_i) begin
        if ((instr_EX_i[6:2] == `OPCODE_BRANCH || instr_EX_i[6:2] == `OPCODE_JAL || instr_EX_i[6:2] == `OPCODE_JALR) && (taken_i)) begin
            tag[index_W] <= pc_EX_i[31:9];
            predicted_pc[index_W] <= alu_data_i;
            if (pred_taken[index_W] == 2'b00) begin
                pred_taken[index_W] <= 2'b01;
            end 
            else if (pred_taken[index_W] == 2'b01) begin
                pred_taken[index_W] <= 2'b10;
            end
            else if (pred_taken[index_W] == 2'b10) begin
                pred_taken[index_W] <= 2'b10;
            end
            else if (pred_taken[index_W] == 2'b11) begin
                pred_taken[index_W] <= 2'b10;
            end
        end
        else if ((instr_EX_i[6:2] == `OPCODE_BRANCH || instr_EX_i[6:2] == `OPCODE_JAL || instr_EX_i[6:2] == `OPCODE_JALR) && (!taken_i)) begin
            tag[index_W] <= pc_EX_i[31:9];
            predicted_pc[index_W] <= alu_data_i;
            if (pred_taken[index_W] == 2'b00) begin
                pred_taken[index_W] <= 2'b00;
            end 
            else if (pred_taken[index_W] == 2'b01) begin
                pred_taken[index_W] <= 2'b00;
            end
            else if (pred_taken[index_W] == 2'b10) begin
                pred_taken[index_W] <= 2'b11;
            end
            else if (pred_taken[index_W] == 2'b11) begin
                pred_taken[index_W] <= 2'b00;
            end
        end
    end
    //Read the branch info in the buffer
    always_comb begin
        if (!rst_ni) begin
            pc_o = 32'd0;
            br_sel_BTB_o = 1'b0;
        end else begin
            if ((pc_IF_i[31:9] == tag[index_R]) && (pred_taken[index_R] == 2'b10 || pred_taken[index_R] == 2'b11)) begin
                pc_o = predicted_pc[index_R];
                br_sel_BTB_o = 1'b1; //predicted PC
            end
            else begin
                pc_o = 32'd0;
                br_sel_BTB_o = 1'b0; //PC + 4
            end
        end
    end

	//count branch
	int count_jump;
	int count_miss;
	always_ff @(posedge clk_i) begin
        if ((instr_EX_i[6:2] == `OPCODE_BRANCH || instr_EX_i[6:2] == `OPCODE_JAL || 	instr_EX_i[6:2] == `OPCODE_JALR) )  begin
			if (pc_EX_i [31:9] != tag[pc_EX_i[8:2]]) 
				count_miss <= count_miss + 1;
			count_jump <= count_jump + 1;
		end
	if (pc_WB == 32'h1680) begin
            $display("\n count_jump: %0d", count_jump);
			$display("\n count_miss: %0d", count_miss);
	end
	end
	

endmodule : branch_target_buffer
