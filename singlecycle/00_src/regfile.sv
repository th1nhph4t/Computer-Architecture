module regfile(
    input logic i_clk,
    input logic i_rst_n,
    input logic [4:0] i_rs1_addr,
    input logic [4:0] i_rs2_addr,
    input logic [4:0] i_rd_addr,
    input logic [31:0] i_rd_data,
	 input logic i_rd_wren,
    output logic [31:0] o_rs1_data,
    output logic [31:0] o_rs2_data
    );

//----Define biến trung gian-----//
logic [31:0] memory [0:31];
logic write;
logic not_reg0;

assign o_rs1_data = memory[i_rs1_addr]; // assign thẳng địa chỉ để đọc
assign o_rs2_data = memory[i_rs2_addr];

assign not_reg0 = (|i_rd_addr); // or hết các bit trong biến địa chỉ lại, nếu khác reg 0 thì tín hiệu này auto lên 1, nếu là reg 0 thì nó bằng 0

///Conditon to write to memory//
assign write = i_rd_wren & not_reg0; // lên 1 khi có tín hiệu ghi và thanh ghi cần ghi không phải reg 0
///-----Main-----//
always @(posedge i_clk or negedge i_rst_n)
    begin
		if (!i_rst_n)
			memory <= '{default :0};
      else if (write) begin 
           memory[0] <= 32'd0;
           memory[i_rd_addr] <= i_rd_data;
		end 
    end
endmodule 

