module simdes_pipeline;

    reg ck, keyin, datin;
    wire keyready;
    reg [63:0] k;
    reg [63:0] ptxt;
    wire [63:0] etxt;
    reg f;

    reg [63:0] p1, p2, p3, e1, e2, e3, ee1, ee2, ee3;

    des d(ck, keyin, k, datin, ptxt, etxt, f);

    initial begin
        ck=0;
        #25
          keyin = 1; f = 1;
        k    = 64'b 11011010_10110111_10000011_10000101_01111101_11001110_11010011_11001000;
        ptxt = 64'b 00101110_11001110_10100110_00101010_00101110_11001110_10100110_00101010;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;

        #100    keyin = 1;f=0;  ptxt = etxt;
        #20     keyin = 0;
        #20     datin = 1;
        #20     datin = 0;

        #100    f=1; keyin = 1;
        #20     keyin = 0;
        #20     ptxt = {$random, $random}; p1 = ptxt; datin = 1;
        #20     ptxt = {$random, $random}; p2 = ptxt;
        #20     ptxt = {$random, $random}; p3 = ptxt;
        #20     datin = 0;
        #20     e1 = etxt;
        #20     e2 = etxt;
        #20     e3 = etxt;

        #100    f = 0; keyin = 1;
        #20     keyin = 0;
        #20     ptxt = e1; datin = 1;
        #20     ptxt = e2;
        #20     ptxt = e3;
        #20     datin = 0;
        #20     ee1 = etxt;
        #20     ee2 = etxt;
        #20     ee3 = etxt;

        #1000 $finish;
    end

    always #10 ck = ~ck;

endmodule
