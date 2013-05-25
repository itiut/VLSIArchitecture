`include "header.v"

module ID(input clk_in,
          input n_rst_in,
          input [31:0] IFID_pc_in,
          input [31:0] IFID_ir_in,
          input [4:0] WB_reg_write_address_in,
          input [31:0] WB_reg_write_data_in,
          input WB_ctrl_reg_write_in,
          output reg [31:0] IDEX_pc_out,
          output reg [31:0] IDEX_ir_out,
          output reg [31:0] IDEX_a_out,
          output reg [31:0] IDEX_b_out,
          output reg IDEX_ctrl_reg_dst_out,
          output reg IDEX_ctrl_alu_src_out,
          output reg IDEX_ctrl_branch_out,
          output reg [1:0] IDEX_ctrl_mem_read_out,  // word, half-word, byte
          output reg [1:0] IDEX_ctrl_mem_write_out, // word, half-word, byte
          output reg IDEX_ctrl_reg_write_out,
          output reg IDEX_ctrl_mem_to_reg_out);

    wire [4:0] rs;
    wire [4:0] rt;
    wire [31:0] reg_read_data1;
    wire [31:0] reg_read_data2;

    assign rs = IFID_ir_in[25:21];
    assign rt = IFID_ir_in[20:16];

    register register(.clk_in(clk_in),
                      .n_rst_in(n_rst_in),
                      .read_address1_in(rs),
                      .read_address2_in(rt),
                      .write_address_in(WB_reg_write_address_in),
                      .write_data_in(WB_reg_write_data_in),
                      .ctrl_reg_write_in(WB_ctrl_reg_write_in),
                      .read_data1_out(reg_read_data1),
                      .read_data2_out(reg_read_data2));

    wire ctrl_reg_dst;
    wire ctrl_alu_src;
    wire ctrl_branch;
    wire [1:0] ctrl_mem_read;
    wire [1:0] ctrl_mem_write;
    wire ctrl_reg_write;
    wire ctrl_mem_to_reg;

    control_unit control_unit(.ir_in(IFID_ir_in),
                              .reg_dst_out(ctrl_reg_dst),
                              .alu_src_out(ctrl_alu_src),
                              .branch_out(ctrl_branch),
                              .mem_read_out(ctrl_mem_read),
                              .mem_write_out(ctrl_mem_write),
                              .reg_write_out(ctrl_reg_write),
                              .mem_to_reg_out(ctrl_mem_to_reg));

    always @(negedge n_rst_in or posedge clk_in) begin
        if (~n_rst_in) begin
            IDEX_pc_out <= 0;
            IDEX_ir_out <= 0;
            IDEX_a_out <= 0;
            IDEX_b_out <= 0;
            IDEX_ctrl_reg_dst_out <= 0;
            IDEX_ctrl_alu_src_out <= 0;
            IDEX_ctrl_branch_out <= 0;
            IDEX_ctrl_mem_read_out <= 0;
            IDEX_ctrl_mem_write_out <= 0;
            IDEX_ctrl_reg_write_out <= 0;
            IDEX_ctrl_mem_to_reg_out <= 0;
        end else if (clk_in) begin
            IDEX_pc_out <= IFID_pc_in;
            IDEX_ir_out <= IFID_ir_in;
            IDEX_ctrl_reg_dst_out <= ctrl_reg_dst;
            IDEX_ctrl_alu_src_out <= ctrl_alu_src;
            IDEX_ctrl_branch_out <= ctrl_branch;
            IDEX_ctrl_mem_read_out <= ctrl_mem_read;
            IDEX_ctrl_mem_write_out <= ctrl_mem_write;
            IDEX_ctrl_reg_write_out <= ctrl_reg_write;
            IDEX_ctrl_mem_to_reg_out <= ctrl_mem_to_reg;
        end
    end

    always @(negedge clk_in) begin
        IDEX_a_out <= reg_read_data1;
        IDEX_b_out <= reg_read_data2;
    end

endmodule

module register(input clk_in,
                input n_rst_in,
                input [4:0] read_address1_in,
                input [4:0] read_address2_in,
                input [4:0] write_address_in,
                input [31:0] write_data_in,
                input ctrl_reg_write_in,
                output [31:0] read_data1_out,
                output [31:0] read_data2_out);

    reg [31:0] regs[0:31];

    assign read_data1_out = regs[read_address1_in];
    assign read_data2_out = regs[read_address2_in];

    always @(negedge n_rst_in) begin
        regs[0] <= 0;
    end

    // TODO: neg or pos clk?
    always @(negedge clk_in) begin
        if (ctrl_reg_write_in) begin
            regs[write_address_in] <= write_data_in;
        end
    end

endmodule

module control_unit(input [31:0] ir_in,
                    output reg_dst_out,
                    output alu_src_out,
                    output branch_out,
                    output [1:0] mem_read_out,
                    output [1:0] mem_write_out,
                    output reg_write_out,
                    output mem_to_reg_out);

    wire [5:0] op;
    assign op = ir_in[31:26];

    assign reg_dst_out = (op == `OP_R);
    assign alu_src_out = alu_src(op);
    assign branch_out = branch(op);
    assign mem_read_out = mem_read(op);
    assign mem_write_out = mem_write(op);
    assign reg_write_out = reg_write(op);
    assign mem_to_reg_out = mem_to_reg(op);

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
            default: mem_read = 0;
        endcase
    endfunction

    function [1:0] mem_write;
        input [5:0] op;
        case (op)
            `OP_SW: mem_write = `WORD;
            `OP_SH: mem_write = `HALFWORD;
            `OP_SB: mem_write = `BYTE;
            default: mem_write = 0;
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
