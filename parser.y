%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

#define YYERROR_VERBOSE 1

extern int yylineno;
extern char *yytext;
%}

%union {
    int num;
}

%token <num> NUM
%token PLUS MULT LPAREN RPAREN COMMA POW
%token ERROR

%type <num> expr term factor pow_func

%start input

%%

input   : /* пусто */
        | input line
        ;

line    : expr '\n'          { 
                              printf(">>> РЕЗУЛЬТАТ: %d <<<\n", $1); 
                              printf("> ");
                            }
        | '\n'               { printf("> "); }
        | error '\n'         { 
                              yyerrok; 
                              printf("> ");
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
    if (strstr(s, "unexpected $end") || strstr(s, "unexpected end of file")) {
        fprintf(stderr, "Синтаксическая ошибка в строке %d: неожиданный конец выражения\n", yylineno);
    }
    else if (strstr(s, "syntax error")) {
        fprintf(stderr, "Синтаксическая ошибка в строке %d: неверная структура выражения\n", yylineno);
    }
    else {
        fprintf(stderr, "Синтаксическая ошибка в строке %d: %s\n", yylineno, s);
    }
}

int main(void) {
    printf("=== Транслятор арифметических выражений ===\n");
    printf("Поддержка: +, *, pow(a,b), скобки, отрицательные числа\n");
    printf("Введите выражение (Ctrl+D для выхода):\n");
    printf("> ");
    yyparse();
    printf("\nДо свидания!\n");
    return 0;
}