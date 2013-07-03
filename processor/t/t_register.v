module t_register;
    reg clk;
    reg n_rst;

    initial begin
        clk <= 0;
        n_rst <= 1;
        #10 n_rst <= 0;
        #10 n_rst <= 1;
    end

    always #50 clk = ~clk;

    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa;
    reg [31:0] wd;
    reg reg_write;
    wire [31:0] rd1;
    wire [31:0] rd2;

    register register(.clk_i(clk),
                      .n_rst_i(n_rst),
                      .read_address1_i(ra1),
                      .read_address2_i(ra2),
                      .write_address_i(wa),
                      .write_data_i(wd),
                      .ctrl_reg_write_i(reg_write),
                      .read_data1_o(rd1),
                      .read_data2_o(rd2));

    initial begin
        #50  reg_write = 1; ra1 = 1; ra2 = 2; wa = 3; wd = 32'haaaaaaaa;
        #100 ra1 = 3; ra2 = 3; wa = 4; wd = 32'h55555555;
        #100 ra1 = 4; ra2 = 5; wa = 5; wd = 32'h12345678;
        #100 ra1 = 5; ra2 = 4; wa = 6; wd = 32'h87654321;
        #100 ra1 = 6; ra2 = 0; wa = 1; wd = 32'h11111111;
        #100 ra1 = 1; ra2 = 6; wa = 2; wd = 32'h22222222;
        #100 ra1 = 1; ra2 = 2; wa = 7; wd = 32'h77777777;
        #100 reg_write = 0; ra1 = 1; ra2 = 2; wa = 8; wd = 32'haaaaaaaa;
        #100 ra1 = 3; ra2 = 4; wa = 9; wd = 32'h11111111;
        #100 ra1 = 5; ra2 = 6; wa = 10; wd = 32'hbbbbbbbb;
        #100 ra1 = 7; ra2 = 8; wa = 11; wd = 32'hcccccccc;
        #100 ra1 = 9; ra2 = 10; wa = 11; wd = 32'hdddddddd;
        #1000 $stop;
    end

endmodule
