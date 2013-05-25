module reg_file(input clk,
                input rstd,
                input [31:0] wr,
                input [4:0] ra1,
                input [4:0] ra2,
                input [4:0] wa,
                input wren,
                output [31:0] rr1,
                output [31:0] rr2);

    reg [31:0] rf[0:31];

    assign rr1 = rf[ra1];
    assign rr2 = rf[ra2];

    always @(negedge rstd or posedge clk) begin
        if (~rstd) begin
            rf[0] <= 32'b0;
        end else if (~wren) begin
            rf[wa] <= wr;
        end
    end

endmodule
