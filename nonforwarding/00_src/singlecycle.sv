`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/nonforwarding/00_src/constant.sv"
/* verilator lint_off UNUSED */
module singlecycle(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic [31:0] io_sw_i,
    //outputs
    output logic [31:0] io_lcd_o,
    output logic [31:0] io_ledg_o,
    output logic [31:0] io_ledr_o,
    output logic [ 6:0] io_hex0_o,
    output logic [ 6:0] io_hex1_o,
    output logic [ 6:0] io_hex2_o,
    output logic [ 6:0] io_hex3_o,
    output logic [ 6:0] io_hex4_o,
    output logic [ 6:0] io_hex5_o,
    output logic [ 6:0] io_hex6_o,
    output logic [ 6:0] io_hex7_o,
	output logic [31:0] o_pc_debug,
	output logic o_insn_vld 

	
);
    //instances
    logic id_rst_ni,ex_rst_ni,mem_rst_ni,wb_rst_ni;
    logic enable_ID,enable_EX,enable_ME,enable_WB;
    logic [31:0] pc_IF,pc_ID,pc_EX,pc_ME,pc_WB,pc_four_IF,pc_four_WB;
    logic [31:0] imm_EX,imm_ME,imm_WB;
    logic [31:0] instr_IF,instr_ID,instr_EX,instr_ME,instr_WB;
    logic is_rs2_ID,is_rs2_EX;
    logic rd_wren_ID,rd_wren_EX,rd_wren_ME,rd_wren_WB;
    logic is_load_ID,is_load_EX,is_load_ME,is_load_WB;
    logic mem_wren_ID,mem_wren_EX,mem_wren_ME,mem_wren_WB;
    logic op_a_sel_ID,op_a_sel_EX;
    logic op_b_sel_ID,op_b_sel_EX;
    logic br_unsigned_ID,br_unsigned_EX;
    logic [1:0] wb_sel_ID,wb_sel_EX,wb_sel_ME,wb_sel_WB;
    logic [2:0] mem_op_ID,mem_op_EX,mem_op_ME;
    logic [3:0] alu_op_ID,alu_op_EX;
    logic [31:0] rs1_data_ID,rs1_data_EX;
    logic [31:0] rs2_data_ID,rs2_data_EX,rs2_data_ME;
    logic [31:0] alu_data_EX,alu_data_ME,alu_data_WB;
    logic [31:0] ld_data_ME,ld_data_WB;
    logic [31:0] next_pc;
    logic pc_enable;
    logic br_sel;
    logic [31:0] operand_a,operand_b;
    logic [31:0] wb_data_WB;
    //FETCH instruction
    instr_memory IM(
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),
        .addr_i  (pc_IF),
        .rdata_o (instr_IF)
    );
    //IF_ID register
    IF_ID reg01(
        .clk_i    (clk_i),
        .rst_ni   (id_rst_ni),
        .enable_i (enable_ID),
        .pc_i     (pc_IF),
        .instr_i  (instr_IF),
        .pc_o     (pc_ID),
        .instr_o  (instr_ID)
    );
    //DECODER instruction
    reg_file RF(
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .rs1_addr_i (instr_ID[19:15]), 
        .rs2_addr_i (instr_ID[24:20]), 
        .rd_addr_i  (instr_WB[11:7]),
        .rd_data_i  (wb_data_WB),
        .rd_wren_i  (rd_wren_WB),
        .rs1_data_o (rs1_data_ID),
        .rs2_data_o (rs2_data_ID)
    );
    ctrl_unit CU(
        .instr_i        (instr_ID),
        .is_load_o      (is_load_ID),
        .is_rs2_o       (is_rs2_ID),
        .br_unsigned_o  (br_unsigned_ID), 
        .rd_wren_o      (rd_wren_ID),
        .op_a_sel_o     (op_a_sel_ID),
        .op_b_sel_o     (op_b_sel_ID),
        .mem_wren_o     (mem_wren_ID),
        .alu_op_o       (alu_op_ID),
        .mem_op_o       (mem_op_ID),
        .wb_sel_o       (wb_sel_ID)
	   
    );
    //ID_EX register
    ID_EX reg02(
        .clk_i          (clk_i),
        .rst_ni         (ex_rst_ni),
        .enable_i       (enable_EX),
        .is_rs2_i       (is_rs2_ID),
        .rd_wren_i      (rd_wren_ID),
        .is_load_i      (is_load_ID),
        .mem_wren_i     (mem_wren_ID),
        .op_sel_a_i     (op_a_sel_ID),
        .op_sel_b_i     (op_b_sel_ID),
        .br_unsigned_i  (br_unsigned_ID),
        .wb_sel_i       (wb_sel_ID),
        .mem_op_i       (mem_op_ID),
        .alu_op_i       (alu_op_ID),
        .pc_i           (pc_ID),
        .instr_i        (instr_ID),
        .rs1_data_i     (rs1_data_ID),
        .rs2_data_i     (rs2_data_ID),
        .is_rs2_o       (is_rs2_EX),
        .rd_wren_o      (rd_wren_EX),
        .is_load_o      (is_load_EX),
        .mem_wren_o     (mem_wren_EX),
        .op_sel_a_o     (op_a_sel_EX),
        .op_sel_b_o     (op_b_sel_EX),
        .br_unsigned_o  (br_unsigned_EX),
        .wb_sel_o       (wb_sel_EX),
        .mem_op_o       (mem_op_EX),
        .alu_op_o       (alu_op_EX),
        .pc_o           (pc_EX),
        .instr_o        (instr_EX),
        .rs1_data_o     (rs1_data_EX),
        .rs2_data_o     (rs2_data_EX)
    );
    //EXECUTE instruction
    immgen IG(
        .instr_i (instr_EX),
        .imm_o   (imm_EX)
    );
    ALU alu(
        .operand_a_i (operand_a),
        .operand_b_i (operand_b),
        .alu_op_i    (alu_op_EX),
        .alu_data    (alu_data_EX)
    );
    brcomp BC(
        .instr_i        (instr_EX),
        .operand_a_i    (rs1_data_EX),
        .operand_b_i    (rs2_data_EX),
        .br_unsigned_i  (br_unsigned_EX),
        .br_sel_o       (br_sel)
    );
    //EX_ME register
    EX_ME reg03(
        .clk_i      (clk_i),
        .rst_ni     (mem_rst_ni),
        .enable_i   (enable_ME),
        .rd_wren_i  (rd_wren_EX),
        .is_load_i  (is_load_EX),
        .mem_wren_i (mem_wren_EX),
        .wb_sel_i   (wb_sel_EX),
        .mem_op_i   (mem_op_EX),
        .pc_i       (pc_EX),
        .imm_i      (imm_EX),
        .instr_i    (instr_EX),
        .rs2_data_i (rs2_data_EX),
        .alu_data_i (alu_data_EX),
        .rd_wren_o  (rd_wren_ME),
        .is_load_o  (is_load_ME),
        .mem_wren_o (mem_wren_ME),
        .wb_sel_o   (wb_sel_ME),
        .mem_op_o   (mem_op_ME),
        .pc_o       (pc_ME),
        .imm_o      (imm_ME),
        .instr_o    (instr_ME),
        .rs2_data_o (rs2_data_ME),
        .alu_data_o (alu_data_ME)
    );
    //MEMORY instruction
    LSU lsu(
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .st_en_i    (mem_wren_ME),
        //.mem_op_i   (mem_op_ME),
        .addr_i     (alu_data_ME),
        .st_data_i  (rs2_data_ME),
        .io_sw_i    (io_sw_i),
        .ld_data_o  (ld_data_ME),
        .io_lcd_o   (io_lcd_o),
        .io_ledg_o  (io_ledg_o),
        .io_ledr_o  (io_ledr_o),
        .io_hex0_o  (io_hex0_o),
        .io_hex1_o  (io_hex1_o),
        .io_hex2_o  (io_hex2_o),
        .io_hex3_o  (io_hex3_o),
        .io_hex4_o  (io_hex4_o),
        .io_hex5_o  (io_hex5_o),
        .io_hex6_o  (io_hex6_o),
        .io_hex7_o  (io_hex7_o)
    );
    //ME_WB register
    ME_WB reg04(
        .clk_i       (clk_i),
        .rst_ni       (wb_rst_ni),
        .enable_i    (enable_WB),
        .rd_wren_i   (rd_wren_ME),
        .is_load_i   (is_load_ME),
        .mem_wren_i  (mem_wren_ME),
        .wb_sel_i    (wb_sel_ME),
        .pc_i        (pc_ME),
        .imm_i       (imm_ME),
        .instr_i     (instr_ME),
        .alu_data_i  (alu_data_ME),
        .ld_data_i   (ld_data_ME),
        .rd_wren_o   (rd_wren_WB),
        .is_load_o   (is_load_WB),
        .mem_wren_o  (mem_wren_WB),
        .wb_sel_o    (wb_sel_WB),
        .pc_o        (pc_WB),
        .imm_o       (imm_WB),
        .instr_o     (instr_WB),
        .alu_data_o  (alu_data_WB),
        .ld_data_o   (ld_data_WB)
    );
    //Hazard detect
    hazard_detect HD(
        .br_sel_i       (br_sel),
        .id_is_rs2_i    (is_rs2_ID),
        .ex_rd_wren_i   (rd_wren_EX),
        .mem_rd_wren_i  (rd_wren_ME),
        .wb_rd_wren_i   (rd_wren_WB),
        .ex_rd_addr_i   (instr_EX[11:7]),
        .mem_rd_addr_i  (instr_ME[11:7]),
        .wb_rd_addr_i   (instr_WB[11:7]),
        .id_rs1_addr_i  (instr_ID[19:15]),
        .id_rs2_addr_i  (instr_ID[24:20]),
        .id_instr_i     (instr_ID),
        .ex_instr_i     (instr_EX),
        .id_enable_o    (enable_ID),
        .ex_enable_o    (enable_EX),
        .mem_enable_o   (enable_ME),
        .wb_enable_o    (enable_WB),
        .pc_enable_o    (pc_enable),
        .id_reset_no    (id_rst_ni),
        .ex_reset_no    (ex_rst_ni),
        .mem_reset_no   (mem_rst_ni),
        .wb_reset_no    (wb_rst_ni)
    );
    //WRITEBACK instruction
	assign o_pc_debug = pc_ME;

		int count_cycle = 0;
	always @(posedge clk_i)
    begin
        if (pc_WB == 32'h1680) begin
            $display("\n count_cycle: %0d", count_cycle);
           
        end
        else
            count_cycle <= count_cycle + 1;
    end

    assign pc_four_WB = pc_WB + 32'h4;
    always_comb begin
        case (wb_sel_WB)
            `CTL_WRITEBACK_ALU:  wb_data_WB = alu_data_WB;
            `CTL_WRITEBACK_LOAD: wb_data_WB = ld_data_WB;
            `CTL_WRITEBACK_PC4:  wb_data_WB = pc_four_WB;
            `CTL_WRITEBACK_IMM:  wb_data_WB = imm_WB;
            default: wb_data_WB = 32'h0;
        endcase
    end
    //PC - PC+4
    assign pc_four_IF = pc_IF + 32'h4;
    assign next_pc = (br_sel)?(alu_data_EX):(pc_four_IF);
    assign operand_a = (op_a_sel_EX)?(pc_EX):(rs1_data_EX);
    assign operand_b = (op_b_sel_EX)?(imm_EX):(rs2_data_EX);
    always_ff @(posedge clk_i) begin
        if (!rst_ni) pc_IF <= 32'h0;
        else pc_IF <= (pc_enable)?(next_pc):(pc_IF);
    end
endmodule : singlecycle
