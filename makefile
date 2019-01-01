lang: lex.yy.c y.tab.c
	gcc -g lex.yy.c y.tab.c -o lang

lex.yy.c: y.tab.c lang.l
	lex lang.l

y.tab.c: lang.y
	yacc -d lang.y

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h lang lang.dSYM