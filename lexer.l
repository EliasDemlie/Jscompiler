%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
// Define tokens
int yylval;
#define VAR 1
#define LET 2
#define CONST 3
#define FUNCTION 4
#define IF 5
#define ELSE 6
#define WHILE 7
#define FOR 8
#define BREAK 9
#define CONTINUE 10
#define RETURN 11
#define TRY 12
#define CATCH 13
#define FINALLY 14
#define CLASS 15
#define PUBLIC 16
#define PRIVATE 17
#define STATIC 18
#define PROTECTED 19
#define NEW 20
#define THIS 21
#define TRUE 22
#define FALSE 23
#define UNDEFINED 24
#define NULL_TOKEN 25
#define TYPEOF 26
#define INSTANCEOF 27
#define NUMBER 28
#define FLOAT_LITERAL 29
#define STRING_LITERAL 30
#define CHAR_LITERAL 31
#define IDENTIFIER 32
#define EQ 33
#define STRICT_EQ 34
#define NEQ 35
#define STRICT_NEQ 36
#define GTE 37
#define LTE 38
#define GT 39
#define LT 40
#define ASSIGN 41
#define PLUS 42
#define MINUS 43
#define MULT 44
#define DIV 45
#define MOD 46
#define AND 47
#define OR 48
#define NOT 49
#define SEMICOLON 50
#define COMMA 51
#define LBRACE 52
#define RBRACE 53
#define LBRACKET 54
#define RBRACKET 55
#define LPAREN 56
#define RPAREN 57
#define DOT 58

int yywrap(void) {
    return 1;
}

%}
%%
"var"                { printf("Token: VAR\n"); return VAR; }
"let"                { printf("Token: LET\n"); return LET; }
"const"              { printf("Token: CONST\n"); return CONST; }
"function"           { return FUNCTION; }
"if"                 { return IF; }
"else"               { return ELSE; }
"while"              { return WHILE; }
"for"                { return FOR; }
"break"              { return BREAK; }
"continue"           { return CONTINUE; }
"return"             { return RETURN; }
"try"                { return TRY; }
"catch"              { return CATCH; }
"finally"            { return FINALLY; }
"class"              { return CLASS; }
"static"             { return STATIC; }
"new"                { return NEW; }
"this"               { return THIS; }
"true"               { return TRUE; }
"false"              { return FALSE; }
"undefined"          { return UNDEFINED; }
"null"               { return NULL_TOKEN; }
"typeof"             { return TYPEOF; }
"instanceof"         { return INSTANCEOF; }

[0-9]+               { yylval = atoi(yytext); printf("Token: NUMBER\n"); return NUMBER; } // Integers
[0-9]+"."[0-9]+      { yylval = atof(yytext); return FLOAT_LITERAL; } // Floating-point numbers
\"[^\"]*\"           { printf("Token: STRING_LITERAL\n"); return STRING_LITERAL; } // String literals
\'[^\']\'            { return CHAR_LITERAL; } // Char literals
[a-zA-Z_][a-zA-Z0-9_]* { printf("Token: IDENTIFIER\n"); return IDENTIFIER; }
"=="                { return EQ; }
"==="               { return STRICT_EQ; }  // JavaScript has '===' for strict equality
"!="                { return NEQ; }
"!=="               { return STRICT_NEQ; } // JavaScript has '!' for strict inequality
">="                { return GTE; }
"<="                { return LTE; }
">"                 { return GT; }
"<"                 { return LT; }
"="                 { printf("Token: ASSIGN\n"); return ASSIGN; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MULT; }
"/"                 { return DIV; }
"%"                 { return MOD; }
"&&"                { return AND; }
"||"                { return OR; }
"!"                 { return NOT; }
";"                 { return SEMICOLON; }
","                 { return COMMA; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"["                 { return LBRACKET; }
"]"                 { return RBRACKET; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"."                 { return DOT; }

[ \t\n\r]+          { /* Ignore whitespace */ }
"//".*              { /* Ignore single-line comments */ }
"/*"([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+"/" {}  // Multi-line comments

[0-9]+[a-zA-Z_]+    { fprintf(stderr, "Error: Invalid token '%s' at line %d\n", yytext, yylineno); exit(1); }

.                   { fprintf(stderr, "Error: Invalid character '%s' at line %d\n", yytext, yylineno); exit(1); }
%%


int main() {
    printf("Enter your input: \n");
    while (yylex() != 0);  // Keep calling yylex until it returns 0 (end of input)
    return 0;
}
