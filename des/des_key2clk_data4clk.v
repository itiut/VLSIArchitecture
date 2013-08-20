module des(ck,keyin,k,datin,p,e,f);
    input   ck, keyin, datin;
    input   f;
    input   [64:1]  p, k;
    output  [64:1]  e;

    reg [4:0] kst;
    reg [48:1] KS01, KS02, KS03, KS04, KS05, KS06, KS07, KS08, KS09, KS10,
               KS11, KS12, KS13, KS14, KS15, KS16;
    reg [56:1] PC1, CD1;
    reg [64:1] IP1, IP2, IP3, IP4, IP5,IP6, IP7, IP8, IP9, IP10, IP11, IP12, IP13, IP14, IP15, IP16,IP17, LR, e;

    reg [1:0] key_state;
    reg [3:0] data_state;

    always @(posedge ck) begin
        key_state = key_state + 1;
        data_state = data_state << 1;
        if (keyin == 1) begin
            key_state = 2'b01;
        end else if (datin == 1) begin
            data_state[0] = 1'b1;
        end

        case (key_state)
            2'b01: begin
                PC1[56:1] = { k[4],k[12],k[20],k[28],k[5],k[13],k[21],
                              k[29],k[37],k[45],k[53],k[61],k[6],k[14],
                              k[22],k[30],k[38],k[46],k[54],k[62],k[7],
                              k[15],k[23],k[31],k[39],k[47],k[55],k[63],

                              k[36],k[44],k[52],k[60],k[3],k[11],k[19],
                              k[27],k[35],k[43],k[51],k[59],k[2],k[10],
                              k[18],k[26],k[34],k[42],k[50],k[58],k[1],
                              k[9],k[17],k[25],k[33],k[41],k[49],k[57] };
                if (f == 1) begin
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS01[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS02[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS03[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS04[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS05[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS06[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS07[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS08[48:1] = PC2(PC1[56:1]);
                end else begin
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS16[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS15[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS14[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS13[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS12[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS11[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS10[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS09[48:1] = PC2(PC1[56:1]);
                end
            end
            2'b10: begin
                if (f == 1) begin
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS09[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS10[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS11[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS12[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS13[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS14[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS15[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS16[48:1] = PC2(PC1[56:1]);
                end else begin
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS08[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS07[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS06[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS05[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS04[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS03[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[30:29], PC1[56:31],PC1[2:1],PC1[28:3] };  KS02[48:1] = PC2(PC1[56:1]);
                    PC1[56:1] = { PC1[29], PC1[56:30],PC1[1],PC1[28:2] };   KS01[48:1] = PC2(PC1[56:1]);
                end
            end
        endcase

        if (data_state[0]) begin
            IP1[64:1] <= { p[7],  p[15], p[23], p[31], p[39], p[47], p[55], p[63],
                           p[5],  p[13], p[21], p[29], p[37], p[45], p[53], p[61],
                           p[3],  p[11], p[19], p[27], p[35], p[43], p[51], p[59],
                           p[1],  p[9],  p[17], p[25], p[33], p[41], p[49], p[57],
                           p[8],  p[16], p[24], p[32], p[40], p[48], p[56], p[64],
                           p[6],  p[14], p[22], p[30], p[38], p[46], p[54], p[62],
                           p[4],  p[12], p[20], p[28], p[36], p[44], p[52], p[60],
                           p[2],  p[10], p[18], p[26], p[34], p[42], p[50], p[58] };
        end
        if (data_state[1]) begin
            IP2 = des1( IP1, KS01 );
            IP3 = des1( IP2, KS02 );
            IP4 = des1( IP3, KS03 );
            IP5 = des1( IP4, KS04 );
            IP6 = des1( IP5, KS05 );
            IP7 = des1( IP6, KS06 );
            IP8 = des1( IP7, KS07 );
            IP9 <= des1( IP8, KS08 );
        end
        if (data_state[2]) begin
            IP10 = des1( IP9, KS09 );
            IP11 = des1( IP10, KS10 );
            IP12 = des1( IP11, KS11 );
            IP13 = des1( IP12, KS12 );
            IP14 = des1( IP13, KS13 );
            IP15 = des1( IP14, KS14 );
            IP16 = des1( IP15, KS15 );
            IP17 = des1( IP16, KS16 );
            LR <= {IP17[32:1], IP17[64:33]};
        end
        if (data_state[3]) begin
            // R=IP1[64:33], L=IP[32:1]
            e <= { LR[25], LR[57], LR[17], LR[49], LR[9], LR[41], LR[1], LR[33],
                   LR[26], LR[58], LR[18], LR[50], LR[10], LR[42], LR[2], LR[34],
                   LR[27], LR[59], LR[19], LR[51], LR[11], LR[43], LR[3], LR[35],
                   LR[28], LR[60], LR[20], LR[52], LR[12], LR[44], LR[4], LR[36],
                   LR[29], LR[61], LR[21], LR[53], LR[13], LR[45], LR[5], LR[37],
                   LR[30], LR[62], LR[22], LR[54], LR[14], LR[46], LR[6], LR[38],
                   LR[31], LR[63], LR[23], LR[55], LR[15], LR[47], LR[7], LR[39],
                   LR[32], LR[64], LR[24], LR[56], LR[16], LR[48], LR[8], LR[40] };
        end
    end

    function [63:0] des1;
        input [64:1] IP;
        input [48:1] KS;
        reg [48:1] R, RK;
        reg [32:1] RS,P;

        begin
            R[48:1] = e2(IP[64:33]);
            RK[48:1] = R^KS;
            RS[4:1]=s1(RK[6:1]);
            RS[8:5]=s2(RK[12:7]);
            RS[12:9]=s3(RK[18:13]);
            RS[16:13]=s4(RK[24:19]);
            RS[20:17]=s5(RK[30:25]);
            RS[24:21]=s6(RK[36:31]);
            RS[28:25]=s7(RK[42:37]);
            RS[32:29]=s8(RK[48:43]);
            P[32:1] = { RS[25], RS[4], RS[11], RS[22], RS[6], RS[30], RS[13], RS[19],
                        RS[9], RS[3], RS[27], RS[32], RS[14], RS[24], RS[8], RS[2],
                        RS[10], RS[31], RS[18], RS[5], RS[26], RS[23], RS[15], RS[1],
                        RS[17], RS[28], RS[12], RS[29], RS[21], RS[20], RS[7], RS[16] };
            des1 = { IP[32:1]^P , IP[64:33] };
        end
    endfunction

    function [3:0] s1;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 14;  1: s = 4;   2: s = 13;  3: s = 1;
                        4: s = 2;   5: s = 15;  6: s = 11;  7: s = 8;
                        8: s = 3;   9: s = 10;  10: s = 6;  11: s = 12;
                        12: s = 5;  13: s = 9;  14: s = 0;  15: s = 7;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 0;   1: s = 15;  2: s = 7;   3: s = 4;
                        4: s = 14;  5: s = 2;   6: s = 13;  7: s = 1;
                        8: s = 10;  9: s = 6;   10: s = 12;     11: s = 11;
                        12: s = 9;  13: s = 5;  14: s = 3;  15: s = 8;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 4;   1: s = 1;   2: s = 14;  3: s = 8;
                        4: s = 13;  5: s = 6;   6: s = 2;   7: s = 11;
                        8: s = 15;  9: s = 12;  10: s = 9;  11: s = 7;
                        12: s = 3;  13: s = 10;     14: s = 5;  15: s = 0;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 15;  1: s = 12;  2: s = 8;   3: s = 2;
                        4: s = 4;   5: s = 9;   6: s = 1;   7: s = 7;
                        8: s = 5;   9: s = 11;  10: s = 3;  11: s = 14;
                        12: s = 10;     13: s = 0;  14: s = 6;  15: s = 13;
                    endcase
                end
            endcase

            s1 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s2;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 15;  1: s = 1;   2: s = 8;   3: s = 14;
                        4: s = 6;   5: s = 11;  6: s = 3;   7: s = 4;
                        8: s = 9;   9: s = 7;   10: s = 2;  11: s = 13;
                        12: s = 12;     13: s = 0;  14: s = 5;  15: s = 10;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 3;   1: s = 13;  2: s = 4;   3: s = 7;
                        4: s = 15;  5: s = 2;   6: s = 8;   7: s = 14;
                        8: s = 12;  9: s = 0;   10: s = 1;  11: s = 10;
                        12: s = 6;  13: s = 9;  14: s = 11;     15: s = 5;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 0;   1: s = 14;  2: s = 7;   3: s = 11;
                        4: s = 10;  5: s = 4;   6: s = 13;  7: s = 1;
                        8: s = 5;   9: s = 8;   10: s = 12;     11: s = 6;
                        12: s = 9;  13: s = 3;  14: s = 2;  15: s = 15;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 13;  1: s = 8;   2: s = 10;  3: s = 1;
                        4: s = 3;   5: s = 15;  6: s = 4;   7: s = 2;
                        8: s = 11;  9: s = 6;   10: s = 7;  11: s = 12;
                        12: s = 0;  13: s = 5;  14: s = 14;     15: s = 9;
                    endcase
                end
            endcase

            s2 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s3;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 10;  1: s = 0;   2: s = 9;   3: s = 14;
                        4: s = 6;   5: s = 3;   6: s = 15;  7: s = 5;
                        8: s = 1;   9: s = 13;  10: s = 12;     11: s = 7;
                        12: s = 11;     13: s = 4;  14: s = 2;  15: s = 8;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 13;  1: s = 7;   2: s = 0;   3: s = 9;
                        4: s = 3;   5: s = 4;   6: s = 6;   7: s = 10;
                        8: s = 2;   9: s = 8;   10: s = 5;  11: s = 14;
                        12: s = 12;     13: s = 11;     14: s = 15;     15: s = 1;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 13;  1: s = 6;   2: s = 4;   3: s = 9;
                        4: s = 8;   5: s = 15;  6: s = 3;   7: s = 0;
                        8: s = 11;  9: s = 1;   10: s = 2;  11: s = 12;
                        12: s = 5;  13: s = 10;     14: s = 14;     15: s = 7;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 1;   1: s = 10;  2: s = 13;  3: s = 0;
                        4: s = 6;   5: s = 9;   6: s = 8;   7: s = 7;
                        8: s = 4;   9: s = 15;  10: s = 14;     11: s = 3;
                        12: s = 11;     13: s = 5;  14: s = 2;  15: s = 12;
                    endcase
                end
            endcase

            s3 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s4;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 7;   1: s = 13;  2: s = 14;  3: s = 3;
                        4: s = 0;   5: s = 6;   6: s = 9;   7: s = 10;
                        8: s = 1;   9: s = 2;   10: s = 8;  11: s = 5;
                        12: s = 11;     13: s = 12;     14: s = 4;  15: s = 15;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 13;  1: s = 8;   2: s = 11;  3: s = 5;
                        4: s = 6;   5: s = 15;  6: s = 0;   7: s = 3;
                        8: s = 4;   9: s = 7;   10: s = 2;  11: s = 12;
                        12: s = 1;  13: s = 10;     14: s = 14;     15: s = 9;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 10;  1: s = 6;   2: s = 9;   3: s = 0;
                        4: s = 12;  5: s = 11;  6: s = 7;   7: s = 13;
                        8: s = 15;  9: s = 1;   10: s = 3;  11: s = 14;
                        12: s = 5;  13: s = 2;  14: s = 8;  15: s = 4;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 3;   1: s = 15;  2: s = 0;   3: s = 6;
                        4: s = 10;  5: s = 1;   6: s = 13;  7: s = 8;
                        8: s = 9;   9: s = 4;   10: s = 5;  11: s = 11;
                        12: s = 12;     13: s = 7;  14: s = 2;  15: s = 14;
                    endcase
                end
            endcase

            s4 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s5;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 2;   1: s = 12;  2: s = 4;   3: s = 1;
                        4: s = 7;   5: s = 10;  6: s = 11;  7: s = 6;
                        8: s = 8;   9: s = 5;   10: s = 3;  11: s = 15;
                        12: s = 13;     13: s = 0;  14: s = 14;     15: s = 9;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 14;  1: s = 11;  2: s = 2;   3: s = 12;
                        4: s = 4;   5: s = 7;   6: s = 13;  7: s = 1;
                        8: s = 5;   9: s = 0;   10: s = 15;     11: s = 10;
                        12: s = 3;  13: s = 9;  14: s = 8;  15: s = 6;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 4;   1: s = 2;   2: s = 1;   3: s = 11;
                        4: s = 10;  5: s = 13;  6: s = 7;   7: s = 8;
                        8: s = 15;  9: s = 9;   10: s = 12;     11: s = 5;
                        12: s = 6;  13: s = 3;  14: s = 0;  15: s = 14;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 11;  1: s = 8;   2: s = 12;  3: s = 7;
                        4: s = 1;   5: s = 14;  6: s = 2;   7: s = 13;
                        8: s = 6;   9: s = 15;  10: s = 0;  11: s = 9;
                        12: s = 10;     13: s = 4;  14: s = 5;  15: s = 3;
                    endcase
                end
            endcase

            s5 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s6;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 12;  1: s = 1;   2: s = 10;  3: s = 15;
                        4: s = 9;   5: s = 2;   6: s = 6;   7: s = 8;
                        8: s = 0;   9: s = 13;  10: s = 3;  11: s = 4;
                        12: s = 14;     13: s = 7;  14: s = 5;  15: s = 11;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 10;  1: s = 15;  2: s = 4;   3: s = 2;
                        4: s = 7;   5: s = 12;  6: s = 9;   7: s = 5;
                        8: s = 6;   9: s = 1;   10: s = 13;     11: s = 14;
                        12: s = 0;  13: s = 11;     14: s = 3;  15: s = 8;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 9;   1: s = 14;  2: s = 15;  3: s = 5;
                        4: s = 2;   5: s = 8;   6: s = 12;  7: s = 3;
                        8: s = 7;   9: s = 0;   10: s = 4;  11: s = 10;
                        12: s = 1;  13: s = 13;     14: s = 11;     15: s = 6;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 4;   1: s = 3;   2: s = 2;   3: s = 12;
                        4: s = 9;   5: s = 5;   6: s = 15;  7: s = 10;
                        8: s = 11;  9: s = 14;  10: s = 1;  11: s = 7;
                        12: s = 6;  13: s = 0;  14: s = 8;  15: s = 13;
                    endcase
                end
            endcase

            s6 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s7;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 4;   1: s = 11;  2: s = 2;   3: s = 14;
                        4: s = 15;  5: s = 0;   6: s = 8;   7: s = 13;
                        8: s = 3;   9: s = 12;  10: s = 9;  11: s = 7;
                        12: s = 5;  13: s = 10;     14: s = 6;  15: s = 1;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 13;  1: s = 0;   2: s = 11;  3: s = 7;
                        4: s = 4;   5: s = 9;   6: s = 1;   7: s = 10;
                        8: s = 14;  9: s = 3;   10: s = 5;  11: s = 12;
                        12: s = 2;  13: s = 15;     14: s = 8;  15: s = 6;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 1;   1: s = 4;   2: s = 11;  3: s = 13;
                        4: s = 12;  5: s = 3;   6: s = 7;   7: s = 14;
                        8: s = 10;  9: s = 15;  10: s = 6;  11: s = 8;
                        12: s = 0;  13: s = 5;  14: s = 9;  15: s = 2;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 6;   1: s = 11;  2: s = 13;  3: s = 8;
                        4: s = 1;   5: s = 4;   6: s = 10;  7: s = 7;
                        8: s = 9;   9: s = 5;   10: s = 0;  11: s = 15;
                        12: s = 14;     13: s = 2;  14: s = 3;  15: s = 12;
                    endcase
                end
            endcase

            s7 = {s[0],s[1],s[2],s[3]};
        end
    endfunction

    function [3:0] s8;
        input [5:0] in;
        reg [3:0] s;
        begin
            case ({in[0],in[5]})
                0: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 13;  1: s = 2;   2: s = 8;   3: s = 4;
                        4: s = 6;   5: s = 15;  6: s = 11;  7: s = 1;
                        8: s = 10;  9: s = 9;   10: s = 3;  11: s = 14;
                        12: s = 5;  13: s = 0;  14: s = 12;     15: s = 7;
                    endcase
                end
                1: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 1;   1: s = 15;  2: s = 13;  3: s = 8;
                        4: s = 10;  5: s = 3;   6: s = 7;   7: s = 4;
                        8: s = 12;  9: s = 5;   10: s = 6;  11: s = 11;
                        12: s = 0;  13: s = 14;     14: s = 9;  15: s = 2;
                    endcase
                end
                2: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 7;   1: s = 11;  2: s = 4;   3: s = 1;
                        4: s = 9;   5: s = 12;  6: s = 14;  7: s = 2;
                        8: s = 0;   9: s = 6;   10: s = 10;     11: s = 13;
                        12: s = 15;     13: s = 3;  14: s = 5;  15: s = 8;
                    endcase
                end
                3: begin
                    case ({in[1],in[2],in[3],in[4]})
                        0: s = 2;   1: s = 1;   2: s = 14;  3: s = 7;
                        4: s = 4;   5: s = 10;  6: s = 8;   7: s = 13;
                        8: s = 15;  9: s = 12;  10: s = 9;  11: s = 0;
                        12: s = 3;  13: s = 5;  14: s = 6;  15: s = 11;
                    endcase
                end
            endcase

            s8 = {s[0],s[1],s[2],s[3]};
        end
    endfunction


    function [47:0] e2;
        input [32:1] in;

        e2 = {in[1],in[32:28],in[29:24],in[25:20],in[21:16],in[17:12],in[13:8],in[9:4],in[5:1],in[32]};
    endfunction

    function [47:0] PC2;
        input [56:1] in;

        PC2 = {in[32],in[29],in[36],in[50],in[42],in[46],
               in[53],in[34],in[56],in[39],in[49],in[44],
               in[48],in[33],in[45],in[51],in[40],in[30],
               in[55],in[47],in[37],in[31],in[52],in[41],

               in[2],in[13],in[20],in[27],in[7],in[16],
               in[8],in[26],in[4],in[12],in[19],in[23],
               in[10],in[21],in[6],in[15],in[28],in[3],
               in[5],in[1],in[24],in[11],in[17],in[14] };
    endfunction

endmodule
