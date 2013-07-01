module simdes;

    reg ck, keyin, datin;
    wire keyready;
    reg [63:0] k;
    reg [63:0] ptxt;
    wire [63:0] etxt;
    reg f;

    des d(ck, keyin, k, datin, ptxt, etxt, f);

    initial begin
        $dumpfile("des.vcd");
        $dumpvars;
          ck=0;
        #25
          keyin = 1; f = 1;
        k    = 64'b 11011010_10110111_10000011_10000101_01111101_11001110_11010011_11001000;
        ptxt = 64'b 00101110_11001110_10100110_00101010_00101110_11001110_10100110_00101010;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;
        #100

        $display( "KEYin =\t%h", k );
        $display( "PC1=\t%h", d.PC1 );
        $display( "KS01=\t%h", d.KS01 );
        $display( "KS02=\t%h", d.KS02 );
        $display( "KS03=\t%h", d.KS03 );
        $display( "KS04=\t%h", d.KS04 );
        $display( "KS05=\t%h", d.KS05 );
        $display( "KS06=\t%h", d.KS06 );
        $display( "KS07=\t%h", d.KS07 );
        $display( "KS08=\t%h", d.KS08 );
        $display( "KS09=\t%h", d.KS09 );
        $display( "KS10=\t%h", d.KS10 );
        $display( "KS11=\t%h", d.KS11 );
        $display( "KS12=\t%h", d.KS12 );
        $display( "KS13=\t%h", d.KS13 );
        $display( "KS14=\t%h", d.KS14 );
        $display( "KS15=\t%h", d.KS15 );
        $display( "KS16=\t%h\n", d.KS16 );

        $display( "ptext=\t%h", ptxt );
        $display( "IP1=\t%h", d.IP1 );
        $display( "IP2=\t%h", d.IP2 );
        $display( "IP3=\t%h", d.IP3 );
        $display( "IP4=\t%h", d.IP4 );
        $display( "IP5=\t%h", d.IP5 );
        $display( "IP6=\t%h", d.IP6 );
        $display( "IP7=\t%h", d.IP7 );
        $display( "IP8=\t%h", d.IP8 );
        $display( "IP9=\t%h", d.IP9 );
        $display( "IP10=\t%h", d.IP10 );
        $display( "IP11=\t%h", d.IP11 );
        $display( "IP12=\t%h", d.IP12 );
        $display( "IP13=\t%h", d.IP13 );
        $display( "IP14=\t%h", d.IP14 );
        $display( "IP15=\t%h", d.IP15 );
        $display( "IP16=\t%h", d.IP16 );
        $display( "IP17=\t%h", d.IP17 );
        $display( "LR=\t%h", d.LR );
        $display( "enc=\t%h", etxt );
        #20     keyin = 1;f=0;  ptxt = etxt;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;


        #20     keyin = 1; f=1; ptxt = {$random, $random};
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;
        #20     keyin = 1; f=0;     ptxt = etxt;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;

        #20     keyin = 1; f=1; ptxt = {$random, $random};
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;
        #20     keyin = 1; f=0;     ptxt = etxt;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;

        #20     keyin = 1; f=1; ptxt = {$random, $random};
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;
        #20     keyin = 1; f=0;     ptxt = etxt;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;

        #20     keyin = 1; f=1; ptxt = {$random, $random};
        #20     keyin = 0;
        #20     keyin = 1; f=0;     ptxt = etxt;
        #20     keyin = 0;


        #1000 $finish;

    end

    always #10 ck = ~ck;

endmodule
