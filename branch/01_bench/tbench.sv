`define RESETPERIOD 15
`define FINISH      50000

module tbench;

// Clock and reset generator
  logic i_clk;
  logic i_reset;

  initial tsk_clock_gen(i_clk);
  initial tsk_reset(i_reset, `RESETPERIOD);
  initial tsk_timeout(`FINISH);

// Wave dumping
  initial begin : proc_dump_wave
    $dumpfile("wave.vcd");
    $dumpvars(0, tbench);
  end

  logic [31:0]       i_io_sw  ;
  logic [31:0]       o_io_lcd ;
  logic [31:0]       o_io_ledg;
  logic [31:0]       o_io_ledr;
  logic [ 6:0]       o_io_hex0;
  logic [ 6:0]       o_io_hex1;
  logic [ 6:0]       o_io_hex2;
  logic [ 6:0]       o_io_hex3;
  logic [ 6:0]       o_io_hex4;
  logic [ 6:0]       o_io_hex5;
  logic [ 6:0]       o_io_hex6;
  logic [ 6:0]       o_io_hex7;

  logic [31:0]       o_pc_debug;
  logic              o_insn_vld;
 

  driver driver (
    .i_io_sw(i_io_sw),
    .i_clk(i_clk),
    .i_reset(i_reset)
  );

  singlecycle singlecycle (
    .io_sw_i(i_io_sw)  ,
    .io_lcd_o(o_io_lcd)  ,
	.io_ledg_o(o_io_ledg) ,
    .io_ledr_o(o_io_ledr) ,
    .io_hex0_o(o_io_hex0) ,
    .io_hex1_o(o_io_hex1) ,
    .io_hex2_o(o_io_hex2) ,
    .io_hex3_o(o_io_hex3) ,
    .io_hex4_o(o_io_hex4) ,
    .io_hex5_o(o_io_hex5) ,
    .io_hex6_o(o_io_hex6) ,
    .io_hex7_o(o_io_hex7) ,
    .o_pc_debug(o_pc_debug),
 	.o_insn_vld(o_insn_vld),
    .clk_i(i_clk),
    .rst_ni(i_reset)
  );


  scoreboard scoreboard (
    .i_io_sw(i_io_sw)   ,
    .o_io_lcd(o_io_lcd)   ,
    .o_io_ledg(o_io_ledg) ,
    .o_io_ledr(o_io_ledr) ,
    .o_io_hex0(o_io_hex0) ,
    .o_io_hex1(o_io_hex1) ,
    .o_io_hex2(o_io_hex2) ,
    .o_io_hex3(o_io_hex3) ,
    .o_io_hex4(o_io_hex4) ,
    .o_io_hex5(o_io_hex5) ,
    .o_io_hex6(o_io_hex6) ,
    .o_io_hex7(o_io_hex7) ,
    .o_pc_debug(o_pc_debug),
  	.o_insn_vld(o_insn_vld),
    .i_clk(i_clk),
    .i_reset(i_reset)
  );

endmodule : tbench
