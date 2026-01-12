/* verilator lint_off UNUSED */
module logic_shift_right_32bit(
    input logic [31:0] data_i, 
    input logic [4:0] shamt_i, // 5-bit shift amount
    output logic [31:0] data_o
);
    // Initialize the output
    logic [31:0] temp_data;

    always_comb begin
        // Start with the original data
        temp_data = data_i;
        // Shift right by 1 bit for each shift amount
        if (shamt_i[0]) temp_data = {1'b0, temp_data[31:1]};
        if (shamt_i[1]) temp_data = {2'b0, temp_data[31:2]};
        if (shamt_i[2]) temp_data = {4'b0, temp_data[31:4]};
        if (shamt_i[3]) temp_data = {8'b0, temp_data[31:8]};
        if (shamt_i[4]) temp_data = {16'b0, temp_data[31:16]};
    end

    // Assign the shifted data to the output
    assign data_o = temp_data;

endmodule : logic_shift_right_32bit
