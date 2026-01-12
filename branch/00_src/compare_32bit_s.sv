/* verilator lint_off MULTITOP */
module compare_32bit_s (
    //input
    input logic [31:0] a_i,
    input logic [31:0] b_i,
    //output
    output logic equal_o,
    output logic alarger_o,
    output logic blarger_o
);
    logic [1:0] eq_t;
    logic [1:0] al_t;
    logic [1:0] bl_t;
    logic [31:0] a_t;
    logic [31:0] b_t;
    logic unused_01,unused_02,unused_03,unused_04;
    assign a_t = ~(a_i)+1;
    assign b_t = ~(b_i)+1;
    compare_32bit_u compare32u_0(.a_i(a_i[31:0]),.b_i(b_i[31:0]),.equal_o(eq_t[0]),.alarger_o(al_t[0]),.blarger_o(bl_t[0]));
    compare_32bit_u compare32u_1(.a_i(a_t[31:0]),.b_i(b_t[31:0]),.equal_o(eq_t[1]),.alarger_o(al_t[1]),.blarger_o(bl_t[1]));
    always_comb begin 
        case({a_i[31],b_i[31]})
        2'b00:  begin 
            equal_o     =   eq_t[0];
            alarger_o   =   al_t[0];
            blarger_o   =   bl_t[0];
        end
        2'b01:  begin 
            equal_o     =   1'b0;
            alarger_o   =   1'b1;
            blarger_o   =   1'b0;
        end
        2'b10:  begin 
            equal_o     =   1'b0;
            alarger_o   =   1'b0;
            blarger_o   =   1'b1;
        end
        2'b11:  begin 
            equal_o     =   eq_t[1];
            alarger_o   =   ~al_t[1];
            blarger_o   =   ~bl_t[1];
        end
        default: begin 
        end 
        endcase
    end
endmodule: compare_32bit_s
