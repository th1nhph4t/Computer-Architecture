/* verilator lint_off UNUSED */
module instr_memory#(parameter SIZE = 4096)(
    input logic clk_i,
    input logic rst_ni,
    input logic [31:0] addr_i,
    output logic [31:0] rdata_o
);
    logic [31:0] memory [0:SIZE-1];
    assign rdata_o = memory[addr_i[13:2]];
    initial begin 
        $readmemh("../02_test/dump/mem.dump",memory);
    end
endmodule : instr_memory
