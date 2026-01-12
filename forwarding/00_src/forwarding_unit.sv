`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/forwarding/00_src/constant.sv"
module forwarding_unit(
    //inputs
    input logic mem_rd_wren_i,
    input logic wb_rd_wren_i,
    input logic [4:0] mem_rd_addr_i,
    input logic [4:0] wb_rd_addr_i,
    input logic [4:0] ex_rs1_addr_i,
    input logic [4:0] ex_rs2_addr_i,
    //outputs
    output logic [1:0] forward_a_o,
    output logic [1:0] forward_b_o
);
    always_comb begin
        //default setting
        forward_a_o = `NO_FORWARDING;
        forward_b_o = `NO_FORWARDING;
        //forward a
        if ((mem_rd_wren_i) && (mem_rd_addr_i != 5'h0) && (mem_rd_addr_i == ex_rs1_addr_i)) begin
            forward_a_o = `MEMORY_FORWARDING;
        end
        else if ((wb_rd_wren_i) && (wb_rd_addr_i != 5'h0) && (wb_rd_addr_i == ex_rs1_addr_i)) begin
            forward_a_o = `WRITEBACK_FORWARDING;
        end
        //forward b
        if ((mem_rd_wren_i) && (mem_rd_addr_i != 5'h0) && (mem_rd_addr_i == ex_rs2_addr_i)) begin
            forward_b_o = `MEMORY_FORWARDING;
        end
        else if ((wb_rd_wren_i) && (wb_rd_addr_i != 5'h0) && (wb_rd_addr_i == ex_rs2_addr_i)) begin
            forward_b_o = `WRITEBACK_FORWARDING;
        end
    end
endmodule : forwarding_unit
