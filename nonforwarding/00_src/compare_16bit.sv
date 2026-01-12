/* verilator lint_off MULTITOP */
module compare_16bit (
    //input
    input   logic   [15:0]  a_i,
    input   logic   [15:0]  b_i,
    //output
    output  logic           equal_o,
    output  logic           alarger_o,
    output  logic           blarger_o
);
    // variable temple
    logic [3:0] eq_t;
    logic [3:0] al_t;
    logic unused_01,unused_02,unused_03,unused_04;
    assign equal_o   = &eq_t;
    assign alarger_o = al_t[3]|(al_t[2]&eq_t[3])|(al_t[1]&eq_t[3]&eq_t[2])|(al_t[0]&eq_t[3]&eq_t[2]&eq_t[1]);
    assign blarger_o = ~(equal_o|alarger_o);                
    compare_4bit compare10(.a_i(a_i[  3:0]),.b_i(b_i[  3:0]),.equal_o(eq_t[0]),.alarger_o(al_t[0]),.blarger_o(unused_01));
    compare_4bit compare11(.a_i(a_i[  7:4]),.b_i(b_i[  7:4]),.equal_o(eq_t[1]),.alarger_o(al_t[1]),.blarger_o(unused_02));
    compare_4bit compare12(.a_i(a_i[ 11:8]),.b_i(b_i[ 11:8]),.equal_o(eq_t[2]),.alarger_o(al_t[2]),.blarger_o(unused_03));
    compare_4bit compare13(.a_i(a_i[15:12]),.b_i(b_i[15:12]),.equal_o(eq_t[3]),.alarger_o(al_t[3]),.blarger_o(unused_04));                                                                                                                       
endmodule: compare_16bit
