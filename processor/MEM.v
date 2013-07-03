`include "header.v"

module MEM(input clk_i,
           input n_rst_i,
           input [31:0] EXMEM_pc_branch_i,
           input [31:0] EXMEM_alu_i,
           input EXMEM_alu_do_branch_i,
           input [31:0] EXMEM_b_i,
           input [4:0] EXMEM_reg_write_address_i,
           input EXMEM_ctrl_branch_i,
           input [1:0] EXMEM_ctrl_mem_read_i,
           input [1:0] EXMEM_ctrl_mem_write_i,
           input EXMEM_ctrl_reg_write_i,
           input EXMEM_ctrl_mem_to_reg_i,
           output reg [31:0] MEMWB_mem_o,
           output reg [31:0] MEMWB_alu_o,
           output reg [4:0] MEMWB_reg_write_address_o,
           output reg MEMWB_ctrl_reg_write_o,
           output reg MEMWB_ctrl_mem_to_reg_o,
           output [31:0] MEM_pc_branch_o,
           output MEM_ctrl_pc_src_o);

    assign MEM_pc_branch_o = EXMEM_pc_branch_i;
    assign MEM_ctrl_pc_src_o = (EXMEM_ctrl_branch_i & EXMEM_alu_do_branch_i);

    wire [31:0] _mem_read_data;

    memory memory(.clk_i(clk_i),
                  .address_i(EXMEM_alu_i[7:0]),
                  .write_data_i(EXMEM_b_i),
                  .ctrl_mem_read_i(EXMEM_ctrl_mem_read_i),
                  .ctrl_mem_write_i(EXMEM_ctrl_mem_write_i),
                  .read_data_o(_mem_read_data));

    always @(negedge n_rst_i or posedge clk_i) begin
        if (~n_rst_i) begin
            MEMWB_alu_o <= 0;
            MEMWB_mem_o <= 0;
            MEMWB_reg_write_address_o <= 0;
            MEMWB_ctrl_reg_write_o <= 0;
            MEMWB_ctrl_mem_to_reg_o <= 0;
        end else if (clk_i) begin
            MEMWB_alu_o <= EXMEM_alu_i;
            MEMWB_reg_write_address_o <= EXMEM_reg_write_address_i;
            MEMWB_ctrl_reg_write_o <= EXMEM_ctrl_reg_write_i;
            MEMWB_ctrl_mem_to_reg_o <= EXMEM_ctrl_mem_to_reg_i;
        end
    end

    always @(negedge clk_i) begin
        MEMWB_mem_o <= _mem_read_data;
    end

endmodule

module memory(input clk_i,
              input [7:0] address_i,
              input [31:0] write_data_i,
              input [1:0] ctrl_mem_read_i,
              input [1:0] ctrl_mem_write_i,
              output [31:0] read_data_o);

    reg [31:0] _mem[0:255];

    assign read_data_o = read(_mem[address_i], ctrl_mem_read_i);

    // TODO: neg or pos clk?
    always @(negedge clk_i) begin
        case (ctrl_mem_write_i)
            `WORD: _mem[address_i] <= write_data_i;
            `HALFWORD: _mem[address_i][15:0] <= write_data_i[15:0];
            `BYTE: _mem[address_i][7:0] <= write_data_i[7:0];
        endcase
    end

    function [31:0] read;
        input [31:0] data;
        input [1:0] ctrl;
        case (ctrl)
            `WORD: read = data;
            `HALFWORD: read = {{16{data[15]}}, data[15:0]};
            `BYTE: read = {{24{data[7]}}, data[7:0]};
            default: read = 0;
        endcase
    endfunction

endmodule
