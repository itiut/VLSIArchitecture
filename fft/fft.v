module top;
    reg [31:0] x0,x1,x2,x3,x4,x5,x6,x7;
    wire [31:0] f0,f1,f2,f3,f4,f5,f6,f7;
    reg [31:0] W0, W1, W2, W3;

    fft f(f0,f1,f2,f3,f4,f5,f6,f7,x0,x1,x2,x3,x4,x5,x6,x7, W0, W1, W2, W3);

    initial begin
        //  $monitor( "%b_%b, %b_%b, %b_%b", a[31:16], a[15:0], b[31:16], b[15:0], c[31:16], c[15:0]);
        $dumpfile("fft.vcd");
        $dumpvars;

        //  W0 = {16'b 0_0001_00000000000, 16'b 0_0000_00000000000 };
        //  W1 = {16'b 0_0001_01101001000, 16'b 0_0000_01101001000 };
        //  W2 = {16'b 0_0000_00000000000, 16'b 0_0001_00000000000 };
        //  W3 = {16'b 1_1110_10010111000, 16'b 0_0000_01101001000 };
        W0 = {16'h 0800, 16'h 0000};
        W1 = {16'h 05a8, 16'h f5a8};
        W2 = {16'h 0000, 16'h F801};
        W3 = {16'h fa58, 16'h f5a8};

        $display( "W0=%h\nW1=%h\nW2=%h\nW3=%h\n", W0, W1, W2, W3 );
        #100
          x0 = {16'b 0000000000000000, 16'b 0_0000_00000000000 };
        x1 = {16'b 0000011111111111, 16'b 0_0000_00000000000 };
        x2 = {16'b 0000000000000000, 16'b 0_0000_00000000000 };
        x3 = {16'b 1111100000000001, 16'b 0_0000_00000000000 };
        x4 = {16'b 0000000000000000, 16'b 0_0000_00000000000 };
        x5 = {16'b 0000011111111111, 16'b 0_0000_00000000000 };
        x6 = {16'b 0000000000000000, 16'b 0_0000_00000000000 };
        x7 = {16'b 1111100000000001, 16'b 0_0000_00000000000 };


        #100
          $display( "x0=%h\nx1=%h\nx2=%h\nx3=%h\nx4=%h\nx5=%h\nx6=%h\nx7=%h\n", x0,x1,x2,x3,x4,x5,x6,x7 );
        $display( "f0=%h\nf1=%h\nf2=%h\nf3=%h\nf4=%h\nf5=%h\nf6=%h\nf7=%h\n", f0,f1,f2,f3,f4,f5,f6,f7 );
        x0 = {16'b 0000000000000000, 16'b 0_0000_00000000000 };
        x1 = {16'b 0000010110101000, 16'b 0_0000_00000000000 };
        x2 = {16'b 0000011111111111, 16'b 0_0000_00000000000 };
        x3 = {16'b 0000010110101000, 16'b 0_0000_00000000000 };
        x4 = {16'b 0000000000000000, 16'b 0_0000_00000000000 };
        x5 = {16'b 1111101001011000, 16'b 0_0000_00000000000 };
        x6 = {16'b 1111100000000001, 16'b 0_0000_00000000000 };
        x7 = {16'b 1111101001011000, 16'b 0_0000_00000000000 };



        //  a={16'b 0_0110_00110011000, 16'b 0_0011_00000111100};
        //  b={16'b 0_0111_00110011000, 16'b 0_0010_00000111100};
        #100
          $display( "x0=%h\nx1=%h\nx2=%h\nx3=%h\nx4=%h\nx5=%h\nx6=%h\nx7=%h\n", x0,x1,x2,x3,x4,x5,x6,x7 );
        $display( "f0=%h\nf1=%h\nf2=%h\nf3=%h\nf4=%h\nf5=%h\nf6=%h\nf7=%h\n", f0,f1,f2,f3,f4,f5,f6,f7 );

        x0 = {$random};    x1 = {$random};    x2 = {$random};    x3 = {$random};
        x4 = {$random};    x5 = {$random};    x6 = {$random};    x7 = {$random};
        #100
          x0 = {$random};    x1 = {$random};    x2 = {$random};    x3 = {$random};
        x4 = {$random};    x5 = {$random};    x6 = {$random};    x7 = {$random};
        #100
          x0 = {$random};    x1 = {$random};    x2 = {$random};    x3 = {$random};
        x4 = {$random};    x5 = {$random};    x6 = {$random};    x7 = {$random};
        #100
          $finish;

    end
