module top;
    reg ck;
    reg rst;
    reg [31:0] x0,x1,x2,x3,x4,x5,x6,x7;
    wire [31:0] f0,f1,f2,f3,f4,f5,f6,f7;
    reg [31:0] W0, W1, W2, W3;

    fft f(ck, rst, f0,f1,f2,f3,f4,f5,f6,f7,x0,x1,x2,x3,x4,x5,x6,x7, W0, W1, W2, W3);

    always #5 ck=~ck;

    initial begin
        //  $monitor( "%b_%b, %b_%b, %b_%b", a[31:16], a[15:0], b[31:16], b[15:0], c[31:16], c[15:0]);
        $dumpfile("fft.vcd");
        $dumpvars;
        //  $monitor( "f0: %d.%d_%d.%d", f0[31:27], f0[26:16], f0[15:11], f0[11:0] );
        //  $monitor( "x0: %d.%d_%d.%d", xr0, x0[26:16], xi0, x0[10:0] );


        W0 = {16'b 0_0001_00000000000, 16'b 0_0000_00000000000 };
        W1 = {16'b 0_0001_01101001000, 16'b 0_0000_01101001000 };
        W2 = {16'b 0_0000_00000000000, 16'b 0_0001_00000000000 };
        W3 = {16'b 1_1110_10010111000, 16'b 0_0000_01101001000 };
        ck=0;
        rst=0;
        #10 rst=1;
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

        //  a={16'b 0_0110_00110011000, 16'b 0_0011_00000111100};
        //  b={16'b 0_0111_00110011000, 16'b 0_0010_00000111100};
        #100
          x0 = {$random};    x1 = {$random};    x2 = {$random};    x3 = {$random};
        x4 = {$random};    x5 = {$random};    x6 = {$random};    x7 = {$random};
        rst = 0;
        #10 rst=1;

        #100
          x0 = {$random};    x1 = {$random};    x2 = {$random};    x3 = {$random};
        x4 = {$random};    x5 = {$random};    x6 = {$random};    x7 = {$random};
        rst = 0;
        #10 rst=1;

        #100
          x0 = {$random};    x1 = {$random};    x2 = {$random};    x3 = {$random};
        x4 = {$random};    x5 = {$random};    x6 = {$random};    x7 = {$random};
        rst = 0;
        #10 rst=1;

        #100
          $finish;



    end

endmodule


module butt(y0,y1,x0,x1,W);
    input [31:0] x0,x1,W;
    output[31:0] y0,y1;

    wire [31:0] x11;

    assign x11 = mulc(x1, W);
    assign y0 = addc( x0, x11 );
    assign y1 = subc( x0, x11 );

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
    //  function [31:0] mulc;
    //    input [31:0] a, b;
    //    reg [15:0] yr, yi;
    //    begin
    //      yr = a[31:16]*b[31:16] - a[15:0]*b[15:0];
    //      yi = a[15:0]*b[31:16] + a[31:16]*b[15:0];
    //      mulc = {yr, yi};
    //    end
    //  endfunction
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


module fft(ck,rst,f0,f1,f2,f3,f4,f5,f6,f7, x0,x1,x2,x3,x4,x5,x6,x7,W0, W1, W2, W3);
    input rst;
    input [31:0] x0,x1,x2,x3,x4,x5,x6,x7;
    input [31:0] W0, W1, W2, W3;
    output [31:0] f0,f1,f2,f3,f4,f5,f6,f7;
    reg [31:0] x10,x11,x12,x13,x14,x15,x16,x17;
    reg [31:0] wa, wb, wc, wd;
    reg [31:0] f0,f1,f2,f3,f4,f5,f6,f7;

    input ck;
    reg [2:0] st;

    wire [31:0] xo0,xo1,xo2,xo3,xo4,xo5,xo6,xo7;

    butt b10( xo0, xo1, x10, x11, wa );
    butt b11( xo2, xo3, x12, x13, wb );
    butt b12( xo4, xo5, x14, x15, wc );
    butt b13( xo6, xo7, x16, x17, wd );


    always @(posedge ck) begin
        if( !rst ) begin
            st <= 0;
        end else begin
            case( st )
                'b 000:
                  begin
                      x10 <= x0;
                      x11 <= x4;
                      x12 <= x2;
                      x13 <= x6;
                      x14 <= x1;
                      x15 <= x5;
                      x16 <= x3;
                      x17 <= x7;
                      wa <= W0;
                      wb <= W0;
                      wc <= W0;
                      wd <= W0;
                      st <= 'b 001;
                  end
                'b 001:
                  begin
                      x10 <= xo0;
                      x11 <= xo2;
                      x12 <= xo1;
                      x13 <= xo3;
                      x14 <= xo4;
                      x15 <= xo6;
                      x16 <= xo5;
                      x17 <= xo7;
                      wa <= W0;
                      wb <= W2;
                      wc <= W0;
                      wd <= W2;
                      st <= 'b 010;
                  end
                'b 010:
                  begin
                      x10 <= xo0;
                      x11 <= xo4;
                      x12 <= xo2;
                      x13 <= xo6;
                      x14 <= xo1;
                      x15 <= xo5;
                      x16 <= xo3;
                      x17 <= xo7;
                      wa <= W0;
                      wb <= W1;
                      wc <= W2;
                      wd <= W3;
                      st <= 'b 011;
                  end
                'b 011:
                  begin
                      f0 <= xo0;
                      f1 <= xo2;
                      f2 <= xo4;
                      f3 <= xo6;
                      f4 <= xo1;
                      f5 <= xo3;
                      f6 <= xo5;
                      f7 <= xo7;
                      st <= 'b 00;
                  end
            endcase
        end
    end
endmodule
