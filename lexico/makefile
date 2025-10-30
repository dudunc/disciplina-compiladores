all: pj.l
	clear
	flex -i pj.l
	bison pj.y
	gcc pj.tab.c -o pj -lfl
	./pj teste.pj

