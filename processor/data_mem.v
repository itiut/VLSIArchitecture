module data_mem(input [7:0] address,
                input clk,
                input [7:0] write_data,
                input wren,
                output [7:0] read_data);

    reg [7:0] d_mem[0:255];

    assign read_data = d_mem[address];

    always @(posedge clk) begin
        if (~wren) begin
            d_mem[address] <= write_data;
        end
    end

endmodule