endmodule


module fft(f0,f1,f2,f3,f4,f5,f6,f7,x0,x1,x2,x3,x4,x5,x6,x7, W0, W1, W2, W3);
    input [31:0] x0,x1,x2,x3,x4,x5,x6,x7;
    input [31:0] W0, W1, W2, W3;
    output [31:0] f0,f1,f2,f3,f4,f5,f6,f7;
    wire [31:0] x10,x11,x12,x13,x14,x15,x16,x17;
    wire [31:0] x20,x21,x22,x23,x24,x25,x26,x27, x266, x133, x177, x244, x255, x277;


    assign x10 = addc( x0, x4);
    assign x11 = subc( x0, x4);
    assign x12 = addc( x2, x6);
    assign x133 = subc( x2, x6);
    assign x13 = mulc(x133, W2);
    assign x14 = addc( x1, x5);
    assign x15 = subc( x1, x5);
    assign x16 = addc( x3, x7);
    assign x177 = subc( x3, x7);
    assign x17 = mulc(x177, W2);

    assign x20 = addc( x10, x12 );
    assign x22 = subc( x10, x12 );
    assign x21 = addc( x11, x13 );
    assign x23 = subc( x11, x13 );
    assign x244 = addc( x14, x16 );
    assign x24 = mulc( x244, W0);
    assign x266 = subc( x14, x16 );
    assign x26 = mulc( x266, W2);

    assign x255 = addc( x15, x17 );
    assign x25 = mulc( x255, W1);
    assign x277 = subc( x15, x17 );
    assign x27 = mulc( x277, W3);

    assign f0 = addc( x20, x24 );
    assign f1 = addc( x21, x25 );
    assign f2 = addc( x22, x26 );
    assign f3 = addc( x23, x27 );
    assign f4 = subc( x20, x24 );
    assign f5 = subc( x21, x25 );
    assign f6 = subc( x22, x26 );
    assign f7 = subc( x23, x27 );


    function [31:0] addc;
        input [31:0] a, b;
        reg [15:0] yr, yi;
        begin
            yr = a[31:16] + b[31:16];
            yi = a[15:0] + b[15:0];
            addc = {yr, yi};
        end
    endfunction
    function [31:0] subc;
        input [31:0] a, b;
        reg [15:0] yr, yi;
        begin
            yr = a[31:16] - b[31:16];
            yi = a[15:0] - b[15:0];
            subc = {yr, yi};
        end
    endfunction
    function [31:0] mulc;
        input [31:0] a, b;
        reg [31:0] yr1, yr2, yi1, yi2;
        reg [15:0] ar, ai, br, bi, yyr1, yyr2, yyi1, yyi2, yr, yi;
        begin
            if( a[31] == 0 ) ar = a[31:16]; else ar = ~(a[31:16]-1);
            if( a[15] == 0 ) ai = a[15:0]; else ai = ~(a[15:0]-1);
            if( b[31] == 0 ) br = b[31:16]; else br = ~(b[31:16]-1);
            if( b[15] == 0 ) bi = b[15:0]; else bi = ~(b[15:0]-1);


            yr1 = ar * br;
            yr2 = ai * bi;

            yi1 = ar * bi;
            yi2 = ai * br;

            if( (a[31]^b[31])==0 ) yyr1 = yr1[26:11]; else yyr1 = ~yr1[26:11] + 1;
            if( (a[15]^b[15])==0 ) yyr2 = yr2[26:11]; else yyr2 = ~yr2[26:11] + 1;
            yr = yyr1 - yyr2;

            if( (a[31]^b[15])==0 ) yyi1 = yi1[26:11]; else yyi1 = ~yi1[26:11] + 1;
            if( (a[15]^b[31])==0 ) yyi2 = yi2[26:11]; else yyi2 = ~yi2[26:11] + 1;
            yi = yyi1 + yyi2;

            mulc = {yr, yi};
        end
    endfunction
endmodule
