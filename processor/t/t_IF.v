module t_IF;
    reg clk;
    reg n_rst;
    wire [31:0] pc;
    wire [31:0] ir;
    integer i;

    initial begin
        clk = 0;
        for (i = 0; i < 10; i = i + 1) begin
            #100 clk = ~clk;
        end
    end

    initial begin
        n_rst = 1;
        #20 n_rst = 0;
        #20 n_rst = 1;
    end

    IF IF(.clk_i(clk),
          .n_rst_i(n_rst),
          .MEM_pc_branch_i(32'b0),
          .MEM_ctrl_pc_src_i(1'b0),
          .IFID_pc_o(pc),
          .IFID_ir_o(ir));

endmodule
