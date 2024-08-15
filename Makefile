CC = gcc
CFLAGS += -Wall -Wextra -pedantic
BISONFLAGS += --color=auto -d --header=y.tab.h -o y.tab.c 

ibpc: lex.yy.c y.tab.c
	$(CC) $(CFLAGS) lex.yy.c y.tab.c -o ibpc

lex.yy.c: ibpc.l
	lex ibpc.l

y.tab.c: ibpc.y
	bison $(BISONFLAGS) ibpc.y
