CC = gcc
CFLAGS += -Wall -Wextra -pedantic

ibpc: lex.yy.c y.tab.c
	$(CC) $(CFLAGS) lex.yy.c y.tab.c -o ibpc

lex.yy.c: ibpc.l
	lex ibpc.l

y.tab.c: ibpc.y
	yacc -d ibpc.y
