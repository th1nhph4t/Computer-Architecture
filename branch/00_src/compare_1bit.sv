/* verilator lint_off MULTITOP */
module compare_1bit (
    //input
    input   logic   a_i,
    input   logic   b_i,
    //output
    output  logic   equal_o,
    output  logic   alarger_o,
    output  logic   blarger_o
);
    assign equal_o    = a_i~^b_i;
    assign alarger_o  = a_i&(~b_i);
    assign blarger_o  = (~a_i)&b_i;

endmodule: compare_1bit
