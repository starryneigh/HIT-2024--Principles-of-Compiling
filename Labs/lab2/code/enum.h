#ifndef ENUM_H
#define ENUM_H

// define node type
typedef enum _nodeType {
    TOKEN_INT,  // int
    TOKEN_FLOAT,    // float
    TOKEN_ID,   // id
    TOKEN_TYPE, // type
    TOKEN_OTHER,    //其它关键字
    NOT_A_TOKEN //非终结节点

} NodeType; // 节点类型

typedef enum _kind { BASIC, ARRAY, STRUCTURE, FUNCTION } Kind;  // 类型种类
typedef enum _basicType { INT_TYPE, FLOAT_TYPE } BasicType; // 基本类型
typedef enum _errorType {
    UNDEF_VAR = 1,         // Undefined Variable, Exp -> ID
    UNDEF_FUNC,            // Undefined Function, Exp -> ID LP Args RP | ID LP RP
    REDEF_VAR,             // Redefined Variable, ExtDecList -> VarDec, ParamDec -> Specifier VarDec, Dec -> VarDec | VarDec ASSIGNOP Exp
    REDEF_FUNC,            // Redefined Function, FunDec -> ID LP VarList RP
    TYPE_MISMATCH_ASSIGN,  // Type mismatched for assignment, Dec -> VarDec ASSIGNOP Exp, Exp -> Exp ASSIGNOP Exp
    LEFT_VAR_ASSIGN,  // The left-hand side of an assignment must be a variable, Exp -> Exp ASSIGNOP Exp
    TYPE_MISMATCH_OP,      // Type mismatched for operands, Exp -> Exp AND Exp
    TYPE_MISMATCH_RETURN,  // Type mismatched for return, Stmt -> RETURN Exp SEMI
    FUNC_AGRC_MISMATCH,    // Function is not applicable for arguments, Exp -> ID LP RP, Args -> Exp COMMA Args
    NOT_A_ARRAY,           // Variable is not a Array, Exp -> Exp LB Exp RB
    NOT_A_FUNC,            // Variable is not a Function, Exp -> ID LP Args RP
    NOT_A_INT,             // Variable is not a Integer, Exp -> Exp LB Exp RB
    ILLEGAL_USE_DOT,       // Illegal use of ".", Exp -> Exp DOT ID
    NONEXISTFIELD,         // Non-existentfield, Exp -> Exp DOT ID
    REDEF_FEILD,           // Redefined field, Dec -> VarDec | VarDec ASSIGNOP Exp
    DUPLICATED_NAME,       // Duplicated name, StructSpecifier -> STRUCT OptTag LC DefList RC
    UNDEF_STRUCT           // Undefined structure, StructSpecifier->STRUCT Tag
} ErrorType;

#endif