`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/singlecycle/00_src/constant.sv"

module alu (
    input  signed [31:0] i_operand_a,
    input  signed [31:0] i_operand_b,
    input  logic  [ 3:0] i_alu_op,
    output logic  [31:0] o_alu_data
);

//// -------------Declare signals------------////
	logic [31:0] diff_ab_s;
	// diff_ab_us has 33 bits because we consider bit 32 is the signed bit for subtract equation, if bit 32 is 1 (negative), we consider a<b
	logic [32:0] diff_ab_us; 
	// temp data for shift right arithmetic
	logic [31:0] temp_data_srl, temp_data_sll, temp_data_sra;
	// data out Shifr Right Arithmetic
	logic [31:0] data_o_srl, data_o_sll, data_o_sra;
	
////-------------Assign values---------------////
	// diff_ab_s is the difference between a and b, signed
	assign diff_ab_s = i_operand_a + (~i_operand_b + 32'd1); 
	// diff_ab_us is the difference between a and b, unsigned
	assign diff_ab_us = {1'b0,i_operand_a} + (~{1'b0,i_operand_b} + 32'd1);
 
	
	always_comb begin : alu
    o_alu_data = 32'b0;
    case (i_alu_op)
      `ALU_ADD:  o_alu_data = i_operand_a + i_operand_b;
      `ALU_SUB:  o_alu_data = i_operand_a + (~i_operand_b + 32'd1);
      `ALU_SLT:  begin
							if (i_operand_a[31] ^ i_operand_b[31]) begin   // if a and b has the same signed bit 
								o_alu_data = (i_operand_a[31])?(32'd1):(32'd0); // if a is negative one, so a is smaller than b, then o_alu_data equal to 1
							end else begin
								o_alu_data = (diff_ab_s[31])?(32'd1):(32'd0); // if the signed bit of diff_ab_s is 1 then a<b, so o_alu_data equals to 1
							end
						end
      `ALU_SLTU: o_alu_data = (diff_ab_us[32])?(32'd1):(32'd0); // if the signed bit of diff_ab_us is 1 then a<b, so o_alu_data equals to 1
      `ALU_XOR:  o_alu_data = i_operand_a ^ i_operand_b;
      `ALU_OR:   o_alu_data = i_operand_a | i_operand_b;
      `ALU_AND:  o_alu_data = i_operand_a & i_operand_b;
		`ALU_SLL:  o_alu_data = data_o_sll;
		`ALU_SRL:  o_alu_data = data_o_srl;
		`ALU_SRA:  o_alu_data = data_o_sra;
		  
      default:   o_alu_data = 32'd0;
    endcase
  end

//-----Shift right logical block--------//
  always_comb  begin
						// assign the original operand_a to temp_data_srl
							temp_data_srl = i_operand_a;
						// Shift right by 1 bit for each shift amount
							if (i_operand_b[0]) temp_data_srl = {1'b0, temp_data_srl[31:1]};
							if (i_operand_b[1]) temp_data_srl = {2'b0, temp_data_srl[31:2]};
							if (i_operand_b[2]) temp_data_srl = {4'b0, temp_data_srl[31:4]};
							if (i_operand_b[3]) temp_data_srl = {8'b0, temp_data_srl[31:8]};
							if (i_operand_b[4]) temp_data_srl = {16'b0, temp_data_srl[31:16]};
					end
assign  data_o_srl = temp_data_srl;
//-----Shift left logical block--------//
  always_comb  begin
						// assign the original operand_a to temp_data_srl
							temp_data_sll = i_operand_a;
						// Shift left by 1 bit for each shift amount
							if (i_operand_b[0]) temp_data_sll = {temp_data_sll[30:0],1'b0};
							if (i_operand_b[1]) temp_data_sll = {temp_data_sll[29:0],2'b0};
							if (i_operand_b[2]) temp_data_sll = {temp_data_sll[27:0],4'b0};
							if (i_operand_b[3]) temp_data_sll = {temp_data_sll[23:0],8'b0};
							if (i_operand_b[4]) temp_data_sll = {temp_data_sll[15:0],16'b0};
					end
assign  data_o_sll = temp_data_sll;
//-----Shift right arithmetic block--------//
  always_comb  begin
						// assign the original operand_a to temp_data_sra
							temp_data_sra = i_operand_a;
						// Shift right by 1 bit for each shift amount
							if (i_operand_b[0]) temp_data_sra = {i_operand_a[31], temp_data_sra[31:1]};
							if (i_operand_b[1]) temp_data_sra = {{2{i_operand_a[31]}}, temp_data_sra[31:2]};
							if (i_operand_b[2]) temp_data_sra = {{4{i_operand_a[31]}}, temp_data_sra[31:4]};
							if (i_operand_b[3]) temp_data_sra = {{8{i_operand_a[31]}}, temp_data_sra[31:8]};
							if (i_operand_b[4]) temp_data_sra = {{16{i_operand_a[31]}}, temp_data_sra[31:16]};
					end
assign  data_o_sra = temp_data_sra;

endmodule : alu
