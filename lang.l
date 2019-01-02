%{
    #include "y.tab.h"
    
    void yyerror(char *s);
    int yylex();
%}

%%
":" { return method_return; }
"{" { return block_open; }
"}" { return block_close; }
"namespace" { return namespace_def; }
"class" { return class_def; }
"if" { return if_key; }
"else" { return else_key; }
"return" { return return_key; }
"yield" { return yield_key; }
"out" { return out_key; }
"let" { return let_key; }
"exit" { return exit_key; }
"throw" { return throw_key; }
string|int|double|dynamic|void { return primitive; }
public|protected|private { return access_mod; }
\[[a-zA-Z_]+\] { return method_exten; }
\&[a-zA-Z]+[a-zA-Z0-9_] { return attribute_def; }
\@[a-zA-Z]+[a-zA-Z0-9_] { return method_def; }
\([a-zA-Z0-9,\n\t ]*\) { return method_params; }
[a-zA-Z]+[a-zA-Z0-9_]* { yylval.str = strdup(yytext); return name; }
[0-9]+ { yylval.num = atoi(yytext); return number; }
[ \t\n] ;
[-+*/=;>] { return yytext[0]; }
. { yyerror("Unexpected character"); printf("Unexpected was %s", yytext); }
%%

int yywrap(void)
{
    return 1;
}