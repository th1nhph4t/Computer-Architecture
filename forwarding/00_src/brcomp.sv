/* verilator lint_off UNUSED */
module brcomp(
    //input
    input   logic [31:0]  instr_i,
    input   logic [31:0]  operand_a_i,
    input   logic [31:0]  operand_b_i,
    input   logic         br_unsigned_i,
    //output
    output  logic         br_sel_o
);
    logic unused_01,unused_02;
    logic br_less_u;
    logic br_less_s;
    logic br_equal_u;
    logic br_equal_s;
    logic br_less;
    logic br_equal;
    compare_32bit_u compare32_u(
        .a_i(operand_a_i),
        .b_i(operand_b_i),
        .equal_o(br_equal_u),
        .alarger_o(unused_01),    
        .blarger_o(br_less_u)
    );
    compare_32bit_s compare32_s(
        .a_i(operand_a_i),
        .b_i(operand_b_i),
        .equal_o(br_equal_s),
        .alarger_o(unused_02),    
        .blarger_o(br_less_s)
    );
    always_comb
      if(instr_i[6:2] == 5'b11000) //func7
        case(instr_i [14:12]) //func3
          3'b000: //BEQ
            br_sel_o = br_equal;
          3'b001: //BNE
            br_sel_o = !br_equal;           
          3'b100: //BLT
            br_sel_o = br_less;
          3'b101: //BGE
            br_sel_o = (br_equal | !br_less);          
          3'b110: //BLTU
            br_sel_o = br_less;                 
          3'b111: //BGEU
            br_sel_o = (br_equal | !br_less);                       
          default: //BEQ
            br_sel_o = 1'b0;                
        endcase
      else if(instr_i[6:2] == 5'b11011 || instr_i[6:2] == 5'b11001) 
             br_sel_o = 1'b1;
      else br_sel_o = 1'b0;
      
assign br_less  = (br_unsigned_i)? br_less_u :br_less_s;
assign br_equal = (br_unsigned_i)? br_equal_u:br_equal_s;
endmodule : brcomp
