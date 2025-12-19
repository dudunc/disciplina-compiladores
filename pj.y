%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef enum { 
    NODE_OP, NODE_VAR, NODE_NUM, NODE_ASSIGN, 
    NODE_IF, NODE_WHILE, NODE_PRINT, NODE_READ, 
    NODE_STR, NODE_ARRAY_ASSIGN, NODE_ARRAY_VAR 
} NodeType;

typedef struct ast_node {
    NodeType type;
    int op;                         
    double val;                     
    int var_idx;                    
    char str[256];                  
    struct ast_node *left, *right, *condition, *else_branch, *next, *index;
} ASTNode;

ASTNode* create_node(NodeType type);
double execute(ASTNode* node);

double variables[26];
double arrays[26][100]; 
extern int linha;
extern FILE *yyin;
int yylex();
void yyerror(const char *s) { fprintf(stderr, "ERRO SINTATICO: %s na linha %d\n", s, linha); }
%}

%union {
    int var_index;
    double real_value;
    char string_value[256];
    struct ast_node* node;
}

%token INICIO FIM LEIA ESCREVA RAIZ IF ELSE WHILE
%token <real_value> NUMERO
%token <var_index> ID
%token <string_value> STRING
%token ATRIB IGUAL MAIOR MENOR

%left MAIOR MENOR IGUAL
%left '+' '-'
%left '*' '/'
%nonassoc IFX
%nonassoc ELSE

%type <node> programa lista_comandos comando EXPRESSAO bloco

%%

programa: INICIO lista_comandos FIM { execute($2); }
        ;

lista_comandos: comando { $$ = $1; }
              | comando lista_comandos { 
                  if ($1 != NULL) { $1->next = $2; $$ = $1; } 
                  else { $$ = $2; } 
                }
              ;

comando: ID ATRIB EXPRESSAO ';' { $$ = create_node(NODE_ASSIGN); $$->var_idx = $1; $$->left = $3; }
       | ID '[' EXPRESSAO ']' ATRIB EXPRESSAO ';' { $$ = create_node(NODE_ARRAY_ASSIGN); $$->var_idx = $1; $$->index = $3; $$->left = $6; }
       | LEIA '(' ID ')' ';' { $$ = create_node(NODE_READ); $$->var_idx = $3; }
       | ESCREVA '(' EXPRESSAO ')' ';' { $$ = create_node(NODE_PRINT); $$->left = $3; }
       | ESCREVA '(' STRING ')' ';' { $$ = create_node(NODE_STR); strcpy($$->str, $3); }
       | IF '(' EXPRESSAO ')' bloco %prec IFX { $$ = create_node(NODE_IF); $$->condition = $3; $$->left = $5; }
       | IF '(' EXPRESSAO ')' bloco ELSE bloco { $$ = create_node(NODE_IF); $$->condition = $3; $$->left = $5; $$->else_branch = $7; }
       | WHILE '(' EXPRESSAO ')' bloco { $$ = create_node(NODE_WHILE); $$->condition = $3; $$->left = $5; }
       | ';' { $$ = NULL; }
       ;

bloco: '{' lista_comandos '}' { $$ = $2; }
     | comando { $$ = $1; }
     ;

EXPRESSAO: EXPRESSAO '+' EXPRESSAO { $$ = create_node(NODE_OP); $$->op = '+'; $$->left = $1; $$->right = $3; }
         | EXPRESSAO '-' EXPRESSAO { $$ = create_node(NODE_OP); $$->op = '-'; $$->left = $1; $$->right = $3; }
         | EXPRESSAO '*' EXPRESSAO { $$ = create_node(NODE_OP); $$->op = '*'; $$->left = $1; $$->right = $3; }
         | EXPRESSAO '/' EXPRESSAO { $$ = create_node(NODE_OP); $$->op = '/'; $$->left = $1; $$->right = $3; }
         | EXPRESSAO IGUAL EXPRESSAO { $$ = create_node(NODE_OP); $$->op = IGUAL; $$->left = $1; $$->right = $3; }
         | EXPRESSAO MAIOR EXPRESSAO { $$ = create_node(NODE_OP); $$->op = MAIOR; $$->left = $1; $$->right = $3; }
         | EXPRESSAO MENOR EXPRESSAO { $$ = create_node(NODE_OP); $$->op = MENOR; $$->left = $1; $$->right = $3; }
         | RAIZ '(' EXPRESSAO ')'    { $$ = create_node(NODE_OP); $$->op = 'R'; $$->left = $3; }
         | NUMERO { $$ = create_node(NODE_NUM); $$->val = $1; }
         | ID     { $$ = create_node(NODE_VAR); $$->var_idx = $1; }
         | ID '[' EXPRESSAO ']' { $$ = create_node(NODE_ARRAY_VAR); $$->var_idx = $1; $$->index = $3; }
         | '(' EXPRESSAO ')' { $$ = $2; }
         ;

%%

ASTNode* create_node(NodeType type) {
    ASTNode* n = (ASTNode*)calloc(1, sizeof(ASTNode));
    n->type = type;
    return n;
}

double execute(ASTNode* n) {
    if (!n) return 0;
    double res = 0;
    switch(n->type) {
        case NODE_NUM: res = n->val; break;
        case NODE_VAR: res = variables[n->var_idx]; break;
        case NODE_ARRAY_VAR: res = arrays[n->var_idx][(int)execute(n->index)]; break;
        case NODE_STR: printf("%s\n", n->str); break;
        case NODE_OP:
            if (n->op == '+') res = execute(n->left) + execute(n->right);
            else if (n->op == '-') res = execute(n->left) - execute(n->right);
            else if (n->op == '*') res = execute(n->left) * execute(n->right);
            else if (n->op == '/') {
                double r = execute(n->right);
                res = (r != 0) ? (execute(n->left) / r) : 0;
            }
            else if (n->op == IGUAL) res = (execute(n->left) == execute(n->right));
            else if (n->op == MAIOR) res = (execute(n->left) > execute(n->right));
            else if (n->op == MENOR) res = (execute(n->left) < execute(n->right));
            else if (n->op == 'R') res = sqrt(execute(n->left));
            break;
        case NODE_ASSIGN: res = variables[n->var_idx] = execute(n->left); break;
        case NODE_ARRAY_ASSIGN: res = arrays[n->var_idx][(int)execute(n->index)] = execute(n->left); break;
        case NODE_PRINT: printf("SAIDA: %.2f\n", execute(n->left)); break;
        case NODE_READ: printf("DIGITE O VALOR PARA %c: ", n->var_idx + 'a'); scanf("%lf", &variables[n->var_idx]); break;
        case NODE_IF: if (execute(n->condition)) execute(n->left); else if (n->else_branch) execute(n->else_branch); break;
        case NODE_WHILE: while (execute(n->condition)) execute(n->left); break;
    }
    if (n->next) execute(n->next);
    return res;
}

int main(int argc, char *argv[]){
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if(!yyin) { perror("Erro ao abrir arquivo"); return 1; }
        yyparse();
        fclose(yyin);
    }
    return 0;
}