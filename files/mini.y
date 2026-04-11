%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
int has_lex_error(void);

extern FILE *yyin;
extern int yylineno;

#define YYERROR_VERBOSE 1

static int has_error = 0;
static int current_has_error = 0;
%}

%union {
    int num;
}

%token <num> NUM
%token PLUS MULT LPAREN RPAREN COMMA POW
%token LEX_ERROR

%type <num> expr term factor pow_func

%start input

%%

input   : /* пусто */
        | input line
        ;

line    : expr '\n'          { 
                              if (!current_has_error && !has_lex_error()) {
                                  printf("%d\n", $1);
                              }
                              current_has_error = 0;
                            }
        | '\n'               { 
                              current_has_error = 0;
                            }
        | LEX_ERROR '\n'     { 
                              has_error = 1;
                              current_has_error = 1;
                              yyerrok;
                            }
        | error '\n'         { 
                              has_error = 1;
                              current_has_error = 1;
                              yyerrok;
                            }
        ;

expr    : term               { $$ = $1; }
        | expr PLUS term     { $$ = $1 + $3; }
        ;

term    : factor             { $$ = $1; }
        | term MULT factor   { $$ = $1 * $3; }
        ;

factor  : NUM                { $$ = $1; }
        | pow_func           { $$ = $1; }
        | LPAREN expr RPAREN { $$ = $2; }
        ;

pow_func: POW LPAREN expr COMMA expr RPAREN {
            $$ = (int)pow($3, $5);
        }
        ;

%%

void yyerror(const char *s) {
    has_error = 1;
    current_has_error = 1;
    if (!has_lex_error()) {
        if (strstr(s, "unexpected $end") || strstr(s, "unexpected end of file")) {
            fprintf(stderr, "Синтаксическая ошибка в строке %d: неожиданный конец выражения\n", yylineno);
        }
        else {
            fprintf(stderr, "Синтаксическая ошибка в строке %d: %s\n", yylineno, s);
        }
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    FILE *input = fopen(argv[1], "r");
    if (!input) {
        fprintf(stderr, "Ошибка: не удалось открыть файл '%s'\n", argv[1]);
        return 1;
    }
    
    yyin = input;
    has_error = 0;
    current_has_error = 0;
    yyparse();
    fclose(input);
    
    return (has_error || has_lex_error()) ? 1 : 0;
}