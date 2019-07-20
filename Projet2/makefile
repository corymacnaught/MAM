backend: lex.yy.c backend.tab.c
	g++ -o backend lex.yy.c backend.tab.c -ll

lex.yy.c: backend.l
	flex backend.l

backend.tab.c: backend.y
	bison -d backend.y

clean:
	rm *.c *.h backend

