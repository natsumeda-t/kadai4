#!/bin/bash

MAX_INT="9223372036854775807"

is_natural_number() {
    local old_lc="$LC_ALL"
    LC_ALL=C
    [[ "$1" =~ ^0$ || "$1" =~ ^[1-9][0-9]*$ ]]
    local result=$?
    LC_ALL="$old_lc"
    return $result
}

exceeds_int64_max() {
    [ "$(echo "$1 > $MAX_INT" | bc)" -eq 1 ]
}

SUCCESS=0
ERR_INVALID_ARGC=1
ERR_NOT_NATURAL=2
ERR_TOO_LARGE=3

if [ $# -ne 2 ]; then
    echo "Error: 2つの自然数を引数として指定してください"
    exit $ERR_INVALID_ARGC
fi

if ! is_natural_number "$1" || ! is_natural_number "$2"; then
    echo "Error: 引数には自然数(半角数字を指定してください"
    exit $ERR_NOT_NATURAL
fi

if exceeds_int64_max "$1" || exceeds_int64_max "$2"; then
    echo "Error: 数値が大きすぎます(最大9223372036854775807)"
    exit $ERR_TOO_LARGE
fi

# ユークリッドの互除法
a=$1
b=$2

while [ "$b" -ne 0 ]; do
    temp=$b
    b=$(( a % b ))
    a=$temp
done

echo "$a"
exit $SUCCESS
