#ifndef SEMANTIC_H
#define SEMENTIC_H

#define HASH_TABLE_SIZE 0x3fff
#define STACK_DEEP

#include "node.h"

typedef struct type* pType;
typedef struct fieldList* pFieldList;
typedef struct tableItem* pItem;
typedef struct hashTable* pHash;
typedef struct stack* pStack;
typedef struct table* pTable;


typedef struct fieldList {
    char* name;       // 域的名字
    pType type;       // 域的类型
    pFieldList tail;  // 下一个域
} FieldList;

typedef struct type {
    Kind kind;
    // 确定数据存储的大小
    union {
        BasicType basic;    // 基本类型
        struct {
            pType elem; // 数组元素类型
            int size;   // 数组大小
        } array;    // 数组
        struct {
            char* structName;   // 结构体名字
            pFieldList field;   // 结构体域
        } structure;    // 结构体
        struct {
            int argc;   // 参数个数    
            pFieldList argv;    // 参数列表
            pType returnType;   // 返回值类型
        } function; // 函数
    } u;
} Type;



typedef struct tableItem {
    int symbolDepth;    // 符号层次
    pFieldList field;   // 域
    pItem nextSymbol;  // 下一个符号表项
    pItem nextHash;    // 下一个哈希表项
} TableItem;    // 符号表项


typedef struct hashTable {
    pItem* hashArray;
} HashTable;    // 哈希表

typedef struct stack {
    pItem* stackArray;
    int curStackDepth; // 栈高
} Stack;    // 栈

typedef struct table {
    pHash hash; // 哈希表
    pStack stack; // 栈
    int unNamedStructNum;
    // int enterStructLayer;
} Table;    // 符号表

extern pTable table;


// Type functions
pType newType(Kind kind, ...);
pType copyType(pType src);
void deleteType(pType type);
boolean checkType(pType type1, pType type2);
void printType(pType type);

// FieldList functions

// inline pFieldList newFieldList() {
//     pFieldList p = (pFieldList)malloc(sizeof(FieldList));
//     p->name = NULL;
//     p->type = NULL;
//     p->tail = NULL;
//     return p;
// }

pFieldList newFieldList(char* newName, pType newType);
pFieldList copyFieldList(pFieldList src);
void deleteFieldList(pFieldList fieldList);
void setFieldListName(pFieldList p, char* newName);
void printFieldList(pFieldList fieldList);

// tableItem functions

// inline pItem newItem() {
//     pItem p = (pItem)malloc(sizeof(TableItem));
//     p->symbolDepth = 0;
//     p->field = NULL;
//     p->nextHash = NULL;
//     p->nextSymbol = NULL;
//     return p;
// }

pItem newItem(int symbolDepth, pFieldList pfield);
void deleteItem(pItem item);
boolean isStructDef(pItem src);

// Hash functions
pHash newHash();
void deleteHash(pHash hash);
pItem getHashHead(pHash hash, int index);
void setHashHead(pHash hash, int index, pItem newVal);

// Stack functions
pStack newStack();
void deleteStack(pStack stack);
void addStackDepth(pStack stack);
void minusStackDepth(pStack stack);
pItem getCurDepthStackHead(pStack stack);
void setCurDepthStackHead(pStack stack, pItem newVal);

// Table functions
pTable initTable();
void deleteTable(pTable table);
pItem searchTableItem(pTable table, char* name);
boolean checkTableItemConflict(pTable table, pItem item);
void addTableItem(pTable table, pItem item);
void deleteTableItem(pTable table, pItem item);
void clearCurDepthStackList(pTable table);
// void addStructLayer(pTable table);
// void minusStructLayer(pTable table);
// boolean isInStructLayer(pTable table);
void printTable(pTable table);

// 哈希
static inline unsigned int getHashCode(char* name) {
    unsigned int val = 0, i;
    for (; *name; ++name) {
        val = (val << 2) + *name;
        if (i = val & ~HASH_TABLE_SIZE)
            val = (val ^ (i >> 12)) & HASH_TABLE_SIZE;
    }
    return val;
}

static inline void pError(ErrorType type, int line, char* msg) {
    printf("Error type %d at Line %d: %s\n", type, line, msg);
}

void traverseTree(pNode node);

// Generate symbol table functions
void ExtDef(pNode node);
void ExtDecList(pNode node, pType specifier);
pType Specifier(pNode node);
pType StructSpecifier(pNode node);
pItem VarDec(pNode node, pType specifier);
void FunDec(pNode node, pType returnType);
void VarList(pNode node, pItem func);
pFieldList ParamDec(pNode node);
void CompSt(pNode node, pType returnType);
void StmtList(pNode node, pType returnType);
void Stmt(pNode node, pType returnType);
void DefList(pNode node, pItem structInfo);
void Def(pNode node, pItem structInfo);
void DecList(pNode node, pType specifier, pItem structInfo);
void Dec(pNode node, pType specifier, pItem structInfo);
pType Exp(pNode node);
void Args(pNode node, pItem funcInfo);

#endif