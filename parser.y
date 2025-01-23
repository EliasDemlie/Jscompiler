%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern int yylval;
extern FILE *yyin;

void yyerror(const char *s);
int yylex();

%}

%token VAR LET CONST FUNCTION RETURN IF ELSE WHILE FOR DO BREAK CONTINUE
%token TRY CATCH FINALLY CLASS NEW THIS TRUE FALSE UNDEFINED NULL_TOKEN TYPEOF INSTANCEOF 
%token CONSOLE LOG
%token IDENTIFIER NUMBER FLOAT_LITERAL STRING_LITERAL CHAR_LITERAL
%token PLUS MINUS MULT DIV MOD
%token EQ STRICT_EQ NEQ STRICT_NEQ GT LT GTE LTE ASSIGN INCREMENT DECREMENT
%token AND OR NOT
%token SEMICOLON COMMA DOT ARROW LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET

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
    variable_declaration SEMICOLON
    | assignment_statement SEMICOLON
    | function_declaration
    | if_statement
    | while_statement
    | do_while_statement
    | for_statement
    | return_statement SEMICOLON
    | break_statement SEMICOLON
    | continue_statement SEMICOLON
    | expression_statement SEMICOLON
    | function_call_statement SEMICOLON
    | block
    ;

variable_declaration:
    modifier IDENTIFIER
    | modifier IDENTIFIER ASSIGN expression
    | CONST IDENTIFIER ASSIGN expression
    ;

modifier: VAR | LET ;

assignment_statement:
    IDENTIFIER ASSIGN expression
    ;

function_declaration:
    FUNCTION IDENTIFIER LPAREN parameter_list RPAREN block
    | CONST IDENTIFIER ASSIGN FUNCTION LPAREN parameter_list RPAREN block
    | modifier IDENTIFIER ASSIGN FUNCTION LPAREN parameter_list RPAREN block
    | modifier IDENTIFIER ASSIGN LPAREN parameter_list RPAREN ARROW block
    | CONST IDENTIFIER ASSIGN LPAREN parameter_list RPAREN ARROW block
    ;

parameter_list:
    parameter_list COMMA IDENTIFIER
    | IDENTIFIER
    | // empty
    ;

function_call_statement:
    function_call
    | console_log_call
    ;

function_call:
    IDENTIFIER LPAREN argument_list RPAREN
    ;

console_log_call:
    CONSOLE DOT LOG LPAREN argument_list RPAREN
    ;

argument_list:
    argument_list COMMA expression
    | expression
    | function_call
    | // empty
    ;

block:
    LBRACE statement_list RBRACE
    ;

statement_list:
    statement_list statement
    | // empty
    ;

if_statement:
    IF LPAREN expression RPAREN statement
    | IF LPAREN expression RPAREN statement ELSE statement
    ;

while_statement:
    WHILE LPAREN expression RPAREN statement
    ;

do_while_statement:
    DO statement WHILE LPAREN expression RPAREN SEMICOLON
    ;

for_statement:
    FOR LPAREN for_initializer SEMICOLON expression SEMICOLON for_update RPAREN statement
    | FOR LPAREN SEMICOLON expression SEMICOLON for_update RPAREN statement
    | FOR LPAREN for_initializer SEMICOLON SEMICOLON for_update RPAREN statement
    | FOR LPAREN for_initializer SEMICOLON expression SEMICOLON RPAREN statement
    | FOR LPAREN SEMICOLON SEMICOLON RPAREN statement
    ;

for_initializer:
    variable_declaration
    | assignment_statement
    | expression
    | // empty
    ;

for_update:
    assignment_statement
    | expression
    | // empty
    ;

return_statement:
    RETURN expression
    | RETURN
    ;

break_statement:
    BREAK
    ;

continue_statement:
    CONTINUE
    ;

expression_statement:
    expression
    ;

expression:
    expression PLUS expression
    | expression MINUS expression
    | expression MULT expression
    | expression DIV expression
    | expression MOD expression
    | expression GT expression
    | expression LT expression
    | expression GTE expression
    | expression LTE expression
    | expression EQ expression
    | expression STRICT_EQ expression
    | expression NEQ expression
    | expression STRICT_NEQ expression
    | expression AND expression
    | expression OR expression
    | NOT expression
    | IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    | INCREMENT IDENTIFIER
    | DECREMENT IDENTIFIER
    | IDENTIFIER ASSIGN expression
    | expression PLUS ASSIGN expression
    | expression MINUS ASSIGN expression
    | expression MULT ASSIGN expression
    | expression DIV ASSIGN expression
    | expression MOD ASSIGN expression
    | LPAREN expression RPAREN
    | IDENTIFIER
    | NUMBER
    | FLOAT_LITERAL
    | STRING_LITERAL
    | CHAR_LITERAL
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