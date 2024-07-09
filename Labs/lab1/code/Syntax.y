%{
#include <unistd.h>
#include <stdio.h> 
#include "define.h"
#include "lex.yy.c"
%}

%union{
    treeNode type_node;
}

/*终结符*/
%token <type_node> INT FLOAT ID
%token <type_node> SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV  
%token <type_node> AND OR DOT NOT TYPE LP RP LB RB LC RC
%token <type_node> STRUCT RETURN IF ELSE WHILE
%token <type_node> COMMENT SPACE AERROR NUM_ERROR ID_ERROR

/*非终结符*/
%type <type_node> Program ExtDefList ExtDef ExtDecList
%type <type_node> Specifier StructSpecifier OptTag Tag 
%type <type_node> VarDec FunDec VarList ParamDec CompSt
%type <type_node> StmtList Stmt DefList Def DecList Dec Exp Args

/*优先级*/
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP RB LB DOT
%nonassoc ELSE



%%

/*High-level Definitions*/
Program : ExtDefList    {$$ = cre_gram_unit("Program", yylineno, 1, $1); printTree();}
    ;
ExtDefList : ExtDef ExtDefList  {$$ = cre_gram_unit("ExtDefList", yylineno, 2, $1, $2);}
    | 			                {$$ = cre_gram_unit("ExtDefList", -1, 0, NULL);}
    ;
ExtDef : Specifier ExtDecList SEMI      {$$ = cre_gram_unit("ExtDef", yylineno, 3, $1, $2, $3);}
    | Specifier SEMI 				    {$$ = cre_gram_unit("ExtDef", yylineno, 2, $1, $2);}
    | Specifier FunDec CompSt 		    {$$ = cre_gram_unit("ExtDef", yylineno, 3, $1, $2, $3);}
    | Specifier ExtDecList error SEMI   {}
    | Specifier error SEMI	            {}
    ;
ExtDecList : VarDec 		    {$$ = cre_gram_unit("ExtDecList", yylineno, 1, $1);}
    | VarDec COMMA ExtDecList 	{$$ = cre_gram_unit("ExtDecList", yylineno, 3, $1, $2, $3);}
    ;

/*Specifiers*/
Specifier : TYPE 	    {$$ = cre_gram_unit("Specifier", yylineno, 1, $1);}
    | StructSpecifier   {$$ = cre_gram_unit("Specifier", yylineno, 1, $1);}					
    ;
StructSpecifier : STRUCT OptTag LC DefList RC   {$$ = cre_gram_unit("StructSpecifier", yylineno, 5, $1, $2, $3, $4, $5);}
    | STRUCT Tag 					            {$$ = cre_gram_unit("StructSpecifier", yylineno, 2, $1, $2);}
    | STRUCT OptTag LC DefList error RC	        {}
    ;
OptTag : ID 	{$$ = cre_gram_unit("OptTag", yylineno, 1, $1);}					
    |  		    {$$ = cre_gram_unit("OptTag", -1, 0, NULL);}		
    ;
Tag : ID 		{$$ = cre_gram_unit("Tag", yylineno, 1, $1);}				
    ;

/*Declarators*/
VarDec : ID 	            {$$ = cre_gram_unit("VarDec", yylineno, 1, $1);}
    | VarDec LB INT RB 		{$$ = cre_gram_unit("VarDec", yylineno, 4, $1, $2, $3, $4);}		 
    | VarDec LB INT error RB{}
    ;
FunDec : ID LP VarList RP 	{$$ = cre_gram_unit("FunDec", yylineno, 4, $1, $2, $3, $4);}	
    | ID LP RP  			{$$ = cre_gram_unit("FunDec", yylineno, 3, $1, $2, $3);}	
    | ID LP error RP	    
    | ID LP VarList error RP
    ;
VarList : ParamDec COMMA VarList    {$$ = cre_gram_unit("VarList", yylineno, 3, $1, $2, $3);}			
    | ParamDec 				        {$$ = cre_gram_unit("VarList", yylineno, 1, $1);}
    ;
ParamDec : Specifier VarDec {$$ = cre_gram_unit("ParamDec", yylineno, 2, $1, $2);}			
    ;

