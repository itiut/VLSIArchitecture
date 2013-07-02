module fft008(
              fo_000,fo_001,fo_002,fo_003,fo_004,fo_005,fo_006,fo_007,
              xi_000,xi_001,xi_002,xi_003,xi_004,xi_005,xi_006,xi_007,
              Wi000,Wi001,Wi002,Wi003,ck);
    input ck;
    output [31:0]
                  fo_000,fo_001,fo_002,fo_003,fo_004,fo_005,fo_006,fo_007;
    input [31:0]
                 xi_000,xi_001,xi_002,xi_003,xi_004,xi_005,xi_006,xi_007;
    input [31:0]
                 Wi000,Wi001,Wi002,Wi003;
    reg [31:0]
               x_000,x_001,x_002,x_003,x_004,x_005,x_006,x_007;
    reg [31:0]
               W000,W001,W002,W003;
    reg [31:0]
               fo_000,fo_001,fo_002,fo_003,fo_004,fo_005,fo_006,fo_007;
    wire [31:0]
                f_000,f_001,f_002,f_003,f_004,f_005,f_006,f_007;
    wire [31:0]
               x_00_000,x_00_001,x_00_002,x_00_003,x_00_004,x_00_005,x_00_006,x_00_007,
               x_01_000,x_01_001,x_01_002,x_01_003,x_01_004,x_01_005,x_01_006,x_01_007,
               x_02_000,x_02_001,x_02_002,x_02_003,x_02_004,x_02_005,x_02_006,x_02_007,
               x_03_000,x_03_001,x_03_002,x_03_003,x_03_004,x_03_005,x_03_006,x_03_007;
    assign x_00_000 = x_000;
    assign x_00_001 = x_001;
    assign x_00_002 = x_002;
    assign x_00_003 = x_003;
    assign x_00_004 = x_004;
    assign x_00_005 = x_005;
    assign x_00_006 = x_006;
    assign x_00_007 = x_007;
    assign x_00_000 = x_000;
    assign x_00_001 = x_001;
    assign x_00_002 = x_002;
    assign x_00_003 = x_003;
    assign x_00_004 = x_004;
    assign x_00_005 = x_005;
    assign x_00_006 = x_006;
    assign x_00_007 = x_007;
    always @(posedge ck) begin
        x_000 <= xi_000;
        fo_000 <= f_000;
        x_001 <= xi_001;
        fo_001 <= f_001;
        x_002 <= xi_002;
        fo_002 <= f_002;
        x_003 <= xi_003;
        fo_003 <= f_003;
        x_004 <= xi_004;
        fo_004 <= f_004;
        x_005 <= xi_005;
        fo_005 <= f_005;
        x_006 <= xi_006;
        fo_006 <= f_006;
        x_007 <= xi_007;
        fo_007 <= f_007;
        W000 <= Wi000;
        W001 <= Wi001;
        W002 <= Wi002;
        W003 <= Wi003;
    end
    butt2 xx_00_000( .x0(x_00_000), .x1(x_00_004), .y0(x_01_000), .y1(x_01_004), .W(W000) );
    butt2 xx_00_001( .x0(x_00_002), .x1(x_00_006), .y0(x_01_002), .y1(x_01_006), .W(W000) );
    butt2 xx_00_002( .x0(x_00_001), .x1(x_00_005), .y0(x_01_001), .y1(x_01_005), .W(W000) );
    butt2 xx_00_003( .x0(x_00_003), .x1(x_00_007), .y0(x_01_003), .y1(x_01_007), .W(W000) );
    butt2 xx_01_000( .x0(x_01_000), .x1(x_01_002), .y0(x_02_000), .y1(x_02_002), .W(W000) );
    butt2 xx_01_001( .x0(x_01_004), .x1(x_01_006), .y0(x_02_004), .y1(x_02_006), .W(W002) );
    butt2 xx_01_002( .x0(x_01_001), .x1(x_01_003), .y0(x_02_001), .y1(x_02_003), .W(W000) );
    butt2 xx_01_003( .x0(x_01_005), .x1(x_01_007), .y0(x_02_005), .y1(x_02_007), .W(W002) );
    butt2 xx_02_000( .x0(x_02_000), .x1(x_02_001), .y0(x_03_000), .y1(x_03_001), .W(W000) );
    assign f_000 = x_03_000;
    assign f_004 = x_03_001;
    butt2 xx_02_001( .x0(x_02_004), .x1(x_02_005), .y0(x_03_004), .y1(x_03_005), .W(W001) );
    assign f_001 = x_03_004;
    assign f_005 = x_03_005;
    butt2 xx_02_002( .x0(x_02_002), .x1(x_02_003), .y0(x_03_002), .y1(x_03_003), .W(W002) );
    assign f_002 = x_03_002;
    assign f_006 = x_03_003;
    butt2 xx_02_003( .x0(x_02_006), .x1(x_02_007), .y0(x_03_006), .y1(x_03_007), .W(W003) );
    assign f_003 = x_03_006;
    assign f_007 = x_03_007;
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
module butt2(y0,y1,x0,x1,W);
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
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
module top;
    wire [31:0]
                f_000,f_001,f_002,f_003,f_004,f_005,f_006,f_007;
    reg [31:0]
               x_000,x_001,x_002,x_003,x_004,x_005,x_006,x_007;
    reg [31:0]
               W000,W001,W002,W003;
    reg ck;
    fft008 f(
             f_000,f_001,f_002,f_003,f_004,f_005,f_006,f_007,
             x_000,x_001,x_002,x_003,x_004,x_005,x_006,x_007,
             W000,W001,W002,W003,ck);
    always #10 ck<=~ck;
    initial begin
        $dumpfile("fft.vcd");
        $dumpvars;
        ck<=0;
        W000 = { 16'b 0000100000000000, 16'b 0000000000000000 };
        W001 = { 16'b 0000010110101000, 16'b 1111101001011000 };
        W002 = { 16'b 0000000000000000, 16'b 1111100000000001 };
        W003 = { 16'b 1111101001011000, 16'b 1111101001011000 };
        #100
          ////////
        x_000 = { 16'b 0000000000000000, 16'b 0000000000000000 };   //   0.000,  0.000
        x_001 = { 16'b 0000011101011010, 16'b 0000000000000000 };   //   0.919,  0.000
        x_002 = { 16'b 0000101001100110, 16'b 0000000000000000 };   //   1.300,  0.000
        x_003 = { 16'b 0000011101011010, 16'b 0000000000000000 };   //   0.919,  0.000
        x_004 = { 16'b 0000000000000000, 16'b 0000000000000000 };   //   0.000,  0.000
        x_005 = { 16'b 1111100010100110, 16'b 0000000000000000 };   //  -0.919,  0.000
        x_006 = { 16'b 1111010110011010, 16'b 0000000000000000 };   //  -1.300,  0.000
        x_007 = { 16'b 1111100010100110, 16'b 0000000000000000 };   //  -0.919,  0.000
        #100
          $display( "f_000=%h", f_000);
        $display( "f_001=%h", f_001);
        $display( "f_002=%h", f_002);
        $display( "f_003=%h", f_003);
        $display( "f_004=%h", f_004);
        $display( "f_005=%h", f_005);
        $display( "f_006=%h", f_006);
        $display( "f_007=%h", f_007);
        #100
          ////////
        x_000 = { 16'b 0000000000000000, 16'b 0000000000000000 };   //   0.000,  0.000
        x_001 = { 16'b 0000101001100110, 16'b 0000000000000000 };   //   1.300,  0.000
        x_002 = { 16'b 0000000000000000, 16'b 0000000000000000 };   //   0.000,  0.000
        x_003 = { 16'b 1111010110011010, 16'b 0000000000000000 };   //  -1.300,  0.000
        x_004 = { 16'b 0000000000000000, 16'b 0000000000000000 };   //  -0.000,  0.000
        x_005 = { 16'b 0000101001100110, 16'b 0000000000000000 };   //   1.300,  0.000
        x_006 = { 16'b 0000000000000000, 16'b 0000000000000000 };   //   0.000,  0.000
        x_007 = { 16'b 1111010110011010, 16'b 0000000000000000 };   //  -1.300,  0.000
        #100
          $display( "f_000=%h", f_000);
        $display( "f_001=%h", f_001);
        $display( "f_002=%h", f_002);
        $display( "f_003=%h", f_003);
        $display( "f_004=%h", f_004);
        $display( "f_005=%h", f_005);
        $display( "f_006=%h", f_006);
        $display( "f_007=%h", f_007);
        #100
          $finish;
    end
endmodule
