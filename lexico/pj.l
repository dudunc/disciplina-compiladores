%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int linha = 1; 

    // Função para remover as aspas de strings e caracteres
    char* remover_aspas(char* s){
        int tam = strlen(s);

        if (tam < 2) {
            char *scopy = malloc(1);
            if (scopy) scopy[0] = '\0';
            return scopy;
        }

        char *scopy = malloc(tam - 1);
        strncpy(scopy, s + 1, tam - 2);
        scopy[tam - 2] = '\0';

        return scopy;
    }
%}

%x COMENTARIO_BLOCK


LETRA                 [a-zA-Z]
DIGITO                [0-9]
IDENTIFICADOR         {LETRA}({LETRA}|{DIGITO})*
NUMERO_INTEIRO        {DIGITO}+
NUMERO_DECIMAL        {DIGITO}+\.{DIGITO}+
OPERADOR_ARITMETICO   [+\-*/]
OPERADOR_LOGICO       ("&&"|"||"|"and"|"or")
OPERADOR_RELACIONAL   ("=="|"!="|">="|"<="|">"|"<")
OPERADOR_ATRIBUICAO   "="
IGNORA                [ \t\r]+
DELIMITADOR           [(){}\[\];,]
COMENTARIO_INLINE     "//".*
STRING                \"([^\\\"]|\\.)*\"
CARACTERE_UNITARIO    '([^'\n])'


%%


<INITIAL>"/*"             { BEGIN(COMENTARIO_BLOCK); }
<COMENTARIO_BLOCK>"*/"    { BEGIN(INITIAL); }
<COMENTARIO_BLOCK>"\n"    { linha++; }
<COMENTARIO_BLOCK>.       { }

"begin"             { printf("KEYWORD: INICIO DE PROGRAMA\t%s\n", yytext); }
"end"               { printf("KEYWORD: FIM DE PROGRAMA\t\t%s\n", yytext); }
"read"              { printf("KEYWORD: LEITURA DE DADOS\t%s\n", yytext); }
"print"             { printf("KEYWORD: IMPRESSAO\t\t%s\n", yytext); }
"loop"              { printf("KEYWORD: REPETICAO\t\t%s\n", yytext); }
"if"                { printf("KEYWORD: CONDICIONAL\t\t%s\n", yytext); }
"else"              { printf("KEYWORD: CONDICIONAL\t\t%s\n", yytext); }
"return"            { printf("KEYWORD: RETORNO\t\t%s\n", yytext); }

"integer"           { printf("TYPE: INTEIRO\t\t\t%s\n", yytext); }
"decimal"           { printf("TYPE: FLOAT\t\t\t%s\n", yytext); }
"text"              { printf("TYPE: STRING\t\t\t%s\n", yytext); }
"logical"           { printf("TYPE: BOOLEANO\t\t%s\n", yytext); }
"true"              { printf("LITERAL: BOOLEANO\t\t%s\n", yytext); }
"false"             { printf("LITERAL: BOOLEANO\t\t%s\n", yytext); }

{IDENTIFICADOR}         { printf("IDENTIFIER:\t\t\t%s\n", yytext); }

{NUMERO_DECIMAL}        { printf("LITERAL: NUMERO DECIMAL\t\t%s\n", yytext); }
{NUMERO_INTEIRO}        { printf("LITERAL: NUMERO INTEIRO\t\t%s\n", yytext); }

{OPERADOR_LOGICO}       { printf("OPERATOR: LOGICO\t\t%s\n", yytext); }
{OPERADOR_ARITMETICO}   { printf("OPERATOR: ARITMETICO\t\t%s\n", yytext); }
{OPERADOR_RELACIONAL}   { printf("OPERATOR: RELACIONAL\t\t%s\n", yytext); }
{OPERADOR_ATRIBUICAO}   { printf("OPERATOR: ATRIBUICAO\t\t%s\n", yytext); }

{DELIMITADOR}           { printf("DELIMITER:\t\t\t%s\n", yytext); }

{STRING}                {
    char *string_sem_aspas = remover_aspas(yytext);
    printf("LITERAL: STRING\t\t\t%s\n", string_sem_aspas);
    free(string_sem_aspas); 
}
{CARACTERE_UNITARIO}    {
    char *char_sem_apostrofo = remover_aspas(yytext);
    printf("LITERAL: CARACTERE\t\t%s\n", char_sem_apostrofo);
    free(char_sem_apostrofo);
}

{COMENTARIO_INLINE}     { printf("COMMENT:\t\t\t%s\n", yytext); }

{IGNORA}                { }
\n                      { linha++; }

.                       { printf("ERROR: Caractere não reconhecido '%s' na linha %d\n", yytext, linha); }

%%

int main() {
    yyin = fopen("teste.pj", "r"); 
    if (!yyin) {
        perror("Erro ao abrir arquivo");
        return 1;
    }
    yylex(); 
    fclose(yyin);
    return 0;
}