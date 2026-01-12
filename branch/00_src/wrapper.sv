module wrapper (
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
    logic [6:0] io_hex0_o;
    logic [6:0] io_hex1_o;
    logic [6:0] io_hex2_o;
    logic [6:0] io_hex3_o;
    logic [6:0] io_hex4_o;
    logic [6:0] io_hex5_o;
    logic [6:0] io_hex6_o;
    logic [6:0] io_hex7_o;
    logic [31:0] io_sw_i; // Đầu vào công tắc

    // Kết nối đầu ra với module singlecycle
    assign LEDG = io_ledg[7:0];
    assign LEDR = io_ledr[16:0];
    
    // Kết nối các tín hiệu HEX
    assign HEX0 = io_hex0_o[6:0];
    assign HEX1 = io_hex1_o[6:0];
    assign HEX2 = io_hex2_o[6:0];
    assign HEX3 = io_hex3_o[6:0];
    assign HEX4 = io_hex4_o[6:0];
    assign HEX5 = io_hex5_o[6:0];
    assign HEX6 = io_hex6_o[6:0];
    assign HEX7 = io_hex7_o[6:0];

    // Kết nối LCD
    assign LCD_DATA = io_lcd[7:0]; // Chỉ sử dụng 8 bit
    assign LCD_EN = io_lcd[10]; // Giả định enable cho LCD
    assign LCD_RS = io_lcd[9]; // Giả định select chế độ lệnh
    assign LCD_RW = io_lcd[8]; // Giả định chế độ ghi
	 assign LCD_ON = io_lcd[31]; //power on
	 assign io_sw_i = {16'b0,SW[16:1]};
    // Instantiate the singlecycle module
    singlecycle singlecycle_inst (
        .clk_i(CLOCK_50),           // Đồng hồ
        .rst_ni(SW[0]),           // Reset (năng lượng thấp)
        .io_sw_i(io_sw_i),          // Công tắc vào
        .io_lcd_o   (io_lcd_o),
        .io_ledg_o  (io_ledg_o),
        .io_ledr_o  (io_ledr_o),
        .io_hex0_o  (io_hex0_o),
        .io_hex1_o  (io_hex1_o),
        .io_hex2_o  (io_hex2_o),
        .io_hex3_o  (io_hex3_o),
        .io_hex4_o  (io_hex4_o),
        .io_hex5_o  (io_hex5_o),
        .io_hex6_o  (io_hex6_o),
        .io_hex7_o  (io_hex7_o)
    );

endmodule : wrapper