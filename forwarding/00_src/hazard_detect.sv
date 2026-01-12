`include "/earth/class/comparch/01_submission/ee3043/ca131/milestone_2/forwarding/00_src/constant.sv"
/* verilator lint_off UNUSED */
module hazard_detect(
    //inputs
    input logic br_sel_i,
    input logic id_is_rs2_i,
    input logic ex_is_rs2_i,
    input logic ex_is_load_i,
    input logic mem_is_load_i,
    input logic wb_is_load_i,
    input logic ex_rd_wren_i,
    input logic mem_rd_wren_i,
    input logic wb_rd_wren_i,
    input logic [4:0] ex_rs1_addr_i,
    input logic [4:0] ex_rs2_addr_i,
    input logic [4:0] ex_rd_addr_i,
    input logic [4:0] mem_rd_addr_i,
    input logic [4:0] wb_rd_addr_i,
    input logic [4:0] id_rs1_addr_i,
    input logic [4:0] id_rs2_addr_i,
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
    logic hazard_1,hazard_2,hazard_3;
    //Hazard 1: structure hazard => Read data of rs1 or rs2 from regfile and Write data of rd into regfile from write back stage
    assign hazard_1 = (wb_rd_wren_i)  && (wb_rd_addr_i != 5'h0)  && ((wb_rd_addr_i == id_rs1_addr_i)  || ((wb_rd_addr_i == id_rs2_addr_i)  && (id_is_rs2_i)));
    //Hazard 2: data hazard => result of rd data in execute stage relate to data of rs1 or rs2 in decode stage (load instruction)
    assign hazard_2 = (ex_rd_wren_i)  && (ex_rd_addr_i != 5'h0)  && (ex_is_load_i)          
                      && ((ex_rd_addr_i == id_rs1_addr_i)  || ((ex_rd_addr_i == id_rs2_addr_i)  && (id_is_rs2_i)));
    //Hazard 3: data hazard => result of rd data in execuate stage and result of rd data in memory stage of load instruction relate to data of rs1 or rs2 in decode stage (load instruction)
    assign hazard_3 = (ex_is_load_i) && (mem_is_load_i) && (ex_rd_wren_i) && (mem_rd_wren_i) && (ex_rd_addr_i != 5'h0) && (mem_rd_addr_i != 5'h0)
                      && ((ex_rd_addr_i == id_rs1_addr_i)  || ((ex_rd_addr_i == id_rs2_addr_i)  && (id_is_rs2_i)))
                      && ((mem_rd_addr_i == id_rs1_addr_i) || ((mem_rd_addr_i == id_rs2_addr_i) && (id_is_rs2_i)));
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
        //hazard setting => delay
        if (hazard_1 || hazard_2 || hazard_3) begin
            ex_reset_no = 1'b0;
            id_enable_o = 1'b0;
            pc_enable_o = br_sel_i;
        end
        //Jump-Branch instruction => delete instruction
        if (br_sel_i) begin
            id_reset_no = 1'b0;
            ex_reset_no = 1'b0;
        end
    end
endmodule : hazard_detect
