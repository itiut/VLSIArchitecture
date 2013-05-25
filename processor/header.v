/**
 * op code
 */
// I-style
`define OP_ADDI 6'd1
`define OP_LUI  6'd3
`define OP_ANDI 6'd4
`define OP_ORI  6'd5
`define OP_XORI 6'd6
`define OP_LW   6'd16
`define OP_LH   6'd18
`define OP_LB   6'd20
`define OP_SW   6'd24
`define OP_SH   6'd26
`define OP_SB   6'd28
`define OP_BEQ  6'd32
`define OP_BNE  6'd33
`define OP_BLT  6'd34
`define OP_BLE  6'd35

// A-style
`define OP_J    6'd40
`define OP_JAL  6'd41

// R-style
`define OP_R    6'd0           // use aux
`define OP_JR   6'd42


/**
 * alu control bits (R-style aux[4:0])
 */
`define ALU_ADD 5'd0
`define ALU_SUB 5'd2
`define ALU_AND 5'd8
`define ALU_OR  5'd9
`define ALU_XOR 5'd10
`define ALU_NOR 5'd11
`define ALU_SLL 5'd16
`define ALU_SRL 5'd17
`define ALU_SRA 5'd18


/**
 * memory access bits
 */
`define WORD     2'b11
`define HALFWORD 2'b10
`define BYTE     2'b01
