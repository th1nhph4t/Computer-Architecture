module lsu (
	input logic i_clk,i_rst_n, i_lsu_wren,
	input logic [31:0] i_lsu_addr,
	input logic [31:0] i_st_data,
	input logic [31:0] i_io_sw,
	//input logic [ 3:0] i_io_btn,
	output logic [31:0] o_ld_data,
	output logic [31:0] o_io_ledr,
	output logic [31:0] o_io_ledg,
	output logic [ 6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7,
	output logic [31:0] o_io_lcd);
//----Define logic signal-----//
logic IM_wren, DM_wren, ouput_wren;
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
always_comb case (i_lsu_addr[15:13]) // Sử dụng case để xác định vùng bộ nhớ
                3'b000: sel_addr = sel_IM; // Instruction memory
                3'b001: sel_addr = sel_DM;        // Data memory
                3'b011: sel_addr = sel_IO;       // IO memory
                default: begin
								sel_addr = 0;
                end
            endcase
always_comb begin 
					if (!i_lsu_wren) begin
						case (sel_addr)
						sel_IM: o_ld_data = data_IM;
						sel_DM: o_ld_data = data_DM;
						sel_IO: if (i_lsu_addr[11]) o_ld_data = data_input; //---- Nếu bit 11 là bit 1 thì địa chỉ là 0x78xx còn nếu bit 11 là 0 địa chỉ là 0x70xx
								  else o_ld_data = data_output;
						default: begin
											  o_ld_data = 0;
									end
						endcase
					end
					else o_ld_data = 0;
					end
//--------INSTRUCTION MEMORY----------//
//----Read from instruction memory----//
assign data_IM = instruction_memory[i_lsu_addr[12:2]];
//---Write to instruction memory-----//
assign IM_wren = (sel_addr==sel_IM)&i_lsu_wren; // Tín hiệu chọn ghi vào vùng instruction_memory khi địa chỉ được chọn nằm trong vùng instruction_memory và tín hiệu write được bật
always_ff @(posedge i_clk or negedge i_rst_n) 
			begin
				if (!i_rst_n) instruction_memory <= '{default: 0};
				else if (IM_wren) begin
					instruction_memory[i_lsu_addr[12:2]] <= i_st_data;
					end
			end
//--------DATA MEMORY----------//
//----Read from data memory----//
assign data_DM = data_memory[i_lsu_addr[12:2]];
//---Write to data memory-----//
assign DM_wren = (sel_addr==sel_DM)&i_lsu_wren; // Tín hiệu chọn ghi vào vùng instruction_memory khi địa chỉ được chọn nằm trong vùng instruction_memory và tín hiệu write được bật
always_ff @(posedge i_clk or negedge i_rst_n) 
			begin
				if (!i_rst_n) data_memory <= '{default: 0};
				else if (DM_wren) begin
					data_memory[i_lsu_addr[12:2]] <= i_st_data;
					end
			end
//--------IO MEMORY----------//
//--------INPUT MEMORY (switches)--------//
//----Read from switches memory----//
assign data_input = switches_memory[i_lsu_addr[3:2]]; // 16 ô nhớ, mỗi ô 8 bit gom thành 4 ô nhớ, mỗi ô 32 bit, do không lấy 2 bit cuối (1,0) vì nó cách nhau vừa đủ 4 ô nhớ, nên xét 2 bit trên là (3,2)
//---Update to switches memory-----//
always_ff @(posedge i_clk or negedge i_rst_n)
			begin
				if (!i_rst_n) switches_memory <= '{default: 0};
				else switches_memory[i_lsu_addr[3:2]] <= i_io_sw;
			end
//--------OUTPUT MEMORY--------//
//----Read from output memory----//
assign data_output = output_memory[i_lsu_addr[5:2]];
//---Connect output_memory to ouput ports--------//
assign o_io_ledr = output_memory[0];
assign o_io_ledg = output_memory[4];
assign o_io_hex0 = output_memory[8][6:0];
assign o_io_hex1 = output_memory[8][14:8];
assign o_io_hex2 = output_memory[8][22:16];
assign o_io_hex3 = output_memory[8][30:24];
assign o_io_hex4 = output_memory[9][6:0];
assign o_io_hex5 = output_memory[9][14:8];
assign o_io_hex6 = output_memory[9][22:16];
assign o_io_hex7 = output_memory[9][30:24];
assign o_io_lcd  = output_memory[12];
//----Write to ouput memory-----------//
assign ouput_wren = (sel_addr==sel_IO)&i_lsu_wren&(!i_lsu_addr[11]); // Tín hiệu chọn ghi vào vùng instruction_memory khi địa chỉ được chọn nằm trong vùng instruction_memory và tín hiệu write được bật
always_ff @(posedge i_clk or negedge i_rst_n) 
			begin
				if (!i_rst_n) output_memory <= '{default: 0};
				else if (ouput_wren) begin
					output_memory[i_lsu_addr[5:2]] <= i_st_data;
					end
			end
endmodule			
