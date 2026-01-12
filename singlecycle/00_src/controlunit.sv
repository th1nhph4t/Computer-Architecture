`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/singlecycle/00_src/constant.sv"

module controlunit(
    input logic [31:0] i_instr,
    input logic i_br_less, i_br_equal,

    output logic o_insn_vld,
	 output logic o_pc_sel,
	 output logic o_br_un, 
	 output logic o_rd_wren, 
	 output logic o_opa_sel, 
	 output logic o_opb_sel, 
	 output logic o_lsu_wren,
    output logic [3:0] o_alu_op,
    output logic [1:0] o_wb_sel
);
	logic [2:0] funct3;
	logic [4:0] funct7;

	assign funct3 = i_instr[14:12];
	assign funct7 = i_instr[6:2];
	
///Global Localparam///
localparam CLEAR = 1'b0;
localparam SET = 1'b1;

always_comb begin
		   o_pc_sel 		= `CTL_PC_PC4; 				// 0:PC = PC + 4, 1: PC = alu_data
			o_br_un 			= CLEAR; 					// UNSIGNED BRANCH
			o_rd_wren 		= CLEAR; 					// WRITE TO RD
			o_opa_sel		= `CTL_ALU_A_RS1; 			// 0: RS1, 1: PC
			o_opb_sel 		= `CTL_ALU_B_RS2; 			// 0: RS2, 1: IMM
			o_lsu_wren 		= CLEAR; 					// WRITE TO MEM
			o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
			o_wb_sel 		= `CTL_WRITEBACK_ALU; 		// 0: ALU_DATA, 1: LD_DATA, 2: PC_FOUR, 3: IMM
			o_insn_vld		= SET;
			case(funct7)
			`OPCODE_LOAD:
				begin
					o_pc_sel 		= `CTL_PC_PC4; 				// 0:PC = PC + 4, 1: PC = alu_data
					o_br_un 			= CLEAR; 	
					o_rd_wren 		= SET;
					o_opa_sel		= `CTL_ALU_A_RS1;
					o_opb_sel 		= `CTL_ALU_B_IMM;
					o_lsu_wren 		= CLEAR; 					// WRITE TO MEM
					o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
					o_wb_sel 		= `CTL_WRITEBACK_LOAD;
					o_insn_vld		= CLEAR;
				end
			`OPCODE_OP_IMM:
				begin
					o_pc_sel 		= `CTL_PC_PC4; 				// 0:PC = PC + 4, 1: PC = alu_data
					o_br_un 			= CLEAR; 	
					o_rd_wren 		= SET;
					o_opa_sel		= `CTL_ALU_A_RS1;
					o_opb_sel 		= `CTL_ALU_B_IMM;
					o_lsu_wren 		= CLEAR;
					o_alu_op 		= {((funct3 == 3'b001)||(funct3 == 3'b101)) ? i_instr[30] : 1'b0 ,funct3}; // lệnh immediate k có lệnh trừ như lệnh reg
					o_wb_sel 		= `CTL_WRITEBACK_ALU; 		// 0: ALU_DATA, 1: LD_DATA, 2: PC_FOUR, 3: IMM
					o_insn_vld		= CLEAR;
				end
			`OPCODE_STORE:
				begin
					o_pc_sel 		= `CTL_PC_PC4;			
					o_br_un 			= CLEAR; 	
					o_rd_wren 		= CLEAR;
					o_opa_sel		= `CTL_ALU_A_RS1;
					o_opb_sel 		= `CTL_ALU_B_IMM;
					o_lsu_wren 		= SET;
					o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
					o_wb_sel 		= `CTL_WRITEBACK_LOAD;
					o_insn_vld		= CLEAR;	
				end
			`OPCODE_AUIPC:
				begin
					o_pc_sel 		= `CTL_PC_PC4; 				// 0:PC = PC + 4, 1: PC = alu_data
					o_br_un 			= CLEAR; 					// UNSIGNED BRANCH
					o_rd_wren 		= SET;
					o_opa_sel 		= `CTL_ALU_A_PC;
					o_opb_sel 		= `CTL_ALU_B_IMM;	
					o_lsu_wren 		= CLEAR; 					// WRITE TO MEM
					o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
					o_wb_sel 		= `CTL_WRITEBACK_ALU;
					o_insn_vld		= CLEAR;					
				end
			`OPCODE_LUI:
				begin
					o_pc_sel 		= `CTL_PC_PC4; 				// 0:PC = PC + 4, 1: PC = alu_data
					o_br_un 			= CLEAR; 					// UNSIGNED BRANCH
					o_rd_wren 		= SET;
					o_opa_sel		= `CTL_ALU_A_RS1; 			// 0: RS1, 1: PC
					o_opb_sel 		= `CTL_ALU_B_RS2; 			// 0: RS2, 1: IMM
					o_lsu_wren 		= CLEAR; 					// WRITE TO MEM
					o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
					o_wb_sel 		= `CTL_WRITEBACK_IMM;
					o_insn_vld		= CLEAR;
				end
			`OPCODE_JAL:
				begin
					o_pc_sel 		= `CTL_PC_ALU_DATA; 				// 0:PC = PC + 4, 1: PC = alu_data
					o_br_un 			= CLEAR; 					// UNSIGNED BRANCH
					o_rd_wren 		= SET;
					o_opa_sel 		= `CTL_ALU_A_PC;
					o_opb_sel 		= `CTL_ALU_B_IMM;
					o_lsu_wren 		= CLEAR; 					// WRITE TO MEM
					o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
					o_wb_sel 		= `CTL_WRITEBACK_PC4;
					o_insn_vld		= CLEAR;
				end
			`OPCODE_JALR:
				begin
					o_pc_sel 		= `CTL_PC_ALU_DATA; 				// 0:PC = PC + 4, 1: PC = alu_data
					o_br_un 			= CLEAR; 					// UNSIGNED BRANCH
					o_rd_wren 		= SET;
					o_opa_sel		= `CTL_ALU_A_RS1;
					o_opb_sel 		= `CTL_ALU_B_IMM;
					o_lsu_wren 		= CLEAR; 					// WRITE TO MEM
					o_alu_op 		= `ALU_ADD; 				// ALU_OP default ADD
					o_wb_sel 		= `CTL_WRITEBACK_PC4;
					o_insn_vld		= CLEAR;					
				end
			`OPCODE_BRANCH:
				begin
					case(funct3)
						`FUNCT3_BRANCH_BEQ:
							o_pc_sel = i_br_equal;
						`FUNCT3_BRANCH_BNE:
							o_pc_sel = !i_br_equal;
						`FUNCT3_BRANCH_BLT:
							o_pc_sel = i_br_less;
						`FUNCT3_BRANCH_BGE:
							o_pc_sel = (i_br_equal | !i_br_less);                  
						`FUNCT3_BRANCH_BLTU:
							o_pc_sel = i_br_less;                 
						`FUNCT3_BRANCH_BGEU:
							o_pc_sel = (i_br_equal | !i_br_less);                                    
						default:
							o_pc_sel = 1'bx;                
					endcase					  
					o_br_un = !((funct3 == `FUNCT3_BRANCH_BGEU) || (funct3 == `FUNCT3_BRANCH_BLTU)); 
					o_opa_sel = `CTL_ALU_A_PC;
					o_opb_sel = `CTL_ALU_B_IMM;
					o_insn_vld		= CLEAR;
				end
			`OPCODE_OP: //OP
				begin
					o_rd_wren = SET;
					o_alu_op = {i_instr[30] ,funct3};
					o_insn_vld		= CLEAR;
				end
			endcase
		end	
endmodule: controlunit
