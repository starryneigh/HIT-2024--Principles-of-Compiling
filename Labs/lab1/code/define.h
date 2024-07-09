# include <stdio.h>
# include <ctype.h>
# include <string.h>
# include <stdlib.h> 
#include <stdarg.h>
# define maxNum 10

#ifndef DEF
#define DEF
extern int yylineno;
extern char* yytext;
extern int yylex(void);

struct TREE{
    int line;
    char* name;
    int n;	//子结点的个数
    struct TREE *child[maxNum];
    union{
        char* ID;
        int INT;
        float FLOAT;
    };
};
typedef struct TREE *treeNode;

int hasFault;
int nodeNum;
treeNode nodeList[1000];
int nodeIsChild[1000];

int stoi(char * p);

void setChildTag (treeNode node);

treeNode newNode(char *name, int num, int yyline, treeNode childList[]);

void preOrder(treeNode t, int level);

void printTree();

void yyerror(char *msg);

treeNode cre_gram_unit(char* name, int yyline, int num, ...);
#endif
