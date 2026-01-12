module instr_memory#(parameter SIZE = 4096)(
	input logic [31:0] i_addr,
    output logic [31:0] o_rdata
);
    logic [31:0] memory [0:SIZE-1];
    assign o_rdata = memory[i_addr[13:2]];
    initial begin 
        $readmemh("../02_test/dump/mem.dump", memory);
    end
endmodule : instr_memory
