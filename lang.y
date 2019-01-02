%{
    void yyerror(char *s);
    int yylex();

    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    extern FILE * yyin;

    int symbols[100];
    int range = 100;

    int symbolVal(char* symbol);
    void updateSymbolVal(char* symbol, int value);
%}

%union { int num; char* str; }
%start line
%token method_def
%token method_params
%token method_return
%token method_exten
%token block_open
%token block_close
%token namespace_def
%token attribute_def
%token class_def
%token access_mod
%token name
%token primitive
%token number
%token if_key
%token else_key
%token throw_key
%token out_key
%token let_key
%token exit_key
%token return_key
%token yield_key
%token import_key
%type <num> line exp term number
%type <str> assignment name

%%
import : import_key name ';' { ; }
       ;

class_bare : access_mod class_def name block_open block_close { ; }
           | access_mod class_def name block_open method block_close { ; }
           ;

class : class_bare { printf("class declaration\n"); }
      | attribute_def class_bare { printf("class with attribute declaration\n"); }
      ;

method_bare : access_mod method_def method_params method_return primitive block_open statement_block block_close { printf("method declaration\n"); }
            | access_mod method_exten method_def method_params method_return primitive block_open statement_block block_close { printf("method with extension\n"); }
            ;

method : method_bare { ; }
       | attribute_def method_bare { ; }
       ;

namespace : namespace_def name block_open block_close { printf("empty namespace declaration -> %s\n", $2); }
          | namespace_def name block_open class block_close { printf("namespace declaration\n"); }
          ;

statement_block : %empty
                | statement { ; }
                | statement_block statement { ; }
                ;

statement : assignment ';' { ; }
          | exit_key ';' { exit(EXIT_SUCCESS); }
          | out_key exp ';' { printf("%d\n", $2); }
          | out_key term ';' { printf("%d\n", $2); }
          | throw_key exp ';' { exit(1); }
          | throw_key name ';' { exit(1); }
          ;

line : namespace { ; }
     | line namespace { ; }
     | import { ; }
     ;

assignment : let_key name '=' exp { updateSymbolVal($2, $4); }
           ;

exp : term { $$ = $1; }
    | exp '+' term { $$ = $1 + $3; }
    | exp '-' term { $$ = $1 - $3; }
    | exp '*' term { $$ = $1 * $3; }
    | exp '/' term { $$ = $1 / $3; }
    ;

term : number { $$ = $1; }
     | name { $$ = symbolVal($1); }
     ;
%%

// TODO: Need to handle collisions
int computeIndex(char* input)
{
    int index = 0;
    int i;
    
    for (i = 0; i < strlen(input); i++) {
        index += input[i] - 'a';
    }
    
    return index % range;
}

int symbolVal(char* symbol)
{
    int bucket = computeIndex(symbol);

    return symbols[bucket];
}

void updateSymbolVal(char* symbol, int value)
{
    int bucket = computeIndex(symbol);

    printf("Save new value at index %d\n", bucket);

    symbols[bucket] = value;
}

int main(void) {
    int i;

    for (i = 0; i < 100; i++) {
        symbols[i] = 0;
    }

    // Load & parse input file
    FILE* inputFile = fopen("input.txt", "r");

    if (inputFile == NULL) {
        printf("Input file does not exist");

        return 1;
    }

    yyin = inputFile;

    //yylex();

    return yyparse();
}

void yyerror(char *s)
{
    fprintf(stderr, "%s\n", s);
}