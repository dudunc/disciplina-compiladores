%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<math.h> 

    double variables[26];
    
    extern int linha;
    extern FILE *yyin;

    int yylex(); 
    
    void yyerror (const char *s){
        printf ("ERRO SINTATICO: %s na linha %d\n", s, linha);
    }
%}

%union {
    int var_index;
    double real_value;
    char string_value[256];
}

%token INICIO FIM          
%token LEIA ESCREVA        
%token ATRIB               
%token FUNCAO             
// Tokens com valores de atributo
%token <real_value> NUMERO      
%token <var_index> ID          
%token <string_value> STRING   

%token '+' '-' '*' '/' '(' ')' ';' ','

%token RAIZ


%left '+' '-'
%left '*' '/'

%type <real_value> EXPRESSAO

%%


programa: INICIO lista_comandos FIM { printf("\nAnalise e Execucao Concluida com Sucesso.\n"); }
        ;

lista_comandos: comando 
              | lista_comandos comando
              ;

comando:  
    ID ATRIB EXPRESSAO ';' {
        variables[$1] = $3; // Variável[índice] = resultado da expressão
    }
    
    | LEIA '(' ID ')' ';' {
        printf("ENTRADA: Digite o valor real para %c (Duas casas decimais sugeridas): ", 'a' + $3);
        if (scanf("%lf", &variables[$3]) != 1) {
            fprintf(stderr, "ERRO SEMANTICO: Entrada inválida. Esperado um número real.\n");
            // Limpa o buffer de entrada para evitar loop de erro
            while (getchar() != '\n'); 
        }
    }
    
    | ESCREVA '(' ID ')' ';' {
        printf("SAIDA (%.2f): %.2f\n", variables[$3], variables[$3]); // Imprime com duas casas decimais
    }
    
    | ESCREVA '(' STRING ')' ';' {
        printf("SAIDA (texto): %s\n", $3); // Imprime a string
    }
    
    | ';'
    ;

EXPRESSAO: EXPRESSAO '+' EXPRESSAO     { $$ = $1 + $3; }
         | EXPRESSAO '-' EXPRESSAO     { $$ = $1 - $3; }
         | EXPRESSAO '*' EXPRESSAO     { $$ = $1 * $3; }
         | EXPRESSAO '/' EXPRESSAO     { 
                                            if ($3 == 0.0) {
                                                fprintf(stderr, "ERRO SEMANTICO: Divisão por zero na linha %d.\n", linha);
                                                $$ = 0.0; 
                                            } else {
                                                $$ = $1 / $3;
                                            }
                                       }
         | '(' EXPRESSAO ')'           { $$ = $2; }
         | NUMERO                      { $$ = $1; } 
         | ID                          { $$ = variables[$1]; } 
         | RAIZ '(' EXPRESSAO ')'      { 
                                            if ($3 < 0) {
                                                fprintf(stderr, "ERRO SEMANTICO: Raiz de número negativo na linha %d.\n", linha);
                                                $$ = 0.0;
                                            } else {
                                                $$ = sqrt($3);
                                            }
                                       }
         ;
         
%%

int main(int argc, char *argv[]){
  FILE *arquivo;
  if (argc > 1) {
      arquivo = fopen(argv[1], "r");
      if (!arquivo) {
          printf("Erro ao abrir o arquivo %s\n", argv[1]);
          return 1;
      }
      yyin = arquivo;
      printf("=== Iniciando a Analise do arquivo: %s ===\n", argv[1]);
      
      yyparse();
      
      fclose(arquivo);
  } else {
      printf("Uso: ./executavel <nome_do_arquivo.txt>\n");
      return 1;
  }
  return 0;
}