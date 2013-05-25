module WB(input clk_in,
          input n_rst_in,
          input [31:0] MEMWB_mem_in,
          input [31:0] MEMWB_alu_in,
          input [4:0] MEMWB_rd_in,
          input MEMWB_ctrl_reg_write_in,
          input MEMWB_ctrl_mem_to_reg_in,
          output [4:0] WB_reg_write_address_out,
          output [31:0] WB_reg_write_data_out,
          output WB_ctrl_reg_write_out);

    assign WB_reg_write_address_out = MEMWB_rd_in;
    assign WB_reg_write_data_out = (MEMWB_ctrl_mem_to_reg_in) ? MEMWB_mem_in : MEMWB_alu_in;
    assign WB_ctrl_reg_write_out = MEMWB_ctrl_reg_write_in;

endmodule
