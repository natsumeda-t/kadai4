#!/bin/bash

PASS_COUNT=0
FAIL_COUNT=0

EXIT_SUCCESS=0
EXIT_ERROR=1

run_test() {
    local name="$1"
    local expect_exit="$2"
    local expect_output="$3"
    shift 3
    local args=("$@")

    echo -n "[$name] ... "

    output=$("./gcd.sh" "${args[@]}" 2>stderr.txt)
    exitcode=$?

    if [ "$exitcode" -eq "$expect_exit" ]; then
        if [ "$expect_exit" -eq $EXIT_SUCCESS ]; then
            if [ "$output" = "$expect_output" ]; then
                echo "OK"
                PASS_COUNT=$((PASS_COUNT+1))
            else
                echo "NG (出力: '$output', 期待値: '$expect_output')"
                FAIL_COUNT=$((FAIL_COUNT+1))
            fi
        else
            echo "OK (エラー終了)"
            PASS_COUNT=$((PASS_COUNT+1))
        fi
    else
        echo "NG (終了コード: $exitcode, 期待値: $expect_exit)"
        FAIL_COUNT=$((FAIL_COUNT+1))
    fi
}

run_test "2と4の最大公約数"         $EXIT_SUCCESS 2 2 4
run_test "41と89の最大公約数"       $EXIT_SUCCESS 1 41 89
run_test "48と60の最大公約数"       $EXIT_SUCCESS 12 48 60
run_test "60と48の最大公約数"       $EXIT_SUCCESS 12 60 48
run_test "1と1の最大公約数"         $EXIT_SUCCESS 1 1 1
run_test "0と1の最大公約数"         $EXIT_SUCCESS 1 0 1
run_test "0と0の最大公約数"         $EXIT_SUCCESS 0 0 0
run_test "9223372036854775807と52836830540293の最大公約数" $EXIT_SUCCESS 60247241209 9223372036854775807 52836830540293

run_test "引数が0個"                $EXIT_ERROR DUMMY 
run_test "引数が1個"                $EXIT_ERROR DUMMY 1
run_test "引数が3個"                $EXIT_ERROR DUMMY 1 2 3

run_test "小数 (1.5と2)"            $EXIT_ERROR DUMMY 1.5 2
run_test "負数 (-2と4)"             $EXIT_ERROR DUMMY -2 4
run_test "文字列 (abcと10)"         $EXIT_ERROR DUMMY abc 10
run_test "全角数字 (１と２)"        $EXIT_ERROR DUMMY １ ２
run_test "怪しそうな文字1"          $EXIT_ERROR DUMMY \ !
run_test "怪しそうな文字2"          $EXIT_ERROR DUMMY * $

run_test "最大値超え"               $EXIT_ERROR DUMMY 9223372036854775808 1

echo "-------------------------------------"
echo "成功: $PASS_COUNT, 失敗: $FAIL_COUNT"

if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "すべてのテストに成功しました。"
    exit 0
else
    echo "テストに失敗があります。"
    exit 1
fi
