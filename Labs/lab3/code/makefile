CC = gcc
FLEX = flex
BISON = bison

parser: main.c lex.yy.c syntax.tab.c 
	$(CC) main.c syntax.tab.c -lfl -o parser -g

lex.yy.c: lexical.l
	$(FLEX) lexical.l

syntax.tab.c: syntax.y
	$(BISON) -d -t syntax.y

.PHONY: clean
clean:
	rm -f parser lex.yy.c syntax.tab.c syntax.tab.h syntax.output
	rm -f ./out/*
