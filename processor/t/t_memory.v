`define WORD     2'b11
`define HALFWORD 2'b10
`define BYTE     2'b01

module t_memory;
    reg clk;
    reg n_rst;

    initial begin
        clk <= 0;
        n_rst <= 1;
        #10 n_rst <= 0;
        #10 n_rst <= 1;
    end

    always #50 clk = ~clk;

    reg [7:0] addr;
    reg [31:0] wd;
    reg [1:0] mem_read;
    reg [1:0] mem_write;
    wire [31:0] rd;

    memory memory(.clk_i(clk),
                  .address_i(addr),
                  .write_data_i(wd),
                  .ctrl_mem_read_i(mem_read),
                  .ctrl_mem_write_i(mem_write),
                  .read_data_o(rd));

    initial begin
        mem_read <= 2'b11; mem_write <= 2'b11;
        #50 addr <= 0; wd <= 0;
        #100 addr <= 1; wd <= 1;
        #100 addr <= 2; wd <= 2;
        #100 mem_read <= 0; mem_write <= 0;
        #100 mem_write <= `WORD; addr <= 3; wd <= 3;
        #100 addr <= 4; wd <= 4;
        #100 addr <= 5; wd <= 5;
        #100 mem_write <= 0;
        #100 mem_read <= `WORD; addr <= 3; wd <= 100;
        #100 addr <= 4; wd <= 200;
        #100 addr <= 5; wd <= 300;
        #100 mem_read <= 0;
        #100 mem_write <= `HALFWORD; addr <= 6; wd <= 32'h_12_34_45_78;
        #100 mem_write <= `BYTE; addr <= 7; wd <= 32'h_9a_bc_de_f0;
        #100 mem_write <= 0;
        #100 mem_read <= `HALFWORD; addr <= 6;
        #100 mem_read <= `WORD;
        #100 mem_read <= `BYTE; addr <= 7;
        #100 mem_read <= `WORD;
        #1000 $stop;
    end

endmodule
