#!/bin/bash

lex_file="./code/Lexical.l"
syntax_file="./code/Syntax.y"
main_file="./code/tree.c"
out_file="./parser"
test_file="./test/test1.c"
test_file2="./test/test2.c"
test_file3="./test/test3.c"

echo "=============================================="
echo "Compiling Lexical Analyzer......"
flex -o code/lex.yy.c ${lex_file}
# gcc main.c code/lex.yy.c -lfl -o scanner
# ./scanner test1.c

echo "=============================================="
echo "Compiling Syntax Analyzer......"
bison -d -o code/Syntax.tab.c ${syntax_file}

echo "=============================================="
echo "Compiling Main File......"
gcc ${main_file} code/Syntax.tab.c -lfl -ly -o ${out_file}

echo "=============================================="
echo "Test 1"
./parser test/test1.c

echo "=============================================="
echo "Test 2"
./parser test/test2.c

echo "=============================================="
echo "Test 3"
./parser test/test3.c