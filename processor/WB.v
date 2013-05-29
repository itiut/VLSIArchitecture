module WB(input clk_i,
          input n_rst_i,
          input [31:0] MEMWB_mem_i,
          input [31:0] MEMWB_alu_i,
          input [4:0] MEMWB_rd_i,
          input MEMWB_ctrl_reg_write_i,
          input MEMWB_ctrl_mem_to_reg_i,
          output [4:0] WB_reg_write_address_o,
          output [31:0] WB_reg_write_data_o,
          output WB_ctrl_reg_write_o);

    assign WB_reg_write_address_o = MEMWB_rd_i;
    assign WB_reg_write_data_o = (MEMWB_ctrl_mem_to_reg_i) ? MEMWB_mem_i : MEMWB_alu_i;
    assign WB_ctrl_reg_write_o = MEMWB_ctrl_reg_write_i;

endmodule
