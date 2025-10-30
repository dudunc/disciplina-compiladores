all: pj
	
pj: pj.l pj.y
	bison -d pj.y
	flex -i pj.l
	gcc pj.tab.c lex.yy.c -o pj -lm -lfl
	./pj teste.pj

clean:
	rm -f pj pj.tab.c pj.tab.h lex.yy.c