%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

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
IDENTIFICADOR       ({LETRA}|_)({ALFANUMERICO})*
NUMERO_INTEIRO      {DIGITO}+
NUMERO_DECIMAL      {DIGITO}+\.{DIGITO}+
OPERADOR_ARITMETICO [+\-*/%]
OPERADOR_LOGICO     ("&&"|"||"|"and"|"or")
OPERADOR_RELACIONAL ("=="|"!="|">="|"<="|">"|"<")
OPERADOR_ATRIBUICAO "="
OPERADOR_ATRIBUICAO_COMPOSTA "+="|"-="|"*="|"/="|"%="
OPERADOR_INCREMENTO   "++"
OPERADOR_DECREMENTO   "--"
OPERADOR_PONTEIRO       "->"
IGNORA              [ \t\r]+
DELIMITADOR         [(){}\[\];,:]
COMENTARIO_INLINE   "//".*
STRING              \"([^\\\"]|\\.)*\"
CARACTERE_UNITARIO  '([^'\n])'
SIMBOLO_ENDERECO    "&"
SIMBOLO_PONTEIRO "**"

%%

"/*"(.|\n)*"*/" { printf("COMMEN-BLOCK:\t\t\t\t%s\n", yytext); }


{COMENTARIO_INLINE} { printf("COMMENT-LINE:\t\t\t\t%s\n", yytext); }

"begin"            { printf("KEYWORD: INICIO DE PROGRAMA\t\t%s\n", yytext); }
"end"              { printf("KEYWORD: FIM DE PROGRAMA\t\t%s\n", yytext); }
"read"             { printf("KEYWORD: LEITURA DE DADOS\t\t%s\n", yytext); }
"print"            { printf("KEYWORD: IMPRESSAO\t\t\t%s\n", yytext); }
"do"               { printf("KEYWORD: REPETICAO-DO\t\t%s\n", yytext); }
"switch"           { printf("KEYWORD: SELECAO MULTIPLA\t\t%s\n", yytext); }
"while"            { printf("KEYWORD: REPETICAO-WHILE\t\t%s\n", yytext); }
"for"              { printf("KEYWORD: REPETICAO-FOR\t\t%s\n", yytext); }
"if"               { printf("KEYWORD: CONDICIONAL-IF\t\t%s\n", yytext); }
"else"             { printf("KEYWORD: CONDICIONAL-ELSE\t\t%s\n", yytext); }
"elif"             { printf("KEYWORD: CONDICIONAL-ELIF\t\t%s\n", yytext); }
"return"           { printf("KEYWORD: RETORNO\t\t\t%s\n", yytext); }
"case"             { printf("KEYWORD: CASO\t\t\t%s\n", yytext); }
"const"            { printf("KEYWORD: CONSTANTE\t\t\t%s\n", yytext); }
"void"             { printf("KEYWORD: TIPO VAZIO\t\t\t%s\n", yytext); }
"array"            { printf("KEYWORD: DECLARACAO ARRAY\t\t%s\n", yytext); }
"break"            { printf("KEYWORD: SAIDA DE FLUXO\t\t\t%s\n", yytext); }
"default"          { printf("KEYWORD: PADRAO\t\t\t\t%s\n", yytext); }

"integer"          { printf("TYPE: INTEIRO\t\t\t\t%s\n", yytext); }
"float"            { printf("TYPE: FLOAT\t\t\t\t%s\n", yytext); }
"char"             { printf("TYPE: CHAR\t\t\t\t%s\n", yytext); }
"string"           { printf("TYPE: STRING\t\t\t%s\n", yytext); }
"bool"             { printf("TYPE: BOOLEANO\t\t\t%s\n", yytext); }
"true"             { printf("LITERAL: BOOLEANO\t\t\t%s\n", yytext); }
"false"            { printf("LITERAL: BOOLEANO\t\t\t%s\n", yytext); }

{IDENTIFICADOR}          { printf("IDENTIFIER:\t\t\t\t%s\n", yytext); }

{NUMERO_DECIMAL}         { printf("LITERAL: NUMERO DECIMAL\t\t%s\n", yytext); }
{NUMERO_INTEIRO}         { printf("LITERAL: NUMERO INTEIRO\t\t%s\n", yytext); }

{OPERADOR_INCREMENTO}    { printf("OPERATOR: INCREMENTO\t\t\t%s\n", yytext); }
{OPERADOR_DECREMENTO}    { printf("OPERATOR: DECREMENTO\t\t\t%s\n", yytext); }
{OPERADOR_ATRIBUICAO_COMPOSTA} { printf("OPERATOR: ATRIBUICAO COMPOSTA\t%s\n", yytext); }
{OPERADOR_LOGICO}        { printf("OPERATOR: LOGICO\t\t\t%s\n", yytext); }
{OPERADOR_ARITMETICO}    { printf("OPERATOR: ARITMETICO\t\t%s\n", yytext); }
{OPERADOR_RELACIONAL}    { printf("OPERATOR: RELACIONAL\t\t%s\n", yytext); }
{OPERADOR_ATRIBUICAO}    { printf("OPERATOR: ATRIBUICAO\t\t%s\n", yytext); }
{OPERADOR_PONTEIRO}  { printf("OPERATOR: PONTEIRO\t\t\t%s\n", yytext); }

{SIMBOLO_PONTEIRO} { printf("TYPE: PONTEIRO\t\t%s\n", yytext); }
{SIMBOLO_ENDERECO}         { printf("OPERATOR: ENDERECO\t\t\t%s\n", yytext); }


{DELIMITADOR}            { printf("DELIMITER:\t\t\t\t%s\n", yytext); }

{STRING}                 {
    char *string_sem_aspas = remover_aspas(yytext);
    if (string_sem_aspas) {
        printf("LITERAL: STRING\t\t\t%s\n", string_sem_aspas);
        free(string_sem_aspas);
    }
}
{CARACTERE_UNITARIO}     {
    char *char_sem_apostrofo = remover_aspas(yytext);
    if (char_sem_apostrofo) {
        printf("LITERAL: CARACTERE\t\t\t%s\n", char_sem_apostrofo);
        free(char_sem_apostrofo);
    }
}

{IGNORA}                 { }

\n                       { linha++; }

.                        { printf("ERROR: Caractere não reconhecido '%s' na linha %d\n", yytext, linha); }

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