#!bin/bash

testpath=./test
parserpath=./parser

testfiles=$(find $testpath -name "*.cmm")
find $testpath -name "*.c"

for file in $testfiles
do
    echo ========================= Testing $file =========================
    $parserpath $file
    echo
done
