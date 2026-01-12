module singlecycle_wrapper (
    // Inputs
    input wire CLOCK_50,            // Clock từ kit
    input wire [17:0] SW,            // Công tắc (SW)
    
    // Outputs
    output wire [6:0] HEX0,         // HEX0
    output wire [6:0] HEX1,         // HEX1
    output wire [6:0] HEX2,         // HEX2
    output wire [6:0] HEX3,         // HEX3
    output wire [6:0] HEX4,         // HEX4
    output wire [6:0] HEX5,         // HEX5
    output wire [6:0] HEX6,         // HEX6
    output wire [6:0] HEX7,         // HEX7
    output wire [9:0] LEDG,         // LEDG
    output wire [17:0] LEDR,        // LEDR
    output wire [7:0] LCD_DATA,	 // LCD Data
	 output wire LCD_ON,           	 // LCD_ON
    output wire LCD_EN,              // LCD Enable
    output wire LCD_RS,              // LCD Register Select
    output wire LCD_RW               // LCD Read/Write
);

    // Signals
    logic [31:0] io_lcd;
    logic [31:0] io_ledg;
    logic [31:0] io_ledr;
    logic [6:0] o_io_hex0;
    logic [6:0] o_io_hex1;
    logic [6:0] o_io_hex2;
    logic [6:0] o_io_hex3;
    logic [6:0] o_io_hex4;
    logic [6:0] o_io_hex5;
    logic [6:0] o_io_hex6;
    logic [6:0] o_io_hex7;
    logic [31:0] o_io_sw; // Đầu vào công tắc

    // Kết nối đầu ra với module singlecycle
    assign LEDG = io_ledg[7:0];
    assign LEDR = io_ledr[16:0];
    
    // Kết nối các tín hiệu HEX
    assign HEX0 = o_io_hex0[6:0];
    assign HEX1 = o_io_hex1[6:0];
    assign HEX2 = o_io_hex2[6:0];
    assign HEX3 = o_io_hex3[6:0];
    assign HEX4 = o_io_hex4[6:0];
    assign HEX5 = o_io_hex5[6:0];
    assign HEX6 = o_io_hex6[6:0];
    assign HEX7 = o_io_hex7[6:0];

    // Kết nối LCD
    assign LCD_DATA = io_lcd[7:0]; // Chỉ sử dụng 8 bit
    assign LCD_EN = io_lcd[10]; // Giả định enable cho LCD
    assign LCD_RS = io_lcd[9]; // Giả định select chế độ lệnh
    assign LCD_RW = io_lcd[8]; // Giả định chế độ ghi
	 assign LCD_ON = io_lcd[31]; //power on
	 assign o_io_sw = {16'b0,SW[16:1]};
    // Instantiate the singlecycle module
    singlecycle singlecycle_inst (
        .i_clk(CLOCK_50),           // Đồng hồ
        .i_rst_n(SW[0]),           // Reset (năng lượng thấp)
        .i_io_sw(o_io_sw),          // Công tắc vào
        .o_io_lcd(io_lcd),        // Đầu ra LCD
        .o_io_ledg(io_ledg),      // Đầu ra LEDG
        .o_io_ledr(io_ledr),      // Đầu ra LEDR
        .o_io_hex0(o_io_hex0),      // Đầu ra HEX0
        .o_io_hex1(o_io_hex1),      // Đầu ra HEX1
        .o_io_hex2(o_io_hex2),      // Đầu ra HEX2
        .o_io_hex3(o_io_hex3),      // Đầu ra HEX3
        .o_io_hex4(o_io_hex4),      // Đầu ra HEX4
        .o_io_hex5(o_io_hex5),      // Đầu ra HEX5
        .o_io_hex6(o_io_hex6),      // Đầu ra HEX6
        .o_io_hex7(o_io_hex7),      // Đầu ra HEX7
        .o_pc_debug(),              // Chưa sử dụng
        .o_insn_vld()               // Chưa sử dụng
    );

endmodule : singlecycle_wrapper
