#!/usr/bin/perl
$OSBitSize = 64;

use Switch;

open(FH, "@ARGV[0]");
$i = 0;
# 置換
while ($line = <FH>) {
    $line =~ s/,/ /g;           # コンマ -> スペース
    $line =~ s/\t/ /g;          # タブ -> スペース
    $line =~ s/\:/ : /g;        # コロンの前後にスペース挿入
    $line =~ s/^ +//g;          # 行頭のスペース削除
    chomp($line);               # 行末の改行削除
    @instruction = split(/ +/, $line);
    if (@instruction[1] eq ":") {
        $labels {@instruction[0]} = $i;
    }
    $i++;
}
close(FH);

open(FH, "@ARGV[0]");
$i = 0;
while ($line = <FH>) {
    # print("$i : ");
    $line =~ s/,/ /g;
    $line =~ s/\t+/ /g;
    $line =~ s/\:/ : /g;
    $line =~ s/^ +//g;
    # print($line);
    chomp($line);
    @instruction = split(/ +/, $line);
    if (@instruction[1] eq ":") {
        # ラベルあり
        $op = @instruction[2];
        $f2 = @instruction[3];
        $f3 = @instruction[4];
        $f4 = @instruction[5];
        $f5 = @instruction[6];
    } else {
        # ラベルなし
        $op = @instruction[0];
        $f2 = @instruction[1];
        $f3 = @instruction[2];
        $f4 = @instruction[3];
        $f5 = @instruction[4];
    }
    switch ($op) {
        case "add" {
            p_b(6, 0);
            p_r3($f2, $f3, $f4);
            p_b(11, 0);
            print("\n");
        }
        case "addi" {
            p_b(6, 1);
            p_r2i($f2, $f3);
            p_b(16, $f4);
            print("\n");
        }
        case "sub" {
            p_b(6, 0);
            p_r3($f2, $f3, $f4);
            p_b(11, 2);
            print("\n");
        }
        case "lui" {
            p_b(6, 3);
            p_r2i($f2, "r0");
            p_b(16, $f3);
            print("\n");
        }
        case "and" {
            p_b(6, 0);
            p_r3($f2, $f3, $f4);
            p_b(11, 8);
            print("\n");
        }
        case "andi" {
            p_b(6, 4);
            p_r2i($f2, $f3);
            p_b(16, $f4);
            print("\n");
        }
        case "or" {
            p_b(6, 0);
            p_r3($f2, $f3, $f4);
            p_b(11, 9);
            print("\n");
        }
        case "ori" {
            p_b(6, 5);
            p_r2i($f2, $f3);
            p_b(16, $f4);
            print("\n");
        }
        case "xor" {
            p_b(6, 0);
            p_r3($f2, $f3, $f4);
            p_b(11, 10);
            print("\n");
        }
        case "xori" {
            p_b(6, 6);
            p_r2i($f2, $f3);
            p_b(16, $f4);
            print("\n");
        }
        case "nor" {
            p_b(6, 0);
            p_r3($f2, $f3, $f4);
            p_b(11, 11);
            print("\n");
        }
        case "sll" {
            p_b(6, 0);
            p_r3($f2, $f3, "r0");
            p_b(5, $f4);
            p_b(6, 16);
            print("\n");
        }
        case "srl" {
            p_b(6, 0);
            p_r3($f2, $f3, "r0");
            p_b(5, $f4);
            p_b(6, 17);
            print("\n");
        }
        case "sra" {
            p_b(6, 0);
            p_r3($f2, $f3, "r0");
            p_b(5, $f4);
            p_b(6, 18);
            print("\n");
        }
        case "lw" {
            p_b(6, 16);
            p_r2i($f2, base($f3));
            p_b(16, dpl($f3));
            print("\n");
        }
        case "lh" {
            p_b(6, 18);
            p_r2i($f2, base($f3));
            p_b(16, dpl($f3));
            print("\n");
        }
        case "lb" {
            p_b(6, 20);
            p_r2i($f2, base($f3));
            p_b(16, dpl($f3));
            print("\n");
        }
        case "sw" {
            p_b(6, 24);
            p_r2i($f2, base($f3));
            p_b(16, dpl($f3));
            print("\n");
        }
        case "sh" {
            p_b(6, 26);
            p_r2i($f2, base($f3));
            p_b(16, dpl($f3));
            print("\n");
        }
        case "sb" {
            p_b(6, 28);
            p_r2i($f2, base($f3));
            p_b(16, dpl($f3));
            print("\n");
        }
        case "beq" {
            p_b(6, 32);
            p_r2i($f2, $f3);
            p_b(16, $labels{$f4} - $i - 1);
            print("\n");
        }
        case "bne" {
            p_b(6, 33);
            p_r2i($f2, $f3);
            p_b(16, $labels{$f4} - $i - 1);
            print("\n");
        }
        case "blt" {
            p_b(6, 34);
            p_r2i($f2, $f3);
            p_b(16, $labels{$f4} - $i - 1);
            print("\n");
        }
        case "ble" {
            p_b(6, 35);
            p_r2i($f2, $f3);
            p_b(16, $labels{$f4} - $i - 1);
            print("\n");
        }
        case "j" {
            p_b(6, 40);
            p_b(26, $labels{$f2});
            print("\n");
        }
        case "jal" {
            p_b(6, 41);
            p_b(26, $labels{$f2});
            print("\n");
        }
        case "jr" {
            p_b(6, 42);
            p_r3("r0", $f2, "r0");
            p_b(11, 0);
            print("\n");
        }
        else {
            print("ERROR: Illegal Instruction\n", $op, "\n");
        }
    }
    $i++;
}
close(FH);

# $numを$digits桁の2進数に変換して出力する
sub p_b {
    ($digits, $num) = @_;
    if ($num >= 0) {
        printf("%0" . $digits ."b_", $num);
    } else {
        print(substr(sprintf("%b ",$num), $OSBitSize - $digits));
    }
}

# R型のレジスタ番地を出力する
sub p_r3 {
    ($rd, $rs, $rt) = @_;
    $rs =~ s/r//;
    p_b(5, $rs);
    $rt =~ s/r//;
    p_b(5, $rt);
    $rd =~ s/r//;
    p_b(5, $rd);
}

# I型のレジスタ番地を出力する
sub p_r2i {
    ($rt, $rs) = @_;
    $rs =~ s/r//;
    p_b(5, $rs);
    $rt =~ s/r//;
    p_b(5, $rt);
}

# 条件分岐で比較するレジスタ番地を出力する
sub p_r2b {
    ($rs, $rt) = @_;
    $rs =~ s/r//;
    p_b(5, $rs);
    $rt =~ s/r//;
    p_b(5, $rt);
}

# ベースアドレスレジスタの番地を返す
sub base {
    ($addr) = @_;
    $addr =~ s/.*\(//;
    $addr =~ s/\)//;
    return ($addr);
}

# 変位を返す
sub dpl {
    ($addr) = @_;
    $addr =~ s/\(.*\)//;
    return ($addr);
}
