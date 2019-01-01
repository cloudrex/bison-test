%{
    #include "y.tab.h"
    
    void yyerror(char *s);
    int yylex();
%}

%%
"out" { return out; }
"let" { return let; }
"exit" { return exit_cmd; }
[a-zA-Z] { yylval.id = yytext[0]; return identifier; }
[0-9]+ { yylval.num = atoi(yytext); return number; }
[ \t\n] ;
[-+*/=;] { return yytext[0]; }
. { yyerror("Unexpected character"); }
%%

int yywrap(void)
{
    return 1;
}