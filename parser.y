%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;

extern int yylval;
extern FILE *yyin;

void yyerror(const char *s);
int yylex();

%}

%token VAR LET CONST FUNCTION RETURN IF ELSE WHILE FOR BREAK CONTINUE
%token TRY CATCH FINALLY CLASS NEW THIS TRUE FALSE UNDEFINED NULL_TOKEN TYPEOF INSTANCEOF
%token IDENTIFIER NUMBER FLOAT_LITERAL STRING_LITERAL CHAR_LITERAL
%token PLUS MINUS MULT DIV MOD
%token EQ STRICT_EQ NEQ STRICT_NEQ GT LT GTE LTE ASSIGN INCREMENT DECREMENT
%token AND OR NOT
%token EOL SEMICOLON COMMA DOT LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET

%left OR
%left AND
%left EQ NEQ STRICT_EQ STRICT_NEQ
%left GT LT GTE LTE
%left PLUS MINUS
%left MULT DIV MOD
%right NOT
%nonassoc ELSE


%%
program:
    program statement
    | statement
    ;

statement:
    variable_declaration
    | assignment_statement
    | function_declaration
    | if_statement
    | while_statement
    | for_statement
    | return_statement
    | break_statement
    | continue_statement
    | expression_statement
    | function_call_statement
    | block
    ;

variable_declaration:
    modifier IDENTIFIER terminator
    | modifier IDENTIFIER ASSIGN expression terminator
    | CONST IDENTIFIER ASSIGN expression terminator
    ;

terminator:  EOL | SEMICOLON ;

modifier: VAR | LET ;

assignment_statement:
    IDENTIFIER ASSIGN expression terminator
    ;

function_declaration:
    FUNCTION IDENTIFIER LPAREN parameter_list RPAREN block
    ;

parameter_list:
    parameter_list COMMA IDENTIFIER
    | IDENTIFIER
    | /* empty */
    ;


function_call_statement:
    function_call terminator
    ;

function_call:
    IDENTIFIER LPAREN argument_list RPAREN
    ;

argument_list:
    argument_list COMMA expression
    | expression | function_call
    | /* empty */
    ;


block:
    LBRACE statement_list RBRACE
    ;

statement_list:
    statement_list statement
    | /* empty */
    ;


if_statement:
    IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    | expression
    ;


while_statement:
    WHILE LPAREN expression RPAREN statement
    ;

for_statement:
    FOR LPAREN for_initializer SEMICOLON expression SEMICOLON for_update RPAREN statement
    ;

for_initializer:
    variable_declaration
    | assignment_statement
    | /* empty */
    ;

for_update:
    assignment_statement
    | /* empty */
    ;

return_statement:
    RETURN expression terminator
    | RETURN terminator
    ;

break_statement:
    BREAK terminator
    ;

continue_statement:
    CONTINUE terminator
    ;

expression_statement:
    expression terminator
    ;

expression:
    expression PLUS expression                          { /* addition operation */ }
    | expression MINUS expression                         { /* subtraction operation */ }
    | expression MULT expression                          { /* multiplication operation */ }
    | expression DIV expression                           { /* division operation */ }
    | expression MOD expression                           { /* modulo operation */ }
    | expression GT expression                           { /* greater than comparison */ }
    | expression LT expression                           { /* less than comparison */ }
    | expression GTE expression                          { /* greater than or equal */ }
    | expression LTE expression                          { /* less than or equal */ }
    | expression EQ expression                           { /* equality comparison */ }
    | expression STRICT_EQ expression                     { /* strict equality comparison */ }
    | expression NEQ expression                          { /* not equal comparison */ }
    | expression STRICT_NEQ expression                    { /* strict not equal comparison */ }
    | expression AND expression                          { /* logical AND */ }
    | expression OR expression                           { /* logical OR */ }
    | NOT expression                                     { /* logical NOT */ }
    | IDENTIFIER INCREMENT                               { /* postfix increment */ }
    | IDENTIFIER DECREMENT                               { /* postfix decrement */ }
    | INCREMENT IDENTIFIER                               { /* prefix increment */ }
    | DECREMENT IDENTIFIER                               { /* prefix decrement */ }
    | IDENTIFIER ASSIGN expression                       { /* assignment operation */ }
    | expression PLUS ASSIGN expression                   { /* addition assignment */ }
    | expression MINUS ASSIGN expression                  { /* subtraction assignment */ }
    | expression MULT ASSIGN expression                   { /* multiplication assignment */ }
    | expression DIV ASSIGN expression                    { /* division assignment */ }
    | expression MOD ASSIGN expression                    { /* modulo assignment */ }
    | LPAREN expression RPAREN                           { /* parentheses to group expressions */ }
    | IDENTIFIER                                          { /* simple identifier */ }
    | NUMBER                                              { /* number literal */ }
    | FLOAT_LITERAL                                       { /* float literal */ }
    | STRING_LITERAL                                      { /* string literal */ }
    | CHAR_LITERAL                                        { /* char literal */ }
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s at line %d\n", s, yylineno);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <source_file.js>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Error opening file");
        return 1;
    }

    yyin = input_file;

    printf("JavaScript Parser - Parsing Started\n");
    if (yyparse() == 0) {
        printf("Parsing Completed Successfully\n");
    } else {
        printf("Parsing Failed\n");
    }

    fclose(input_file);
    return 0;
}
