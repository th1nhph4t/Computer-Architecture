module arithmetic_shift_right_32bit(
    input logic [31:0] data_i,
    input logic [4:0] shamt_i, // 5-bit shift amount
    output logic [31:0] data_o
);
    // Initialize the output
    logic [31:0] temp_data;
    logic sign_bit;
    // Extract the sign bit from the input data
    assign sign_bit = data_i[31];
    always_comb begin
        // Start with the original data
        temp_data = data_i;
        // Perform shift operations based on the shift amount
        // Replicate the sign bit instead of inserting '0's
        if (shamt_i[0]) temp_data = {sign_bit, temp_data[31:1]};
        if (shamt_i[1]) temp_data = { {2{sign_bit}}, temp_data[31:2]};
        if (shamt_i[2]) temp_data = { {4{sign_bit}}, temp_data[31:4]};
        if (shamt_i[3]) temp_data = { {8{sign_bit}}, temp_data[31:8]};
        if (shamt_i[4]) temp_data = { {16{sign_bit}}, temp_data[31:16]};
    end
    // Assign the shifted data to the output
    assign data_o = temp_data;
endmodule
