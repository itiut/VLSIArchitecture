`include "header.v"

module MEM(input clk_in,
           input n_rst_in,
           input [31:0] EXMEM_pc_branch_in,
           input [31:0] EXMEM_alu_in,
           input EXMEM_alu_do_branch_in,
           input [31:0] EXMEM_b_in,
           input [4:0] EXMEM_rd_in,
           input EXMEM_ctrl_branch_in,
           input [1:0] EXMEM_ctrl_mem_read_in,
           input [1:0] EXMEM_ctrl_mem_write_in,
           input EXMEM_ctrl_reg_write_in,
           input EXMEM_ctrl_mem_to_reg_in,
           output reg [31:0] MEMWB_mem_out,
           output reg [31:0] MEMWB_alu_out,
           output reg [4:0] MEMWB_rd_out,
           output reg MEMWB_ctrl_reg_write_out,
           output reg MEMWB_ctrl_mem_to_reg_out,
           output [31:0] MEM_pc_branch_out,
           output MEM_ctrl_pc_src_out);

    assign MEM_ctrl_pc_src_out = (EXMEM_ctrl_branch_in & EXMEM_alu_do_branch_in);

    wire [31:0] mem_read_data;

    memory memory(.clk_in(clk_in),
                  .address_in(EXMEM_alu_in[7:0]),
                  .write_data_in(EXMEM_b_in),
                  .ctrl_mem_read_in(EXMEM_ctrl_mem_read_in),
                  .ctrl_mem_write_in(EXMEM_ctrl_mem_write_in),
                  .read_data_out(mem_read_data));

    always @(negedge n_rst_in or posedge clk_in) begin
        if (~n_rst_in) begin
            MEMWB_alu_out <= 0;
            MEMWB_mem_out <= 0;
            MEMWB_rd_out <= 0;
            MEMWB_ctrl_reg_write_out <= 0;
            MEMWB_ctrl_mem_to_reg_out <= 0;
        end else if (clk_in) begin
            MEMWB_alu_out <= EXMEM_alu_in;
            MEMWB_rd_out <= EXMEM_rd_in;
            MEMWB_ctrl_reg_write_out <= EXMEM_ctrl_reg_write_in;
            MEMWB_ctrl_mem_to_reg_out <= EXMEM_ctrl_mem_to_reg_in;
        end
    end

    always @(negedge clk_in) begin
        MEMWB_mem_out <= mem_read_data;
    end

endmodule

module memory(input clk_in,
              input [7:0] address_in,
              input [31:0] write_data_in,
              input [1:0] ctrl_mem_read_in,
              input [1:0] ctrl_mem_write_in,
              output [31:0] read_data_out);

    reg [31:0] mem[0:255];

    assign read_data_out = read(mem[address_in], ctrl_mem_read_in);

    // TODO: neg or pos clk?
    always @(negedge clk_in) begin
        case (ctrl_mem_write_in)
            `WORD: mem[address_in] <= write_data_in;
            `HALFWORD: mem[address_in][15:0] <= write_data_in[15:0];
            `BYTE: mem[address_in][7:0] <= write_data_in[7:0];
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
