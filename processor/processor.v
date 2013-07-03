module processor;
    reg clk;
    reg n_rst;

    initial begin
        clk <= 0;
        n_rst <= 1;
        #10 n_rst <= 0;
        #10 n_rst <= 1;
        #10000 $stop;
    end

    always #50 clk = ~clk;

    // IF
    wire [31:0] IFID_pc;
    wire [31:0] IFID_ir;

    // ID
    wire [31:0] IDEX_pc;
    wire [31:0] IDEX_ir;
    wire [31:0] IDEX_a;
    wire [31:0] IDEX_b;
    wire IDEX_ctrl_reg_dst;
    wire IDEX_ctrl_alu_src;
    wire IDEX_ctrl_branch;
    wire [1:0] IDEX_ctrl_mem_read;
    wire [1:0] IDEX_ctrl_mem_write;
    wire IDEX_ctrl_reg_write;
    wire IDEX_ctrl_mem_to_reg;
    wire ID_stall;

    // EX
    wire [31:0] EXMEM_pc_branched;
    wire [31:0] EXMEM_alu;
    wire EXMEM_alu_do_branch;
    wire [31:0] EXMEM_b;
    wire [4:0] EXMEM_reg_write_address;
    wire EXMEM_ctrl_branch;
    wire [1:0] EXMEM_ctrl_mem_read;
    wire [1:0] EXMEM_ctrl_mem_write;
    wire EXMEM_ctrl_reg_write;
    wire EXMEM_ctrl_mem_to_reg;

    // MEM
    wire [31:0] MEMWB_mem;
    wire [31:0] MEMWB_alu;
    wire [4:0] MEMWB_reg_write_address;
    wire MEMWB_ctrl_reg_write;
    wire MEMWB_ctrl_mem_to_reg;
    wire [31:0] MEM_pc_branched;
    wire MEM_do_branch;

    // WB
    wire [4:0] WB_reg_write_address;
    wire [31:0] WB_reg_write_data;
    wire WB_ctrl_reg_write;

    IF IF(.clk_i(clk),
          .n_rst_i(n_rst),
          .ID_stall_i(ID_stall),
          .MEM_pc_branched_i(MEM_pc_branched),
          .MEM_do_branch_i(MEM_do_branch),
          .IFID_pc_o(IFID_pc),
          .IFID_ir_o(IFID_ir));

    ID ID(.clk_i(clk),
          .n_rst_i(n_rst),
          .IFID_pc_i(IFID_pc),
          .IFID_ir_i(IFID_ir),
          .MEM_do_branch_i(MEM_do_branch),
          .WB_reg_write_address_i(WB_reg_write_address),
          .WB_reg_write_data_i(WB_reg_write_data),
          .WB_ctrl_reg_write_i(WB_ctrl_reg_write),
          .IDEX_pc_o(IDEX_pc),
          .IDEX_ir_o(IDEX_ir),
          .IDEX_a_o(IDEX_a),
          .IDEX_b_o(IDEX_b),
          .IDEX_ctrl_reg_dst_o(IDEX_ctrl_reg_dst),
          .IDEX_ctrl_alu_src_o(IDEX_ctrl_alu_src),
          .IDEX_ctrl_branch_o(IDEX_ctrl_branch),
          .IDEX_ctrl_mem_read_o(IDEX_ctrl_mem_read),
          .IDEX_ctrl_mem_write_o(IDEX_ctrl_mem_write),
          .IDEX_ctrl_reg_write_o(IDEX_ctrl_reg_write),
          .IDEX_ctrl_mem_to_reg_o(IDEX_ctrl_mem_to_reg),
          .ID_stall_o(ID_stall));

    EX EX(.clk_i(clk),
          .n_rst_i(n_rst),
          .IDEX_pc_i(IDEX_pc),
          .IDEX_ir_i(IDEX_ir),
          .IDEX_a_i(IDEX_a),
          .IDEX_b_i(IDEX_b),
          .IDEX_ctrl_reg_dst_i(IDEX_ctrl_reg_dst),
          .IDEX_ctrl_alu_src_i(IDEX_ctrl_alu_src),
          .IDEX_ctrl_branch_i(IDEX_ctrl_branch),
          .IDEX_ctrl_mem_read_i(IDEX_ctrl_mem_read),
          .IDEX_ctrl_mem_write_i(IDEX_ctrl_mem_write),
          .IDEX_ctrl_reg_write_i(IDEX_ctrl_reg_write),
          .IDEX_ctrl_mem_to_reg_i(IDEX_ctrl_mem_to_reg),
          .MEM_do_branch_i(MEM_do_branch),
          .WB_reg_write_address_i(WB_reg_write_address),
          .WB_reg_write_data_i(WB_reg_write_data),
          .WB_ctrl_reg_write_i(WB_ctrl_reg_write),
          .EXMEM_pc_branched_o(EXMEM_pc_branched),
          .EXMEM_alu_o(EXMEM_alu),
          .EXMEM_alu_do_branch_o(EXMEM_alu_do_branch),
          .EXMEM_b_o(EXMEM_b),
          .EXMEM_reg_write_address_o(EXMEM_reg_write_address),
          .EXMEM_ctrl_branch_o(EXMEM_ctrl_branch),
          .EXMEM_ctrl_mem_read_o(EXMEM_ctrl_mem_read),
          .EXMEM_ctrl_mem_write_o(EXMEM_ctrl_mem_write),
          .EXMEM_ctrl_reg_write_o(EXMEM_ctrl_reg_write),
          .EXMEM_ctrl_mem_to_reg_o(EXMEM_ctrl_mem_to_reg));

    MEM MEM(.clk_i(clk),
            .n_rst_i(n_rst),
            .EXMEM_pc_branched_i(EXMEM_pc_branched),
            .EXMEM_alu_i(EXMEM_alu),
            .EXMEM_alu_do_branch_i(EXMEM_alu_do_branch),
            .EXMEM_b_i(EXMEM_b),
            .EXMEM_reg_write_address_i(EXMEM_reg_write_address),
            .EXMEM_ctrl_branch_i(EXMEM_ctrl_branch),
            .EXMEM_ctrl_mem_read_i(EXMEM_ctrl_mem_read),
            .EXMEM_ctrl_mem_write_i(EXMEM_ctrl_mem_write),
            .EXMEM_ctrl_reg_write_i(EXMEM_ctrl_reg_write),
            .EXMEM_ctrl_mem_to_reg_i(EXMEM_ctrl_mem_to_reg),
            .MEMWB_mem_o(MEMWB_mem),
            .MEMWB_alu_o(MEMWB_alu),
            .MEMWB_reg_write_address_o(MEMWB_reg_write_address),
            .MEMWB_ctrl_reg_write_o(MEMWB_ctrl_reg_write),
            .MEMWB_ctrl_mem_to_reg_o(MEMWB_ctrl_mem_to_reg),
            .MEM_pc_branched_o(MEM_pc_branched),
            .MEM_do_branch_o(MEM_do_branch));

    WB WB(.clk_i(clk),
          .n_rst_i(n_rst),
          .MEMWB_mem_i(MEMWB_mem),
          .MEMWB_alu_i(MEMWB_alu),
          .MEMWB_reg_write_address_i(MEMWB_reg_write_address),
          .MEMWB_ctrl_reg_write_i(MEMWB_ctrl_reg_write),
          .MEMWB_ctrl_mem_to_reg_i(MEMWB_ctrl_mem_to_reg),
          .WB_reg_write_address_o(WB_reg_write_address),
          .WB_reg_write_data_o(WB_reg_write_data),
          .WB_ctrl_reg_write_o(WB_ctrl_reg_write));

endmodule
