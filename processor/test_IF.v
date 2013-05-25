module test_IF;
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
        $finish;
    end

    initial begin
        n_rst = 1;
        #50 n_rst = 0;
        #10 n_rst = 1;
    end

    IF IF(.clk_in(clk),
          .n_rst_in(n_rst),
          .pc_branch_in(32'b0),
          .ctrl_pc_src_in(0),
          .IFID_pc_out(pc),
          .IFID_ir_out(ir));

endmodule
