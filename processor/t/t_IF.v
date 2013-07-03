module t_IF;
    reg clk;
    reg n_rst;
    reg stall;
    reg [31:0] pc_branched;
    reg do_branch;
    wire [31:0] pc;
    wire [31:0] ir;

    initial begin
        clk <= 0;
        n_rst <= 1;
        stall <= 0;
        pc_branched <= 0;
        do_branch <= 0;

        #10 n_rst <= 0;
        #10 n_rst <= 1;

        #200 stall <= 1;
        #400 stall <= 0;

        #200 do_branch <= 1; pc_branched <= 100;
        #100 do_branch <= 0;

        #200 do_branch <= 1; pc_branched <= 0;
        #100 do_branch <= 0;

        #1000 $stop;
    end

    always #50 clk = ~clk;

    IF IF(.clk_i(clk),
          .n_rst_i(n_rst),
          .ID_stall_i(stall),
          .MEM_pc_branched_i(pc_branched),
          .MEM_do_branch_i(do_branch),
          .IFID_pc_o(pc),
          .IFID_ir_o(ir));

endmodule
