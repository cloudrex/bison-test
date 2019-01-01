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
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%
line : assignment ';' { ; }
     | exit_cmd ';' { exit(EXIT_SUCCESS); }
     | out exp ';' { printf("%d\n", $2); }
     | line assignment ';' { ; }
     | line out exp ';' { printf("%d\n", $3); }
     | line exit_cmd ';' { exit(EXIT_SUCCESS); }
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