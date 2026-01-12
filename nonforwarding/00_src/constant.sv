`ifndef CONSTANT
// Instruction opcodes field
`define OPCODE_LUI              5'b01101
`define OPCODE_AUIPC            5'b00101
`define OPCODE_JAL              5'b11011
`define OPCODE_JALR             5'b11001
`define OPCODE_BRANCH           5'b11000
`define OPCODE_LOAD             5'b00000
`define OPCODE_STORE            5'b01000
`define OPCODE_OP_IMM           5'b00100
`define OPCODE_OP               5'b01100

// Interpretations of the "funct3" field for loads and stores
`define FUNCT3_MEM_BYTE         3'b000
`define FUNCT3_MEM_HALF         3'b001
`define FUNCT3_MEM_WORD         3'b010
`define FUNCT3_MEM_BYTE_U       3'b100
`define FUNCT3_MEM_HALF_U       3'b101

// Interpretations of the "funct3" field for branches
`define FUNCT3_BRANCH_BEQ       3'b000
`define FUNCT3_BRANCH_BNE       3'b001
`define FUNCT3_BRANCH_BLT       3'b100
`define FUNCT3_BRANCH_BGE       3'b101
`define FUNCT3_BRANCH_BLTU      3'b110
`define FUNCT3_BRANCH_BGEU      3'b111

// ALU operations {inst [30], funct3}
`define ALU_ADD                 4'b0000
`define ALU_SUB                 4'b1000
`define ALU_SLL                 4'b0001
`define ALU_SLT                 4'b0010
`define ALU_SLTU                4'b0011
`define ALU_XOR                 4'b0100
`define ALU_SRL                 4'b0101
`define ALU_SRA                 4'b1101
`define ALU_OR                  4'b0110
`define ALU_AND                 4'b0111
`define ALU_RS2                 4'b1001

// Register data sources
`define CTL_WRITEBACK_ALU       2'b00
`define CTL_WRITEBACK_LOAD      2'b01
`define CTL_WRITEBACK_PC4       2'b10
`define CTL_WRITEBACK_IMM       2'b11

// ALU 1st operand source
`define CTL_ALU_A_RS1           1'b0
`define CTL_ALU_A_PC            1'b1

// ALU 2nd operand source
`define CTL_ALU_B_RS2           1'b0
`define CTL_ALU_B_IMM           1'b1

// PC source
`define CTL_PC_PC4              1'b0
`define CTL_PC_ALU_DATA         1'b1

`endif