/* Statements*/
CompSt : LC DefList StmtList RC {$$ = cre_gram_unit("CompSt", yylineno, 4, $1, $2, $3, $4);}		
	| LC DefList StmtList error RC
    ;
StmtList : Stmt StmtList    {$$ = cre_gram_unit("StmtList", yylineno, 2, $1, $2);}			
    | 		                {$$ = cre_gram_unit("StmtList", -1, 0, NULL);}				
    ;	
Stmt : Exp SEMI 					{$$ = cre_gram_unit("Stmt", yylineno, 2, $1, $2);} 
    | CompSt 				        {$$ = cre_gram_unit("Stmt", yylineno, 1, $1);}		 
    | RETURN Exp SEMI  				{$$ = cre_gram_unit("Stmt", yylineno, 3, $1, $2, $3);}
    | IF LP Exp RP Stmt 			{$$ = cre_gram_unit("Stmt", yylineno, 5, $1, $2, $3, $4, $5);}
    | IF LP Exp RP Stmt ELSE Stmt 	{$$ = cre_gram_unit("Stmt", yylineno, 7, $1, $2, $3, $4, $5, $6, $7);}	
    | WHILE LP Exp RP Stmt 			{$$ = cre_gram_unit("Stmt", yylineno, 5, $1, $2, $3, $4, $5);} 
    | WHILE LP Exp error RP Stmt	
    | IF LP Exp error RP Stmt ELSE Stmt	
    | RETURN Exp error SEMI		
    | Exp error SEMI	
    ;

/* Local Definitions*/
DefList : Def DefList   {$$ = cre_gram_unit("DefList", yylineno, 2, $1, $2);}				
    | 					{$$ = cre_gram_unit("DefList", -1, 0, NULL);}
    ;
Def : Specifier DecList SEMI 	    {$$ = cre_gram_unit("Def", yylineno, 3, $1, $2, $3);}			
	| Specifier DecList error SEMI
    ;
DecList : Dec 		    {$$ = cre_gram_unit("DecList", yylineno, 1, $1);}				
    | Dec COMMA DecList {$$ = cre_gram_unit("DecList", yylineno, 3, $1, $2, $3);}		
    ;
Dec : VarDec 			    {$$ = cre_gram_unit("Dec", yylineno, 1, $1);}		
    | VarDec ASSIGNOP Exp 	{$$ = cre_gram_unit("Dec", yylineno, 3, $1, $2, $3);}	
    ;

/*Expressions*/
Exp : Exp ASSIGNOP Exp 	{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}	
    | Exp AND Exp 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}		
    | Exp OR Exp 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}			
    | Exp RELOP Exp 	{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}			
    | Exp PLUS Exp 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}			
    | Exp MINUS Exp 	{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}			
    | Exp STAR Exp 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}			
    | Exp DIV Exp 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}		
    | LP Exp RP 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}		
    | MINUS Exp 		{$$ = cre_gram_unit("Exp", yylineno, 2, $1, $2);}			
    | NOT Exp 			{$$ = cre_gram_unit("Exp", yylineno, 2, $1, $2);}		
    | ID LP Args RP 	{$$ = cre_gram_unit("Exp", yylineno, 4, $1, $2, $3, $4);}				
    | ID LP RP 			{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}	
    | Exp LB Exp RB 	{$$ = cre_gram_unit("Exp", yylineno, 4, $1, $2, $3, $4);}			
    | Exp DOT ID 		{$$ = cre_gram_unit("Exp", yylineno, 3, $1, $2, $3);}		
    | ID 				{$$ = cre_gram_unit("Exp", yylineno, 1, $1);}
    | INT 			    {$$ = cre_gram_unit("Exp", yylineno, 1, $1);}	
    | FLOAT 			{$$ = cre_gram_unit("Exp", yylineno, 1, $1);}		
    | LP Exp error RP
    | ID LP Args error RP	
    | Exp LB Exp error RB	
    ;
Args : Exp COMMA Args 	{$$ = cre_gram_unit("Args", yylineno, 3, $1, $2, $3);}			
    | Exp 				{$$ = cre_gram_unit("Args", yylineno, 1, $1);}	
    ;
%% 






