%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lex.yy.c"
#include "lexer.h"  // Include the lexer header file

extern int yylex();  // Declare the lexer function
extern int yylval;   // Declare the global variable for the token value
%}

%union {
    int ival;
    char* sval;
}

%token <ival> NUMBER
%token <sval> STRING_LITERAL IDENTIFIER
%token VAR LET CONST FUNCTION IF ELSE WHILE FOR RETURN

%token EQ STRICT_EQ NEQ STRICT_NEQ GTE LTE GT LT ASSIGN PLUS MINUS MULT DIV MOD AND OR NOT SEMICOLON COMMA LBRACE RBRACE LPAREN RPAREN

%start program

%%

program:
    statements
;

statements:
    statements statement
    | statement
;

statement:
    declaration
    | expression_statement
    | block
;

declaration:
    VAR IDENTIFIER ASSIGN expression SEMICOLON
    | LET IDENTIFIER ASSIGN expression SEMICOLON
    | CONST IDENTIFIER ASSIGN expression SEMICOLON
;

expression_statement:
    expression SEMICOLON
;

expression:
    NUMBER
    | STRING_LITERAL
    | IDENTIFIER
    | expression PLUS expression
    | expression MINUS expression
    | expression MULT expression
    | expression DIV expression
    | expression AND expression
    | expression OR expression
    | LPAREN expression RPAREN
;

block:
    LBRACE statements RBRACE
;

%%

int main() {
    printf("Enter JavaScript code:\n");
    yyparse();  // Call the parser
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}
