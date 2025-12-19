🎓 Compilador PJ: Passamos Juntos
A PJ (Passamos Juntos) é um compilador desenvolvido como projeto final para a disciplina de Compiladores no IFCE - Campus Aracati. O nome é um trocadilho que celebra o início e o quase fim da jornada dos estudantes do S7, onde a maioria que inicou ainda esta presento no curso de Ciência da Computação.
+1

🛠️ Especificações do Projeto
O compilador foi construído utilizando as ferramentas Lex/Flex e Yacc/Bison. A principal característica técnica é a implementação via AST (Árvore de Sintaxe Abstrata), o que permite uma execução estruturada e eficiente de loops e condicionais.
+1

Requisitos Atendidos (Checklist de 10 Pontos)

Nome e Extensão : Linguagem PJ com extensão de arquivo .pj.

Comentários : Suporte a comentários de linha (//) e de bloco (/* */).

Tipos de Variáveis : Suporte para inteiro, float e string.

Operações Aritméticas : Realização de soma, subtração, multiplicação e divisão.

Leitura e Escrita : Operações leia() para entrada de dados e escreva() para saída de texto e variáveis.

Operações Lógicas : Comparações de igualdade, maior e menor.

Estrutura Condicional : Implementação completa de blocos if e else.

Estrutura de Repetição : Laço while para execuções iterativas.

Arrays (Vetores) : Implementação de vetores indexados id[indice].

🏗️ A Árvore de Sintaxe Abstrata (AST)
Diferente de interpretadores simples, a PJ primeiro entende a estrutura do seu código para depois executá-lo.

📝 Problemas Resolvidos (Desafio Final)
Conforme exigido, o compilador resolve dois problemas fundamentais integrados em um menu interativo dentro do arquivo teste.pj:

Fibonacci com Arrays : Calcula a famosa sequência matemática e armazena cada termo em um vetor.
+1

Classificação de Triângulos : Recebe três medidas e utiliza lógica condicional para classificar o triângulo (Equilátero, Isósceles ou Escaleno).

⚙️ Como Compilar e Rodar
No terminal, use o comando para compilar:

Bash

make
Execute o programa com o arquivo de teste:

Bash

./compilador teste.pj

Professor: Diego Rocha Semestre: 2025.1 Curso: Bacharelado em Ciência da Computação