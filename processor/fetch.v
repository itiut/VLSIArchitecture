module fetch(input [7:0] pc_in,
             output [31:0] ir_out);

    reg [31:0] ins_mem[0:255];

    assign ir_out = ins_mem[pc_in];

endmodule
