`include "header.v"

module EX(input clk_i,
          input n_rst_i,
          input [31:0] IDEX_pc_i,
          input [31:0] IDEX_ir_i,
          input [31:0] IDEX_a_i,
          input [31:0] IDEX_b_i,
          input IDEX_ctrl_reg_dst_i,
          input IDEX_ctrl_alu_src_i,
          input IDEX_ctrl_branch_i,
          input [1:0] IDEX_ctrl_mem_read_i,
          input [1:0] IDEX_ctrl_mem_write_i,
          input IDEX_ctrl_reg_write_i,
          input IDEX_ctrl_mem_to_reg_i,
          input MEM_do_branch_i,
          input [4:0] WB_reg_write_address_i,
          input [31:0] WB_reg_write_data_i,
          input WB_ctrl_reg_write_i,
          output reg [31:0] EXMEM_pc_branched_o,
          output reg [31:0] EXMEM_alu_o,
          output reg EXMEM_alu_do_branch_o,
          output reg [31:0] EXMEM_b_o,
          output reg [4:0] EXMEM_reg_write_address_o,
          output reg EXMEM_ctrl_branch_o,
          output reg [1:0] EXMEM_ctrl_mem_read_o,
          output reg [1:0] EXMEM_ctrl_mem_write_o,
          output reg EXMEM_ctrl_reg_write_o,
          output reg EXMEM_ctrl_mem_to_reg_o);

    wire [5:0] _op;
    wire [4:0] _rs;
    wire [4:0] _rt;
    wire [4:0] _rd;
    wire [4:0] _shift;
    wire [4:0] _aux;
    wire [31:0] _imm_dpl;
    wire [25:0] _addr;

    assign _op = IDEX_ir_i[31:26];
    assign _rs = IDEX_ir_i[25:21];
    assign _rt = IDEX_ir_i[20:16];
    assign _rd = IDEX_ir_i[15:11];
    assign _shift = IDEX_ir_i[10:6];
    assign _aux = IDEX_ir_i[4:0];
    assign _imm_dpl = {{16{IDEX_ir_i[15]}}, IDEX_ir_i[15:0]};
    assign _addr = IDEX_ir_i[25:0];

    wire [31:0] _a;
    wire [31:0] _b;
    wire [31:0] _alu_b;
    wire [31:0] _alu;
    wire _alu_zero;
    wire _alu_sign;
    wire _alu_do_branch;

    assign _a = forward_mux(IDEX_a_i,
                            _forward_a,
                            EXMEM_alu_o,
                            WB_reg_write_data_i);
    assign _b = forward_mux(IDEX_b_i,
                            _forward_b,
                            EXMEM_alu_o,
                            WB_reg_write_data_i);
    assign _alu_b = alu_b(_b,
                          _imm_dpl,
                          IDEX_ctrl_alu_src_i);

    assign _alu = (_op == `OP_LUI) ? (_imm_dpl << 16) :
                  (_op == `OP_JAL) ? IDEX_pc_i :
                  alu(alu_ctrl(_op, _aux),
                      _a,
                      _alu_b,
                      _shift);
    assign _alu_zero = ~|_alu;
    assign _alu_sign = _alu[31];
    assign _alu_do_branch = alu_do_branch(_op,
                                          _alu_zero,
                                          _alu_sign);

    wire [31:0] _pc_branched;
    assign _pc_branched = pc_branched(_op,
                                      IDEX_pc_i,
                                      _imm_dpl,
                                      _addr,
                                      _a);

    wire [4:0] _reg_write_address;
    assign _reg_write_address = (_op == `OP_JAL) ? 5'd31 :
                                (IDEX_ctrl_reg_dst_i) ? _rd : _rt;

    wire [1:0] _forward_a;
    wire [1:0] _forward_b;
    forwarding_unit forwarding_unit(.rs_i(_rs),
                                    .rt_i(_rt),
                                    .MEM_reg_write_address_i(EXMEM_reg_write_address_o),
                                    .MEM_ctrl_reg_write_i(EXMEM_ctrl_reg_write_o),
                                    .WB_reg_write_address_i(WB_reg_write_address_i),
                                    .WB_ctrl_reg_write_i(WB_ctrl_reg_write_i),
                                    .forward_a_o(_forward_a),
                                    .forward_b_o(_forward_b));

    always @(negedge n_rst_i or posedge clk_i) begin
        if (~n_rst_i) begin
            EXMEM_pc_branched_o <= 0;
            EXMEM_alu_o <= 0;
            EXMEM_alu_do_branch_o <= 0;
            EXMEM_b_o <= 0;
            EXMEM_reg_write_address_o <= 0;
            EXMEM_ctrl_branch_o <= 0;
            EXMEM_ctrl_mem_read_o <= 0;
            EXMEM_ctrl_mem_write_o <= 0;
            EXMEM_ctrl_reg_write_o <= 0;
            EXMEM_ctrl_mem_to_reg_o <= 0;
        end else if (clk_i) begin
            EXMEM_pc_branched_o <= _pc_branched;
            EXMEM_alu_o <= _alu;
            EXMEM_alu_do_branch_o <= _alu_do_branch;
            EXMEM_b_o <= _b;
            EXMEM_reg_write_address_o <= _reg_write_address;
            if (MEM_do_branch_i) begin
                EXMEM_ctrl_branch_o <= 0;
                EXMEM_ctrl_mem_read_o <= 0;
                EXMEM_ctrl_mem_write_o <= 0;
                EXMEM_ctrl_reg_write_o <= 0;
                EXMEM_ctrl_mem_to_reg_o <= 0;
            end else begin
                EXMEM_ctrl_branch_o <= IDEX_ctrl_branch_i;
                EXMEM_ctrl_mem_read_o <= IDEX_ctrl_mem_read_i;
                EXMEM_ctrl_mem_write_o <= IDEX_ctrl_mem_write_i;
                EXMEM_ctrl_reg_write_o <= IDEX_ctrl_reg_write_i;
                EXMEM_ctrl_mem_to_reg_o <= IDEX_ctrl_mem_to_reg_i;
            end
        end
    end

    function [31:0] pc_branched;
        input [5:0] op;
        input [31:0] pc;
        input [31:0] imm_dpl;
        input [25:0] addr;
        input [31:0] a;
        case (op)
            `OP_BEQ, `OP_BNE, `OP_BLT, `OP_BLE: pc_branched = pc + (imm_dpl << 2);
            `OP_J, `OP_JAL: pc_branched = {6'b0, addr};
            `OP_JR: pc_branched = a;
            default: pc_branched = pc;
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

    function [31:0] forward_mux;
        input [1:0] forward;
        input [31:0] EX_data;
        input [31:0] MEM_reg_write_data;
        input [31:0] WB_reg_write_data;
        case (forward)
            `FORWARD_MEM: forward_mux = MEM_reg_write_data;
            `FORWARD_WB:  forward_mux = WB_reg_write_data;
            default:      forward_mux = EX_data;
        endcase
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

module forwarding_unit(input [4:0] rs_i,
                       input [4:0] rt_i,
                       input [4:0] MEM_reg_write_address_i,
                       input MEM_ctrl_reg_write_i,
                       input [4:0] WB_reg_write_address_i,
                       input WB_ctrl_reg_write_i,
                       output [1:0] forward_a_o,
                       output [1:0] forward_b_o);

    assign forward_a_o = forward_a(rs_i,
                                   MEM_reg_write_address_i,
                                   MEM_ctrl_reg_write_i,
                                   WB_reg_write_address_i,
                                   WB_ctrl_reg_write_i);

    assign forward_b_o = forward_b(rt_i,
                                   MEM_reg_write_address_i,
                                   MEM_ctrl_reg_write_i,
                                   WB_reg_write_address_i,
                                   WB_ctrl_reg_write_i);

    function [1:0] forward_a;
        input [4:0] rs;
        input [4:0] MEM_reg_write_address;
        input MEM_ctrl_reg_write;
        input [4:0] WB_reg_write_address;
        input WB_ctrl_reg_write;
        if (MEM_ctrl_reg_write
            && MEM_reg_write_address != 0
            && MEM_reg_write_address == rs) begin
            forward_a = `FORWARD_MEM;
        end else if (WB_ctrl_reg_write
                     && WB_reg_write_address != 0
                     && WB_reg_write_address == rs) begin
            forward_a = `FORWARD_WB;
        end else begin
            forward_a = `FORWARD_NONE;
        end
    endfunction

    function [1:0] forward_b;
        input [4:0] rt;
        input [4:0] MEM_reg_write_address;
        input MEM_ctrl_reg_write;
        input [4:0] WB_reg_write_address;
        input WB_ctrl_reg_write;
        if (MEM_ctrl_reg_write
            && MEM_reg_write_address != 0
            && MEM_reg_write_address == rt) begin
            forward_b = `FORWARD_MEM;
        end else if (WB_ctrl_reg_write
                     && WB_reg_write_address != 0
                     && WB_reg_write_address == rt) begin
            forward_b = `FORWARD_WB;
        end else begin
            forward_b = `FORWARD_NONE;
        end
    endfunction

endmodule
