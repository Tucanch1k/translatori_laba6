%{
#include "parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void yyerror(const char *s);
extern int yylineno;
extern char *yytext;

static int lex_error = 0;
%}

%option noyywrap
%option yylineno

%%

[ \t]+              { /* пропустить пробелы и табуляции */ }

"\n"                {
                        return '\n';
                    }

"#".*               { /* пропустить комментарии */ }

[0-9]+              {
                        yylval.num = atoi(yytext);
                        return NUM;
                    }

"pow"               {
                        return POW;
                    }

"+"                 {
                        return PLUS;
                    }

"*"                 {
                        return MULT;
                    }

"("                 {
                        return LPAREN;
                    }

")"                 {
                        return RPAREN;
                    }

","                 {
                        return COMMA;
                    }

-?[0-9]+            {
                        yylval.num = atoi(yytext);
                        return NUM;
                    }

[a-zA-Z]+           {
                        fprintf(stderr, "Лексическая ошибка в строке %d: недопустимый идентификатор '%s'\n", yylineno, yytext);
                        lex_error = 1;
                    }

.                   {
                        fprintf(stderr, "Лексическая ошибка в строке %d: недопустимый символ '%s'\n", yylineno, yytext);
                        lex_error = 1;
                    }

%%

int has_lex_error(void) {
    return lex_error;
}