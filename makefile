all: pj
	
pj: pj.l pj.y
	bison -d pj.y
	flex -i pj.l
	gcc pj.tab.c lex.yy.c -o compilador -lm -lfl
	./compilador teste.pj

clean:
	rm -f compilador pj.tab.c pj.tab.h lex.yy.c