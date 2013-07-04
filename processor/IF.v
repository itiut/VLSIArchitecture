module IF(input clk_i,
          input n_rst_i,
          input ID_stall_i,
          input [31:0] MEM_pc_branched_i,
          input MEM_do_branch_i,
          output reg [31:0] IFID_pc_o,
          output reg [31:0] IFID_ir_o);

    reg [31:0] _pc;
    reg [31:0] _ins_mem[0:255];

    initial $readmemb("ins_mem.bnr", _ins_mem);

    wire [31:0] _next_pc;
    wire [31:0] _next_pc_plus4;
    wire [31:0] _ins;

    assign _next_pc = next_pc(IFID_pc_o,
                              MEM_pc_branched_i,
                              MEM_do_branch_i);
    assign _next_pc_plus4 = _next_pc + 4;
    assign _ins = _ins_mem[_next_pc >> 2];

    always @(negedge n_rst_i or posedge clk_i) begin
        if (~n_rst_i) begin
            _pc <= 0;
            IFID_pc_o <= 0;
            IFID_ir_o <= 32'hxxxxxxxx;
        end else if (clk_i) begin
            _pc <= _next_pc;
            if (~ID_stall_i) begin
                IFID_pc_o <= _next_pc_plus4;
                IFID_ir_o <= _ins;
            end
        end
    end

    function [31:0] next_pc;
        input [31:0] pc_plus4;
        input [31:0] pc_branched;
        input do_branch;
        if (do_branch) begin
            next_pc = pc_branched;
        end else begin
            next_pc = pc_plus4;
        end
    endfunction

endmodule
