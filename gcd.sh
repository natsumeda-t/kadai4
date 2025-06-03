#!/bin/bash

MAX_INT="9223372036854775807"

contains_non_ascii() {
    [[ "$1" =~ [^\x00-\x7F] ]]
}

is_natural_number() {
    [[ "$1" =~ ^0$ || "$1" =~ ^[1-9][0-9]*$ ]]
}

exceeds_int64_max() {
    [ "$(echo "$1 > $MAX_INT" | bc)" -eq 1 ]
}

if [ $# -ne 2 ]; then
    echo "Error: 2つの自然数を引数として指定してください"
    exit 1
fi

if contains_non_ascii "$1" || contains_non_ascii "$2"; then
    echo "Error: 引数には半角数字を指定してください"
    exit 1
fi

if ! is_natural_number "$1" || ! is_natural_number "$2"; then
    echo "Error: 引数には自然数のみを指定してください"
    exit 1
fi

if exceeds_int64_max "$1" || exceeds_int64_max "$2"; then
    echo "Error: 数値が大きすぎます(最大9223372036854775807)"
    exit 1
fi

a=$1
b=$2

while [ "$b" -ne 0 ]; do
    temp=$b
    b=$(( a % b ))
    a=$temp
done

echo "$a"
exit 0
