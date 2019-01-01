%{
    void yyerror(char *s);
    int yylex();

    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>

    int symbols[52];

    int symbolVal(char symbol);
    void updateSymbolVal(char symbol, int value);
%}

%union { int num; char id; }
%start line
%token out
%token let
%token exit_cmd
%token method_def
%token method_params
%token block_open
%token block_close
%token namespace_def
%token attribute_def
%token name
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%
method : method_def method_params block_open block_close { printf("empty method declaration\n"); }
       | method_def method_params block_open statement block_close { printf("method declaration\n"); }
       | attribute_def method { printf("method attribute\n"); }
       ;

namespace : namespace_def name block_open block_close { printf("empty namespace declaration\n"); }
          | namespace_def name block_open method block_close { printf("namespace declaration\n"); }
          ;

statement : assignment ';' { ; }
          | exit_cmd ';' { exit(EXIT_SUCCESS); }
          | out exp ';' { printf("%d\n", $2); }
          | out term ';' { printf("%d\n", $2); }
          ;

line : namespace { ; }
     | line namespace { ; }
     ;

assignment : let identifier '=' exp { updateSymbolVal($2, $4); }
           ;

exp : term { $$ = $1; }
    | exp '+' term { $$ = $1 + $3; }
    | exp '-' term { $$ = $1 - $3; }
    | exp '*' term { $$ = $1 * $3; }
    | exp '/' term { $$ = $1 / $3; }
    ;

term : number { $$ = $1; }
     | identifier { $$ = symbolVal($1); }
     ;
%%

int computeSymbolIndex(char token)
{
    int index = -1;

    if (islower(token)) {
        index = token - 'a' + 26;
    }
    else if (isupper(token)) {
        index = token - 'A';
    }

    return index;
}

int symbolVal(char symbol)
{
    int bucket = computeSymbolIndex(symbol);

    return symbols[bucket];
}

void updateSymbolVal(char symbol, int value)
{
    int bucket = computeSymbolIndex(symbol);

    symbols[bucket] = value;
}

int main(void) {
    int i;

    for (i = 0; i < 52; i++) {
        symbols[i] = 0;
    }

    return yyparse();
}

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}