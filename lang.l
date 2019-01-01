%{
    #include "y.tab.h"
    
    void yyerror(char *s);
    int yylex();
%}

%%
"out" { return out; }
"let" { return let; }
"exit" { return exit_cmd; }
\([a-zA-Z0-9,]*\) { return method_params; }
"{" { return block_open; }
"}" { return block_close; }
"namespace" { return namespace_def; }
\&[a-zA-Z]+ { return attribute_def; }
\@[a-zA-Z]+ { return method_def; }
[a-zA-Z] { yylval.id = yytext[0]; return identifier; }
[a-zA-Z][_a-zA-Z0-9]* { return name; }
[0-9]+ { yylval.num = atoi(yytext); return number; }
[ \t\n] ;
[-+*/=;>] { return yytext[0]; }
. { yyerror("Unexpected character"); }
%%

int yywrap(void)
{
    return 1;
}