%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pj.tab.h"

extern FILE *yyin;

int linha = 1;

char* remover_aspas(char* s){
    int tam = strlen(s);

    if (tam < 2) {
        char *scopy = malloc(1);
        if (scopy) scopy[0] = '\0';
        return scopy;
    }

    char *scopy = malloc(tam - 1);
    if (scopy == NULL) {
        return NULL;
    }
    strncpy(scopy, s + 1, tam - 2);
    scopy[tam - 2] = '\0';

    return scopy;
}
%}


LETRA               [a-zA-Z]
DIGITO              [0-9]
ALFANUMERICO        ({LETRA}|{DIGITO}|_)
IDENTIFICADOR       {LETRA}({ALFANUMERICO})*
NUMERO_REAL         {DIGITO}+\.{DIGITO}*|\.{DIGITO}+|{DIGITO}+
OPERADOR_ARITMETICO [+\\*/-]
OPERADOR_ATRIBUICAO "="
IGNORA              [ \t\r]+
DELIMITADOR         [();,]
STRING              \"([^\\\"]|\\.)*\"
COMENTARIO_BLOCO    "/*"(.|\n)*"*/"
COMENTARIO_INLINE   "//".*
PALAVRA_FUNCAO      "raiz"


%%
{IGNORA}+   { }
\n          { linha++; }

{COMENTARIO_BLOCO}  { }
{COMENTARIO_INLINE} { }

"begin"             { return INICIO; }
"end"               { return FIM; }

"leia"              { return LEIA; }
"escreva"           { return ESCREVA; }

{PALAVRA_FUNCAO}    { return RAIZ; }

{OPERADOR_ATRIBUICAO}   { return ATRIB; }

{OPERADOR_ARITMETICO}   { return *yytext; }

{IDENTIFICADOR}         {
                            yylval.var_index = *yytext - 'a';
                            return ID;
                        }

{NUMERO_REAL}           {
                            yylval.real_value = atof(yytext);
                            return NUMERO;
                        }

{STRING}                {
                            char *string_sem_aspas = remover_aspas(yytext);
                            if (string_sem_aspas) {
                                strcpy(yylval.string_value, string_sem_aspas);
                                free(string_sem_aspas);
                            }
                            return STRING;
                        }

"("                     { return '('; }
")"                     { return ')'; }
";"                     { return ';'; }
","                     { return ','; }

.                       { printf("ERRO LEXICO: Caractere não reconhecido '%s' na linha %d\n", yytext, linha); }

%%
int yywrap(void) {
    return 1;
}

