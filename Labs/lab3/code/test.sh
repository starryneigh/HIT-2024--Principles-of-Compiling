#!bin/bash

testpath=./test
parserpath=./parser
outpath=./out

testfiles=$(find $testpath -name "*.cmm")
# find $testpath -name "*.cmm"

for file in $testfiles
do
    echo ========================= Testing $file =========================
    $parserpath $file $outpath/$(basename $file .cmm).out
    cat $outpath/$(basename $file .cmm).out
    echo
done
