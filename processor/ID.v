`include "header.v"

module ID(input clk_i,
          input n_rst_i,
          input [31:0] IFID_pc_i,
          input [31:0] IFID_ir_i,
          input MEM_do_branch_i,
          input [4:0] WB_reg_write_address_i,
          input [31:0] WB_reg_write_data_i,
          input WB_ctrl_reg_write_i,
          output reg [31:0] IDEX_pc_o,
          output reg [31:0] IDEX_ir_o,
          output reg [31:0] IDEX_a_o,
          output reg [31:0] IDEX_b_o,
          output reg IDEX_ctrl_reg_dst_o,
          output reg IDEX_ctrl_alu_src_o,
          output reg IDEX_ctrl_branch_o,
          output reg [1:0] IDEX_ctrl_mem_read_o,  // word, half-word, byte
          output reg [1:0] IDEX_ctrl_mem_write_o, // word, half-word, byte
          output reg IDEX_ctrl_reg_write_o,
          output reg IDEX_ctrl_mem_to_reg_o,
          output ID_stall_o);

    wire [4:0] _rs;
    wire [4:0] _rt;
    wire [31:0] _reg_read_data1;
    wire [31:0] _reg_read_data2;

    assign _rs = IFID_ir_i[25:21];
    assign _rt = IFID_ir_i[20:16];

    register register(.clk_i(clk_i),
                      .n_rst_i(n_rst_i),
                      .read_address1_i(_rs),
                      .read_address2_i(_rt),
                      .write_address_i(WB_reg_write_address_i),
                      .write_data_i(WB_reg_write_data_i),
                      .ctrl_reg_write_i(WB_ctrl_reg_write_i),
                      .read_data1_o(_reg_read_data1),
                      .read_data2_o(_reg_read_data2));

    wire _ctrl_reg_dst;
    wire _ctrl_alu_src;
    wire _ctrl_branch;
    wire [1:0] _ctrl_mem_read;
    wire [1:0] _ctrl_mem_write;
    wire _ctrl_reg_write;
    wire _ctrl_mem_to_reg;

    control_unit control_unit(.ir_i(IFID_ir_i),
                              .reg_dst_o(_ctrl_reg_dst),
                              .alu_src_o(_ctrl_alu_src),
                              .branch_o(_ctrl_branch),
                              .mem_read_o(_ctrl_mem_read),
                              .mem_write_o(_ctrl_mem_write),
                              .reg_write_o(_ctrl_reg_write),
                              .mem_to_reg_o(_ctrl_mem_to_reg));

    hazard_unit hazard_unit(.EX_ctrl_mem_read_i(IDEX_ctrl_mem_read_o),
                            .EX_rt_i(IDEX_ir_o[20:16]),
                            .ID_rs_i(_rs),
                            .ID_rt_i(_rt),
                            .stall_o(ID_stall_o));

    always @(negedge n_rst_i or posedge clk_i) begin
        if (~n_rst_i) begin
            IDEX_pc_o <= 0;
            IDEX_ir_o <= 0;
            IDEX_a_o <= 0;
            IDEX_b_o <= 0;
            IDEX_ctrl_reg_dst_o <= 0;
            IDEX_ctrl_alu_src_o <= 0;
            IDEX_ctrl_branch_o <= 0;
            IDEX_ctrl_mem_read_o <= 0;
            IDEX_ctrl_mem_write_o <= 0;
            IDEX_ctrl_reg_write_o <= 0;
            IDEX_ctrl_mem_to_reg_o <= 0;
        end else if (clk_i) begin
            IDEX_pc_o <= IFID_pc_i;
            IDEX_ir_o <= IFID_ir_i;
            IDEX_a_o <= _reg_read_data1;
            IDEX_b_o <= _reg_read_data2;
            if (ID_stall_o || MEM_do_branch_i) begin
                IDEX_ctrl_reg_dst_o <= 0;
                IDEX_ctrl_alu_src_o <= 0;
                IDEX_ctrl_branch_o <= 0;
                IDEX_ctrl_mem_read_o <= 0;
                IDEX_ctrl_mem_write_o <= 0;
                IDEX_ctrl_reg_write_o <= 0;
                IDEX_ctrl_mem_to_reg_o <= 0;
            end else begin
                IDEX_ctrl_reg_dst_o <= _ctrl_reg_dst;
                IDEX_ctrl_alu_src_o <= _ctrl_alu_src;
                IDEX_ctrl_branch_o <= _ctrl_branch;
                IDEX_ctrl_mem_read_o <= _ctrl_mem_read;
                IDEX_ctrl_mem_write_o <= _ctrl_mem_write;
                IDEX_ctrl_reg_write_o <= _ctrl_reg_write;
                IDEX_ctrl_mem_to_reg_o <= _ctrl_mem_to_reg;
            end
        end
    end

endmodule

module register(input clk_i,
                input n_rst_i,
                input [4:0] read_address1_i,
                input [4:0] read_address2_i,
                input [4:0] write_address_i,
                input [31:0] write_data_i,
                input ctrl_reg_write_i,
                output [31:0] read_data1_o,
                output [31:0] read_data2_o);

    reg [31:0] _regs[0:31];

    assign read_data1_o = _regs[read_address1_i];
    assign read_data2_o = _regs[read_address2_i];

    always @(negedge n_rst_i) begin
        _regs[0] <= 0;
    end

    always @(negedge clk_i) begin
        if (ctrl_reg_write_i) begin
            _regs[write_address_i] <= write_data_i;
        end
    end

endmodule

module control_unit(input [31:0] ir_i,
                    output reg_dst_o,
                    output alu_src_o,
                    output branch_o,
                    output [1:0] mem_read_o,
                    output [1:0] mem_write_o,
                    output reg_write_o,
                    output mem_to_reg_o);

    wire [5:0] _op;
    assign _op = ir_i[31:26];

    assign reg_dst_o = (_op == `OP_R);
    assign alu_src_o = alu_src(_op);
    assign branch_o = branch(_op);
    assign mem_read_o = mem_read(_op);
    assign mem_write_o = mem_write(_op);
    assign reg_write_o = reg_write(_op);
    assign mem_to_reg_o = mem_to_reg(_op);

    function alu_src;
        input [5:0] op;
        case (op)
            `OP_ADDI, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_LW, `OP_LH, `OP_LB, `OP_SW, `OP_SH, `OP_SB:
              alu_src = 1;
            default: alu_src = 0;
        endcase
    endfunction

    function branch;
        input [5:0] op;
        case (op)
            `OP_BEQ, `OP_BNE, `OP_BLT, `OP_BLE, `OP_J, `OP_JAL, `OP_JR:
              branch = 1;
            default: branch = 0;
        endcase
    endfunction

    function [1:0] mem_read;
        input [5:0] op;
        case (op)
            `OP_LW: mem_read = `WORD;
            `OP_LH: mem_read = `HALFWORD;
            `OP_LB: mem_read = `BYTE;
            default: mem_read = `MEM_NONE;
        endcase
    endfunction

    function [1:0] mem_write;
        input [5:0] op;
        case (op)
            `OP_SW: mem_write = `WORD;
            `OP_SH: mem_write = `HALFWORD;
            `OP_SB: mem_write = `BYTE;
            default: mem_write = `MEM_NONE;
        endcase
    endfunction

    function reg_write;
        input [5:0] op;
        case (op)
            `OP_R, `OP_ADDI, `OP_LUI, `OP_ANDI, `OP_ORI, `OP_XORI, `OP_LW, `OP_LH, `OP_LB, `OP_JAL:
              reg_write = 1;
            default: reg_write = 0;
        endcase
    endfunction

    function mem_to_reg;
        input [5:0] op;
        case (op)
            `OP_LW, `OP_LH, `OP_LB: mem_to_reg = 1;
            default: mem_to_reg = 0;
        endcase
    endfunction

endmodule

module hazard_unit(input [1:0] EX_ctrl_mem_read_i,
                   input [4:0] EX_rt_i,
                   input [4:0] ID_rs_i,
                   input [4:0] ID_rt_i,
                   output stall_o);

    assign stall_o = EX_ctrl_mem_read_i != `MEM_NONE
                     && (EX_rt_i == ID_rs_i || EX_rt_i == ID_rt_i);

endmodule
