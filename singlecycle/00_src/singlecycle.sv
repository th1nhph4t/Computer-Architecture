module singlecycle(
    //inputs
    input logic i_clk,
    input logic i_rst_n,
    input logic [31:0] i_io_sw,
    //outputs
    output logic [31:0] o_io_lcd,
    output logic [31:0] o_io_ledg,
    output logic [31:0] o_io_ledr,
  	output logic [6:0]       o_io_hex0,
  	output logic [6:0]       o_io_hex1,
  	output logic [6:0]       o_io_hex2,
  	output logic [6:0]       o_io_hex3,
  	output logic [6:0]       o_io_hex4,
  	output logic [6:0]       o_io_hex5,
  	output logic [6:0]       o_io_hex6,
  	output logic [6:0]       o_io_hex7,
	 //----signals for debugging---//
	 output logic [31:0] o_pc_debug,
	 output logic o_insn_vld
);
//------Wire--------//
    logic pc_sel;
    logic opa_sel;
    logic opb_sel;
    logic rd_wren;
    logic br_un;
    logic br_less;
    logic br_equal;
    logic lsu_wren;
    logic [1:0]  wb_sel;
    logic [3:0]  alu_op;
    logic [31:0] alu_data;
    logic [31:0] pc_next;
    logic [31:0] op_a;
    logic [31:0] pc;
    logic [31:0] rs1_data;
    logic [31:0] op_b;
    logic [31:0] rs2_data;
    logic [31:0] wb_data;
    logic [31:0] pc_four;
    logic [31:0] ld_data;
    logic [31:0] immediate;
    logic [31:0] instr;

// Xóa dòng assign o_pc_debug = pc
always_ff @( posedge i_clk or negedge i_rst_n ) begin
            if(!i_rst_n) begin
              o_pc_debug <= 32'd0;
            end else begin
              o_pc_debug <= pc;
            end
          end


//module - instruction memory
instr_memory instr_memory(
        .i_addr  (pc),
        .o_rdata (instr)
    );
    //module - register file
    regfile regfile(
        .i_clk       (i_clk),
        .i_rst_n     (i_rst_n),
        .i_rs1_addr  (instr[19:15]), 
        .i_rs2_addr  (instr[24:20]), 
        .i_rd_addr   (instr[11:7]),
        .i_rd_data   (wb_data),
        .i_rd_wren   (rd_wren),
        .o_rs1_data  (rs1_data),
        .o_rs2_data  (rs2_data)
    );
    //module - immediate generator
    immgen immediate_generator(
        .i_instr (instr),
        .o_imm   (immediate)
    );
    //module - branch comparison
    brc brc(
        .i_rs1_data  (rs1_data),
        .i_rs2_data  (rs2_data),
        .i_br_un (br_un),
        .o_br_less     (br_less),
        .o_br_equal    (br_equal)
    );
    //module - arithmetic logic unit
    alu alu(
        .i_operand_a (op_a),
        .i_operand_b (op_b),
        .i_alu_op    (alu_op),
        .o_alu_data    (alu_data)
    );
    //module - load store unit
    lsu lsu(
        .i_clk      (i_clk),
		  .i_lsu_wren (lsu_wren),
        .i_rst_n    (i_rst_n),
        .i_lsu_addr     (alu_data),
        .i_st_data  (rs2_data),
        .i_io_sw    (i_io_sw),
        .o_ld_data  (ld_data),
        .o_io_lcd   (o_io_lcd),
        .o_io_ledg  (o_io_ledg),
        .o_io_ledr  (o_io_ledr),
        .o_io_hex0  (o_io_hex0),
        .o_io_hex1  (o_io_hex1),
        .o_io_hex2  (o_io_hex2),
        .o_io_hex3  (o_io_hex3),
        .o_io_hex4  (o_io_hex4),
        .o_io_hex5  (o_io_hex5),
        .o_io_hex6  (o_io_hex6),
        .o_io_hex7  (o_io_hex7)
    );
    //module - control unit
    controlunit controlunit(
        .i_instr        (instr),
        .i_br_less      (br_less),
        .i_br_equal     (br_equal),
        .o_pc_sel       (pc_sel),
        .o_br_un  (br_un),  
        .o_rd_wren      (rd_wren),
        .o_opa_sel     (opa_sel),
        .o_opb_sel     (opb_sel),
        .o_lsu_wren     (lsu_wren),
        .o_alu_op       (alu_op),
        .o_wb_sel       (wb_sel),
		  .o_insn_vld (o_insn_vld)
    );
    //pc+4

	int count_cycle = 0;
	always @(posedge i_clk)
    begin
        if (o_pc_debug == 32'h1680) begin
            $display("\n count_cycle: %0d", count_cycle);
           
        end
        else
            count_cycle <= count_cycle + 1;
    end

    assign pc_four = pc + 32'd4;
    //mux-PC source
    always_comb begin
        if (pc_sel) begin //PC4-0 and ALU_DATA-1
            pc_next = alu_data;
        end
        else begin
            pc_next = pc_four;
        end
    end
    //PC counter
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) pc <= 32'h0;
        else pc <= pc_next;
    end
    //mux-1st operand source
    always_comb begin
        if (opa_sel) begin //RS1-0 and PC-1
            op_a = pc;
        end
        else begin
            op_a = rs1_data;
        end
    end
    //mux-2nd operand source
    always_comb begin
        if (opb_sel) begin //RS2-0 and IMM-1
            op_b = immediate;
        end
        else begin
            op_b = rs2_data;
        end
    end
    //mux-Register data sources
    always_comb begin
        case(wb_sel)
            2'b00: wb_data = alu_data;
            2'b01: wb_data = ld_data;
            2'b10: wb_data = pc_four;
            2'b11: wb_data = immediate;
            default: wb_data = 32'h0;
        endcase
    end
endmodule : singlecycle
