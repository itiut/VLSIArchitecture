module writeback(input clk_in,
                 input rstd_in,
                 input [31:0] nextpc_in,
                 output reg [31:0] pc_out);

    always @(negedge rstd_in or posedge clk_in) begin
        if (~rstd_in) begin
            pc_out <= 32'b0;
        end else if (clk_in) begin
            pc_out <= nextpc_in;
        end
    end

endmodule
