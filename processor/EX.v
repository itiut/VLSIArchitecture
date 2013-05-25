`include "header.v"

module EX(input clk_in,
          input n_rst_in,
          input [31:0] IDEX_pc_in,
          input [31:0] IDEX_ir_in,
          input [31:0] IDEX_a_in,
          input [31:0] IDEX_b_in,
          input IDEX_ctrl_reg_dst_in,
          input IDEX_ctrl_alu_src_in,
          input IDEX_ctrl_branch_in,
          input [1:0] IDEX_ctrl_mem_read_in,
          input [1:0] IDEX_ctrl_mem_write_in,
          input IDEX_ctrl_reg_write_in,
          input IDEX_ctrl_mem_to_reg_in,
          input [4:0] MEMWB_rd_in,
          output reg [31:0] EXMEM_pc_branch_out,
          output reg [31:0] EXMEM_alu_out,
          output reg EXMEM_alu_do_branch_out,
          output reg [31:0] EXMEM_b_out,
          output reg [4:0] EXMEM_rd_out,
          output reg EXMEM_ctrl_branch_out,
          output reg [1:0] EXMEM_ctrl_mem_read_out,
          output reg [1:0] EXMEM_ctrl_mem_write_out,
          output reg EXMEM_ctrl_reg_write_out,
          output reg EXMEM_ctrl_mem_to_reg_out);

    wire [5:0] op;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shift;
    wire [4:0] aux;
    wire [31:0] imm_dpl;
    wire [25:0] addr;

    assign op = IDEX_ir_in[31:26];
    assign rs = IDEX_ir_in[25:21];
    assign rt = IDEX_ir_in[20:16];
    assign rd = IDEX_ir_in[15:11];
    assign shift = IDEX_ir_in[10:6];
    assign aux = IDEX_ir_in[4:0];
    assign imm_dpl = {{16{IDEX_ir_in[15]}}, IDEX_ir_in[15:0]};
    assign addr = IDEX_ir_in[25:0];

    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] alu_out;
    wire alu_zero;
    wire alu_sign;
    wire alu_do_branch_out;

    assign a = alu_a(IDEX_a_in);
    assign b = alu_b(IDEX_b_in, imm_dpl, IDEX_ctrl_alu_src_in);
    assign alu_out = (op == `OP_LUI) ? (imm_dpl << 16) :
                     (op == `OP_JAL) ? IDEX_pc_in :
                     alu(alu_ctrl(op, aux),
                         a,
                         b,
                         shift);
    assign alu_zero = ~|alu_out;
    assign alu_sign = alu_out[31];
    assign alu_do_branch_out = alu_do_branch(op,
                                             alu_zero,
                                             alu_sign);

    wire [31:0] pc_branch_out;
    assign pc_branch_out = pc_branch(op,
                                     IDEX_pc_in,
                                     imm_dpl,
                                     addr,
                                     a);

    wire [4:0] rd_out;
    assign rd_out = (op == `OP_JAL) ? 5'd31 :
                    (IDEX_ctrl_reg_dst_in) ? rd : rt;

    always @(negedge n_rst_in or posedge clk_in) begin
        if (~n_rst_in) begin
            EXMEM_pc_branch_out <= 0;
            EXMEM_alu_out <= 0;
            EXMEM_alu_do_branch_out <= 0;
            EXMEM_b_out <= 0;
            EXMEM_rd_out <= 0;
            EXMEM_ctrl_branch_out <= 0;
            EXMEM_ctrl_mem_read_out <= 0;
            EXMEM_ctrl_mem_write_out <= 0;
            EXMEM_ctrl_reg_write_out <= 0;
            EXMEM_ctrl_mem_to_reg_out <= 0;
        end else if (clk_in) begin
            EXMEM_pc_branch_out <= pc_branch_out;
            EXMEM_alu_out <= alu_out;
            EXMEM_alu_do_branch_out <= alu_do_branch_out;
            EXMEM_b_out <= IDEX_b_in;
            EXMEM_rd_out <= rd_out;
            EXMEM_ctrl_branch_out <= IDEX_ctrl_branch_in;
            EXMEM_ctrl_mem_read_out <= IDEX_ctrl_mem_read_in;
            EXMEM_ctrl_mem_write_out <= IDEX_ctrl_mem_write_in;
            EXMEM_ctrl_reg_write_out <= IDEX_ctrl_reg_write_in;
            EXMEM_ctrl_mem_to_reg_out <= IDEX_ctrl_mem_to_reg_in;
        end
    end

    function [31:0] pc_branch;
        input [5:0] op;
        input [31:0] pc;
        input [31:0] imm_dpl;
        input [25:0] addr;
        input [31:0] a;
        case (op)
            `OP_BEQ, `OP_BNE, `OP_BLT, `OP_BLE: pc_branch = pc + (imm_dpl << 2);
            `OP_J, `OP_JAL: pc_branch = {6'b0, addr};
            `OP_JR: pc_branch = a;
            default: pc_branch = pc;
        endcase
    endfunction

    function [4:0] alu_ctrl;
        input [5:0] op;
        input [4:0] aux;
        case (op)
            `OP_R:    alu_ctrl = aux;
            `OP_ADDI: alu_ctrl = `ALU_ADD;
            `OP_ANDI: alu_ctrl = `ALU_AND;
            `OP_ORI:  alu_ctrl = `ALU_OR;
            `OP_XORI: alu_ctrl = `ALU_XOR;
            `OP_BEQ, `OP_BNE, `OP_BLT, `OP_BLE: alu_ctrl = `ALU_SUB;
            `OP_LW, `OP_LH, `OP_LB, `OP_SW, `OP_SH, `OP_SB: alu_ctrl = `ALU_ADD;
            default:  alu_ctrl = 5'h1f;
        endcase
    endfunction

    function [31:0] alu_a;
        input [31:0] IDEX_a;
        alu_a = IDEX_a;
    endfunction

    function [31:0] alu_b;
        input [31:0] IDEX_b;
        input [31:0] imm_dpl;
        input ctrl_alu_src;
        if (ctrl_alu_src) begin
            alu_b = imm_dpl;
        end else begin
            alu_b = IDEX_b;
        end
    endfunction

    function [31:0] alu;
        input [4:0] ctrl;
        input [31:0] a;
        input [31:0] b;
        input [4:0] shift;
        case (ctrl)
            `ALU_ADD: alu = a + b;
            `ALU_SUB: alu = a - b;
            `ALU_AND: alu = a & b;
            `ALU_OR:  alu = a | b;
            `ALU_XOR: alu = a ^ b;
            `ALU_NOR: alu = ~(a | b);
            `ALU_SLL: alu = a << shift;
            `ALU_SRL: alu = a >> shift;
            `ALU_SRA: alu = {{32{a[31]}}, a} >> shift;
            default:  alu = 32'hffffffff;
        endcase
    endfunction

    // TODO: move to ID stage
    function alu_do_branch;
        input [5:0] op;
        input alu_zero;
        input alu_sign;
        case (op)
            `OP_BEQ: alu_do_branch = alu_zero;
            `OP_BNE: alu_do_branch = ~alu_zero;
            `OP_BLT: alu_do_branch = alu_sign;
            `OP_BLE: alu_do_branch = alu_zero | alu_sign;
            `OP_J, `OP_JAL, `OP_JR: alu_do_branch = 1;
            default: alu_do_branch = 0;
        endcase
    endfunction

endmodule
