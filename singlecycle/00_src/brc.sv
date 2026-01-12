module brc(
    //inputs
    input logic [31:0] i_rs1_data,
    input logic [31:0] i_rs2_data,
    input logic i_br_un, //1 if the two operands are signed, 0 if unsigned
    //outputs
    output logic o_br_less,  //1 if rs1 < rs2
    output logic o_br_equal //1 if rs1 = rs2
);

////Variable for compare//
logic [32:0] sub_unsigned; // unsign
logic [31:0] sub_signed; // sign
logic same_sign;
//Mathematical operation for comparison process//
assign sub_unsigned = {1'b0,i_rs1_data} + (~{1'b0,i_rs2_data} + 33'd1); // rs1 - rs2, signed extension because the result of the subtraction may be overflow
assign sub_signed = i_rs1_data + ((~i_rs2_data) + 32'd1);

///rs1 equal rs2///
assign o_br_equal =  ~(|(i_rs1_data ^ i_rs2_data)); // Xor 2 numbers to check if they are equal, if they are equal the result of OR result bit is 0, not the result we have the signal = 1 if 2 numbers are equal

///Variable to check for case with same sign ////
assign same_sign = i_rs1_data[31] ^ i_rs2_data[31];
/////compare unsign///
always_comb
    begin 
       if (i_br_un) begin 
            if (same_sign) //// 1 : difference, 0 : same
                o_br_less = i_rs1_data[31]?(1'b1):(1'b0); // if 2 numbers don't have the same sign bit, the number is negative is less
            else
                o_br_less = sub_signed[31]?(1'b1):(1'b0); 
       end
       else begin 
            if (sub_unsigned[32])
                o_br_less = 1'b1;
            else 
                o_br_less = 1'b0;
       end   
    end
endmodule  : brc
