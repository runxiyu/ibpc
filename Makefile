ibpc: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c -o ibpc -ll -ly

lex.yy.c: ibpc.l
	lex ibpc.l

y.tab.c: ibpc.y
	yacc -d ibpc.y
