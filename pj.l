%{
#include "pj.tab.h"
#include <string.h>
int linha = 1;
%}

%%
[ \t\r]+            { }
\n                  { linha++; }

"//".* { }
"/*"([^*]|\*+[^*/])*(\*+"/") { }

"begin"             { return INICIO; }
"end"               { return FIM; }
"leia"              { return LEIA; }
"escreva"           { return ESCREVA; }
"if"                { return IF; }
"else"              { return ELSE; }
"while"             { return WHILE; }
"raiz"              { return RAIZ; }

"=="                { return IGUAL; }
">"                 { return MAIOR; }
"<"                 { return MENOR; }
"="                 { return ATRIB; }

[a-z]               { yylval.var_index = yytext[0] - 'a'; return ID; }
[0-9]+(\.[0-9]*)?   { yylval.real_value = atof(yytext); return NUMERO; }
\"([^\\\"]|\\.)*\"  { 
                        strncpy(yylval.string_value, yytext+1, strlen(yytext)-2); 
                        yylval.string_value[strlen(yytext)-2] = '\0';
                        return STRING; 
                    }

"["                 { return '['; }
"]"                 { return ']'; }
[+*/\-(){};]        { return *yytext; }
.                   { printf("Erro lexico na linha %d: %s\n", linha, yytext); }

%%
int yywrap() { return 1; }