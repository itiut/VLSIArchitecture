module IF(input clk_in,
          input n_rst_in,
          input [31:0] MEM_pc_branch_in,
          input MEM_ctrl_pc_src_in,
          output reg [31:0] IFID_pc_out,
          output reg [31:0] IFID_ir_out);

    reg [31:0] pc;
    reg [31:0] ins_mem[0:10];

    initial $readmemb("memory.bnr", ins_mem);

    wire [31:0] next_pc_out;
    wire [31:0] next_pc_plus4;
    wire [31:0] ir_out;

    assign next_pc_out = next_pc(IFID_pc_out,
                                 MEM_pc_branch_in,
                                 MEM_ctrl_pc_src_in);
    assign next_pc_plus4 = next_pc_out + 4;
    assign ir_out = ins_mem[next_pc_out >> 2];

    always @(negedge n_rst_in or posedge clk_in) begin
        if (~n_rst_in) begin
            pc <= 0;
            IFID_pc_out <= 0;
            IFID_ir_out <= 0;
        end else if (clk_in) begin
            pc <= next_pc_out;
            IFID_pc_out <= next_pc_plus4;
            IFID_ir_out <= ir_out;
        end
    end

    function [31:0] next_pc;
        input [31:0] pc_plus4;
        input [31:0] pc_branch;
        input ctrl_pc_src;

        if (ctrl_pc_src) begin
            next_pc = pc_branch;
        end else begin
            next_pc = pc_plus4;
        end
    endfunction

endmodule
