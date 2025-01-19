%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%
"var"                { printf("Token: VAR\n"); return VAR; }
"let"                { printf("Token: LET\n"); return LET; }
"const"              { printf("Token: CONST\n"); return CONST; }
"function"           { printf("Token: FUNCTION\n"); return FUNCTION; }
"if"                 { printf("Token: IF\n"); return IF; }
"else"               { printf("Token: ELSE\n"); return ELSE; }
"while"              { printf("Token: WHILE\n"); return WHILE; }
"for"                { return FOR; }
"break"              { return BREAK; }
"continue"           { return CONTINUE; }
"return"             { return RETURN; }
"try"                { return TRY; }
"catch"              { return CATCH; }
"finally"            { return FINALLY; }
"class"              { return CLASS; }
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

.                   { fprintf(stderr, "Error: Invalid character '%s' at line %d\n", yytext, yylineno); exit(1); }
%%


int yywrap() {
    return 1;
}