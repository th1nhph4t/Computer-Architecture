module compare_4bit (
    //input
    input logic [3:0] a_i,
    input logic [3:0] b_i,
    //output
    output logic equal_o,
    output logic alarger_o,
    output logic blarger_o
);
    // variable temple
    logic [3:0] eq_t;
    logic [3:0] al_t;
    logic unused_01,unused_02,unused_03,unused_04;
    assign equal_o    = &eq_t;
    assign alarger_o  = al_t[3]|(al_t[2]&eq_t[3])|(al_t[1]&eq_t[3]&eq_t[2])|(al_t[0]&eq_t[3]&eq_t[2]&eq_t[1]);
    assign blarger_o  = ~(equal_o|alarger_o);                
    compare_1bit compare10(.a_i(a_i[0]),.b_i(b_i[0]),.equal_o(eq_t[0]),.alarger_o(al_t[0]),.blarger_o(unused_01));
    compare_1bit compare11(.a_i(a_i[1]),.b_i(b_i[1]),.equal_o(eq_t[1]),.alarger_o(al_t[1]),.blarger_o(unused_02));
    compare_1bit compare12(.a_i(a_i[2]),.b_i(b_i[2]),.equal_o(eq_t[2]),.alarger_o(al_t[2]),.blarger_o(unused_03));
    compare_1bit compare13(.a_i(a_i[3]),.b_i(b_i[3]),.equal_o(eq_t[3]),.alarger_o(al_t[3]),.blarger_o(unused_04));                                                                                                          
endmodule: compare_4bit
