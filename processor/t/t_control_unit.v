module t_control_unit;
    reg clk;
    reg n_rst;

    initial begin
        clk <= 0;
        n_rst <= 1;
    end

    always #50 clk = ~clk;

    reg [31:0] ir;
    wire reg_dst;
    wire alu_src;
    wire branch;
    wire [1:0] mem_read;
    wire [1:0] mem_write;
    wire reg_write;
    wire mem_to_reg;

    control_unit control_unit(.ir_i(ir),
                              .reg_dst_o(reg_dst),
                              .alu_src_o(alu_src),
                              .branch_o(branch),
                              .mem_read_o(mem_read),
                              .mem_write_o(mem_write),
                              .reg_write_o(reg_write),
                              .mem_to_reg_o(mem_to_reg));

    initial begin
        #100 ir <= 32'b_000001_00000_00001_0000000000000001_; // addi
        // #100 ir <= 32'b_000001_00000_00010_0000000000000010_;
        // #100 ir <= 32'b_000001_00000_00011_0000000000000011_;
        // #100 ir <= 32'b_000001_00000_00100_0000000000000100_;
        // #100 ir <= 32'b_000001_00000_00101_0000000000000101_;
        // #100 ir <= 32'b_000001_00000_00110_0000000000000110_;
        // #100 ir <= 32'b_000001_00000_00111_0000000000000111_;
        // #100 ir <= 32'b_000001_00000_01001_0000000000001001_;
        // #100 ir <= 32'b_000001_00000_01100_0000000000001100_;
        // #100 ir <= 32'b_000001_00000_01110_0000000000001110_;
        // #100 ir <= 32'b_000001_00000_01111_0000000000001111_;
        #100 ir <= 32'b_000000_00111_01100_10011_00000000000_; // add
        // #100 ir <= 32'b_000001_00000_11110_0000000000011110_;
        #100 ir <= 32'b_000000_00100_00110_00111_00000000010_; // sub
        #100 ir <= 32'b_000011_00000_01000_0000000000001100_;  // lui
        #100 ir <= 32'b_000000_01000_01001_01010_00000001000_; // and
        #100 ir <= 32'b_000100_01010_01011_0000000000001111_;  // andi
        #100 ir <= 32'b_000000_01011_01100_01101_00000001001_; // or
        #100 ir <= 32'b_000000_01110_01111_10000_00000001010_; // xor
        #100 ir <= 32'b_000110_10000_10001_0000000000011111_;  // xori
        #100 ir <= 32'b_000101_01111_10010_0000000000000111_;  // ori
        #100 ir <= 32'b_000000_10010_10011_10100_00000001011_; // nor
        #100 ir <= 32'b_100000_01000_00111_1111111111110110_;  // beq
        #100 ir <= 32'b_000000_10100_00000_10101_00101_010000_; // sll
        #100 ir <= 32'b_000000_10101_00000_10110_00011_010010_; // sra
        #100 ir <= 32'b_000000_10110_00000_10111_00010_010001_; // srl
        #100 ir <= 32'b_100001_01010_01001_0000000000000000_;   // bne
        #100 ir <= 32'b_011000_00001_00010_0000000000000000_;   // sw
        #100 ir <= 32'b_011100_00101_00110_1111111111110110_;   // sb
        #100 ir <= 32'b_011010_00011_00100_0000000000001000_;   // sh
        #100 ir <= 32'b_010000_00001_11001_0000000000000000_;   // lw
        #100 ir <= 32'b_010010_00101_11011_1111111111110110_;   // lh
        #100 ir <= 32'b_010100_00011_11101_0000000000001000_;   // lb
        #100 ir <= 32'b_100010_01100_01011_0000000000000011_;   // blt
        #100 ir <= 32'b_100011_01110_01101_1111111111111011_;   // ble
        #100 ir <= 32'b_101000_00000000000000000000001011_;     // j
        #100 ir <= 32'b_101001_00000000000000000000001011_;     // jal
        #100 ir <= 32'b_101010_11111_00000_00000_00000000000_;  // jr
        #1000 $stop;
    end

endmodule
