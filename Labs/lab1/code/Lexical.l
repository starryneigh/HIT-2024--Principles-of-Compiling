%{
#include<stdio.h>
#include<stdlib.h>
#include "define.h"
#include "Syntax.tab.h"
void read_comment();
void lex_error();
%}

%option yylineno

/*整型*/
INT8    [+-]?0[1-7][0-7]*
INT10   [+-]?(0|[1-9][0-9]*)
INT16   [+-]?0[Xx][0-9a-fA-F]+
INT     {INT8}|{INT10}|{INT16}
 /*浮点型*/
FLOAT   ({INT10}\.[0-9]+)|([+-]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)[Ee][+-]?[0-9]+)
 /*标识符*/
ID      [a-zA-Z_][a-zA-Z0-9_]*
 /*标点符号*/
SEMI    ;
COMMA   ,
ASSIGNOP =
RELOP   >|<|>=|<=|==|!=
PLUS    \+
MINUS   \-
STAR    \*
DIV     \/
AND     &&
OR      \|\|
DOT     \.
NOT     \!
TYPE    int|float
LP      \(
RP      \)
LB      \[
RB      \]
LC      \{
RC      \}
 /*关键字*/
STRUCT  struct
RETURN  return
IF      if
ELSE    else
WHILE   while
 /*单行注释*/
LINE_COMMENT    \/\/.*(\r?\n|$)
 /*空格*/
SPACE           [ \n\r\t]+
 /*错误*/
AERROR          .
INT8_ERROR      0[0-7]*[8-9]+[0-7]*
INT16_ERROR     0[Xx][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*
FLOAT_ERROR     [0]+(0|[1-9][0-9]*)\.[0-9]+|\.[0-9]+|[0-9]+\.|[0-9]+[Ee][+-]?[0-9]*|([+-]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)[Ee][+-]?[0-9]+\.[0-9]+)
NUM_ERROR       {INT8_ERROR}|{INT16_ERROR}|{FLOAT_ERROR}
ID_ERROR        [0-9]+[a-zA-Z_]+
ERROR           {ID_ERROR}|{NUM_ERROR}|{AERROR}

%%
{SPACE}     {}
{LINE_COMMENT} {}
"/*"        {read_comment();}
{TYPE}      {yylval.type_node = newNode("TYPE", 0, yylineno, NULL); return TYPE;}
{STRUCT}    {yylval.type_node = newNode("STRUCT", 0, yylineno, NULL); return STRUCT;}
{RETURN}    {yylval.type_node = newNode("RETURN", 0, yylineno, NULL); return RETURN;}
{IF}        {yylval.type_node = newNode("IF", 0, yylineno, NULL); return IF;}
{ELSE}      {yylval.type_node = newNode("ELSE", 0, yylineno, NULL); return ELSE;}
{WHILE}     {yylval.type_node = newNode("WHILE", 0, yylineno, NULL); return WHILE;}

{INT}       {yylval.type_node = newNode("INT", 0, yylineno, NULL); return INT;}
{FLOAT}     {yylval.type_node = newNode("FLOAT", 0, yylineno, NULL); return FLOAT;}

{SEMI}      {yylval.type_node = newNode("SEMI", 0, yylineno, NULL); return SEMI;}
{COMMA}     {yylval.type_node = newNode("COMMA", 0, yylineno, NULL); return COMMA;}
{ASSIGNOP}  {yylval.type_node = newNode("ASSIGNOP", 0, yylineno, NULL); return ASSIGNOP;}
{PLUS}      {yylval.type_node = newNode("PLUS", 0, yylineno, NULL); return PLUS;}
{MINUS}     {yylval.type_node = newNode("MINUS", 0, yylineno, NULL); return MINUS;}
{STAR}      {yylval.type_node = newNode("STAR", 0, yylineno, NULL); return STAR;}
{DIV}       {yylval.type_node = newNode("DIV", 0, yylineno, NULL); return DIV;}
{AND}       {yylval.type_node = newNode("AND", 0, yylineno, NULL); return AND;}
{DOT}       {yylval.type_node = newNode("DOT", 0, yylineno, NULL); return DOT;}
{NOT}       {yylval.type_node = newNode("NOT", 0, yylineno, NULL); return NOT;}
{LP}        {yylval.type_node = newNode("LP", 0, yylineno, NULL); return LP;}
{RP}        {yylval.type_node = newNode("RP", 0, yylineno, NULL); return RP;}
{LB}        {yylval.type_node = newNode("LB", 0, yylineno, NULL); return LB;}
{RB}        {yylval.type_node = newNode("RB", 0, yylineno, NULL); return RB;}
{LC}        {yylval.type_node = newNode("LC", 0, yylineno, NULL); return LC;}
{RC}        {yylval.type_node = newNode("RC", 0, yylineno, NULL); return RC;}
{RELOP}     {yylval.type_node = newNode("RELOP", 0, yylineno, NULL); return RELOP;}
{ID}        {yylval.type_node = newNode("ID", 0, yylineno, NULL); return ID;}
{ERROR}     {lex_error();}
%%
void lex_error(){
    hasFault = 1;
    printf("error type A at line %d: mysterious character '%s'\n", yylineno, yytext);
}
void read_comment(){
    int q = 0;
    char c;
    while(1){
        if(q == 0){
            c = input();
            if(c == EOF)
                break;
            if(c == '*')
                q = 1;
        }else{
            c = input();
            if(c == EOF)
                break;
            if(c == '/')
                break;
            else if(c != '*')
                q = 0;
        }
    }
}
