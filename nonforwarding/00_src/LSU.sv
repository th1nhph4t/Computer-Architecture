module LSU (
  input logic clk_i, rst_ni, st_en_i,
  //input logic [2:0]  mem_op_i,
  input logic [31:0] addr_i,
  input logic [31:0] st_data_i,
  input logic [31:0] io_sw_i,
  //input logic [ 3:0] i_io_btn,
  output logic [31:0] ld_data_o,
  output logic [31:0] io_ledr_o,
  output logic [31:0] io_ledg_o,
  output logic [ 6:0] io_hex0_o, io_hex1_o, io_hex2_o, io_hex3_o, io_hex4_o, io_hex5_o, io_hex6_o, io_hex7_o,
  output logic [31:0] io_lcd_o);
//----Define logic signal-----//
logic IM_wren,DM_wren, ouput_wren;
logic [1:0] sel_addr; // chọn vùng địa chỉ
//----Define 3 trạng thái của 3 bit đầu chia vùng địa chỉ--------//
localparam sel_IM = 2'b00;
localparam sel_DM = 2'b01;
localparam sel_IO = 2'b11;
//----Define vùng nhớ -----------//
logic [31:0] instruction_memory [0:2047]; // 0x0000 - 0x1FFF (8192 địa chỉ)
logic [31:0] data_memory [0:2047]; // 0x2000 - 0x3FFF (8192 địa chỉ)   
logic [31:0] output_memory [0:15];        // 0x7000 - 0x703F (64 địa chỉ)
logic [31:0] switches_memory [0:3];      // 0x7800 - 0x780F (16 địa chỉ)
//----Define biến trung gian-----//
logic [31:0] data_IM, data_DM, data_input, data_output;
//------main-----//
//---IM = Instruction Memory; DM = Data Memory; IO = input output memory-----//
//-----Chọn địa chỉ-----//
always_comb case (addr_i[15:13]) // Sử dụng case để xác định vùng bộ nhớ
                3'b000: sel_addr = sel_IM; // Instruction memory
                3'b001: sel_addr = sel_DM;        // Data memory
                3'b011: sel_addr = sel_IO;       // IO memory
                default: begin
                sel_addr = 0;
                end
            endcase
always_comb begin
          if (!st_en_i) begin
            case (sel_addr)
            sel_IM: ld_data_o = data_IM;
            sel_DM: ld_data_o = data_DM;
            sel_IO: if (addr_i[11]) ld_data_o = data_input; //---- Nếu bit 11 là bit 1 thì địa chỉ là 0x78xx còn nếu bit 11 là 0 địa chỉ là 0x70xx
                  else ld_data_o = data_output;
            default: begin
                        ld_data_o = 0;
                  end
            endcase
          end
          else ld_data_o = 0;
          end
//--------INSTRUCTION MEMORY----------//
//----Read from instruction memory----//
assign data_IM = instruction_memory[addr_i[12:2]];
//---Write to instruction memory-----//
assign IM_wren = (sel_addr==sel_IM)&st_en_i; // Tín hiệu chọn ghi vào vùng instruction_memory khi địa chỉ được chọn nằm trong vùng instruction_memory và tín hiệu write được bật
always_ff @(posedge clk_i or negedge rst_ni) 
			begin
				if (!rst_ni) instruction_memory <= '{default: 0};
				else if (IM_wren) begin
					instruction_memory[addr_i[12:2]] <= st_data_i;
					end
			end

//--------DATA MEMORY----------//
//----Read from data memory----//
assign data_DM = data_memory[addr_i[12:2]];
//---Write to data memory-----//

assign DM_wren = (sel_addr==sel_DM)&st_en_i; // Tín hiệu chọn ghi vào vùng instruction_memory khi địa chỉ được chọn nằm trong vùng instruction_memory và tín hiệu write được bật
always_ff @(posedge clk_i or negedge rst_ni)
      begin
        if (!rst_ni) data_memory <= '{default: 0};
        else if (DM_wren) begin
          data_memory[addr_i[12:2]] <= st_data_i;
          end
      end
//--------IO MEMORY----------//
//--------INPUT MEMORY (switches)--------//
//----Read from switches memory----//
assign data_input = switches_memory[addr_i[3:2]]; // 16 ô nhớ, mỗi ô 8 bit gom thành 4 ô nhớ, mỗi ô 32 bit, do không lấy 2 bit cuối (1,0) vì nó cách nhau vừa đủ 4 ô nhớ, nên xét 2 bit trên là (3,2)
//---Update to switches memory-----//
always_ff @(posedge clk_i or negedge rst_ni)
      begin
		if (!rst_ni) switches_memory <= '{default: 0};
        else switches_memory[addr_i[3:2]] <= io_sw_i;
      end
//--------OUTPUT MEMORY--------//
//----Read from output memory----//
assign data_output = output_memory[addr_i[5:2]];
//---Connect output_memory to ouput ports--------//
assign io_ledr_o = output_memory[0];
assign io_ledg_o = output_memory[4];
assign io_hex0_o = output_memory[8][6:0];
assign io_hex1_o = output_memory[8][14:8];
assign io_hex2_o = output_memory[8][22:16];
assign io_hex3_o = output_memory[8][30:24];
assign io_hex4_o = output_memory[9][6:0];
assign io_hex5_o = output_memory[9][14:8];
assign io_hex6_o = output_memory[9][22:16];
assign io_hex7_o = output_memory[9][30:24];
assign io_lcd_o  = output_memory[12];
//----Write to ouput memory-----------//
assign ouput_wren = (sel_addr==sel_IO)&st_en_i&(!addr_i[11]); // Tín hiệu chọn ghi vào vùng output_memory khi địa chỉ được chọn nằm trong vùng instruction_memory và tín hiệu write được bật
always_ff @(posedge clk_i or negedge rst_ni)
      begin
        if (!rst_ni) output_memory <= '{default: 0};
        else if (ouput_wren) begin
          output_memory[addr_i[5:2]] <= st_data_i;
          end
      end
endmodule

