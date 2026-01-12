/* verilator lint_off UNUSED */
module reg_file(
    ///Input Signal//
    input logic clk_i,
    input logic rst_ni,
    input logic rd_wren_i,
    ///Input Data//
    input logic [4:0] rs1_addr_i,
    input logic [4:0] rs2_addr_i,
    input logic [4:0] rd_addr_i,
    input logic [31:0] rd_data_i,
    ///Output Data//
    output logic [31:0] rs1_data_o,
    output logic [31:0] rs2_data_o
    );

///variable////
logic [31:0] memory [0:31];
logic Write;
logic CheckRd;

assign rs1_data_o = memory[rs1_addr_i];
assign rs2_data_o = memory[rs2_addr_i];
///Check if rd is equal to 0//
assign CheckRd = (|rd_addr_i); // Rd equal 0 : CheckRd = 0

///Conditon to write to memory//
assign Write = rd_wren_i & CheckRd;
///Main control//
always @(posedge clk_i)
    begin
       if (Write) begin 
           memory[0] <= 32'd0;
           memory[rd_addr_i] <= rd_data_i;
       end
       else 
           memory[0] <= 32'd0;
    end
endmodule 

