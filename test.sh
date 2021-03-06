#!/bin/sh

function fail(){
    echo -e "\e[1;31m[ERROR]\e[0m $1"
    exit 1
}

function test_aqcc() {
    echo "$1" | ./main > _test.s
    [ $? -eq 0 ] || fail "test_aqcc \"$1\": ./main > _test.s"
    gcc _test.s -o _test.o testutil.o
    [ $? -eq 0 ] || fail "test_aqcc \"$1\": gcc _test.s -o _test.o"
    ./_test.o
    res=$?
    [ $res -eq $2 ] || fail "test_aqcc \"$1\" -> $res (expected $2)"
}

./main test
[ $? -eq 0 ] || fail "./main test"

test_aqcc "2;" 2
test_aqcc "22;" 22
test_aqcc "2+2;" 4
test_aqcc "11+11+11;" 33
test_aqcc "5-3;" 2
test_aqcc "35-22;" 13
test_aqcc "35-22-11;" 2
test_aqcc "199-23+300-475;" 1
test_aqcc "1+4-3;" 2
test_aqcc "1983+2-449-3123+1893-32+223-396;" 101
test_aqcc "2*2;" 4
test_aqcc "11*11;" 121
test_aqcc "4/2;" 2
test_aqcc "363/121;" 3
test_aqcc "100/3;" 33
test_aqcc "1+2*3;" 7
test_aqcc "1+4*2-9/3;" 6
test_aqcc "4%2;" 0
test_aqcc "5%2;" 1
test_aqcc "1935%10;" 5
test_aqcc "(1+2)*3;" 9
test_aqcc "(1+2)*(1+2);" 9
test_aqcc "(1+2)/(1+2);" 1
test_aqcc "33*(1+2);" 99
test_aqcc "(33*(1+2))/3;" 33
test_aqcc "-3+5;" 2
test_aqcc "+4;" 4
test_aqcc "-(33*(1+2))/3+34;" 1
test_aqcc "4 + 4;" 8
test_aqcc "- ( 33 * ( 1 + 2 ) ) / 3 + 34;" 1
test_aqcc "2 << 1;" 4
test_aqcc "2 << 2 << 1;" 16
test_aqcc "2 << (2 << 1);" 32
test_aqcc "(2 - 1) << 1;" 2
test_aqcc "2 >> 1;" 1
test_aqcc "4 >> 2 >> 1;" 0
test_aqcc "(2 - 1) >> 1;" 0
test_aqcc "1<2;" 1
test_aqcc "1 < 2;" 1
test_aqcc "4 < 2;" 0
test_aqcc "1>2;" 0
test_aqcc "1 > 2;" 0
test_aqcc "4 > 2;" 1
test_aqcc "1<=2;" 1
test_aqcc "1 <= 2;" 1
test_aqcc "4 <= 2;" 0
test_aqcc "2 <= 2;" 1
test_aqcc "1>=2;" 0
test_aqcc "1 >= 2;" 0
test_aqcc "4 >= 2;" 1
test_aqcc "2 >= 2;" 1
test_aqcc "(2 < 1) + 1;" 1
test_aqcc "1==2;" 0
test_aqcc "1 == 2;" 0
test_aqcc "4 == 2;" 0
test_aqcc "2 == 2;" 1
test_aqcc "0&0;" 0
test_aqcc "0 & 0;" 0
test_aqcc "1 & 0;" 0
test_aqcc "0 & 1;" 0
test_aqcc "1 & 1;" 1
test_aqcc "1 & 2;" 0
test_aqcc "2 & 2;" 2
test_aqcc "3 & 5;" 1
test_aqcc "0^0;" 0
test_aqcc "0 ^ 0;" 0
test_aqcc "1 ^ 0;" 1
test_aqcc "0 ^ 1;" 1
test_aqcc "1 ^ 1;" 0
test_aqcc "1 ^ 2;" 3
test_aqcc "2 ^ 2;" 0
test_aqcc "3 ^ 5;" 6
test_aqcc "0|0;" 0
test_aqcc "0 | 0;" 0
test_aqcc "1 | 0;" 1
test_aqcc "0 | 1;" 1
test_aqcc "1 | 1;" 1
test_aqcc "1 | 2;" 3
test_aqcc "2 | 2;" 2
test_aqcc "3 | 5;" 7
test_aqcc "1&&0;" 0
test_aqcc "1 && 1;" 1
test_aqcc "0 && 1;" 0
test_aqcc "0 && 0;" 0
test_aqcc "2 && 1;" 1
test_aqcc "-2 || 1;" 1
test_aqcc "1||0;" 1
test_aqcc "1 || 1;" 1
test_aqcc "0 || 1;" 1
test_aqcc "0 || 0;" 0
test_aqcc "2 || 1;" 1
test_aqcc "-2 || 1;" 1
test_aqcc "x=1;" 1
test_aqcc "xy = 100+100;" 200
test_aqcc "a_b = - ( 33 * ( 1 + 2 ) ) / 3 + 34;" 1
test_aqcc "_ = (2 - 1) << 1;" 2
test_aqcc "x = 1; y = 2;" 2
test_aqcc "x = 1; y = 2; z = x + y;" 3
test_aqcc "a0 = 1; a1 = 1; a2 = a0 + a1; a3 = a1 + a2;" 3
test_aqcc "x = y = 1; z = x = x + y;" 2
test_aqcc "ret0();" 0
test_aqcc "(ret0() + ret1()) * 2;" 2
test_aqcc "(ret0() * ret1()) + 2;" 2
test_aqcc "add1(1);" 2
test_aqcc "add_two(1, 2);" 3
test_aqcc "add_all(1, 2, 4, 8, 16, 32, 64, 128);" 1
