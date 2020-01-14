%{
#include <stdio.h>
#include "functii.h"
int erori=0;
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP LIBTIP INCLUDE NR MAX MIN PRINT MOD CMMDC CMMMC EVAL MAIN PUBLIC PRIVATE PROTECTED RETURN COMPARATOR_COMPLEX WHILE IF ELSE FOR TO COMPARATOR_BOOL CALL
%union {int val;char *nume;char *tip;}
%type<tip> TIP
%type<nume> ID
%type<val> NR expresie
%start progr
%left '+' '-'
%left '*' '/'
%%
progr: librarii declaratii clase functie1 main {if(erori==0){printf("%s",log); printf("program corect sintactic\n");}else printf("\nprogram cu %d erori",erori);}
     ;

librarii: INCLUDE LIBTIP
        | librarii INCLUDE LIBTIP
        ;

declaratii : declaratie';'
    	   | declaratii declaratie';'	
     	   ;

declaratie : TIP ID {if(exists($2)==-1)declr($2,$1);else {yyerror();printf("Variabila deja a fost declarata\n");}}
           | TIP ID '=' NR {if(exists($2)==-1)declrvar($2,$4,$1);else {yyerror(); printf("Variabila nu a fost declarata\n");}}
           | TIP ID'['NR']' {if(exists($2)==-1)decl_vect($2,$1,$4);else {yyerror(); printf("Variabila nu a fost declarata\n");}}
           | TIP ID'['NR']''['NR']' {if(exists($2)==-1)decl_matr($2,$1,$4,$7);else {yyerror(); printf("Variabila nu a fost declarata\n");}}
           ;


clase: clasa
     | clase clasa
     ; 

clasa: TIP ID'{'public private protected'}'
     ;

public: PUBLIC'{'continut'}'
      ;

private: PRIVATE'{'continut'}'
       ;

protected: PROTECTED'{'continut'}'
         ;

continut: declaratii'!'
        | functie1
        | continut functie1
        ;

functie1: TIP ID'('')' '{'continut_functi'}' {if(exists($2)==-1)declr($2,$1);else {yyerror();printf("Functia deja a fost declarata\n");}}
        | TIP ID'('declaratii')' '{'continut_functi'}' {if(exists($2)==-1)declr($2,$1);else {yyerror();printf("Functia deja a fost declarata\n");}}
        ;

continut_functi: sequence';'
               | continut_functi sequence';'
               ;

sequence: ID '=' expresie {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");} else modify($1,$3);}
        | ID'['NR']' '=' expresie {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");} else modify($1,$6);}
        | ID'['NR']''['NR']' '=' expresie {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");} else modify($1,$9);}
        | myfor
        | myif
        | mywhile
        | RETURN expresie
        | CALL ID'('')' {if(exists($2)==-1){yyerror();printf("Functia nu a fost declarata\n");}}
        | CALL ID'('declaratii')' {if(exists($2)==-1){yyerror();printf("Functia nu a fost declarata\n");}}
        ;

mywhile: WHILE '(' cond ')''{' continut_functi '}'
	   ;


param : expresie
	  | ID'(' ')'
      | ID'('ids')'
      ;

ids: ID';'
   | ids ID';'
   ;

myif: IF '('cond')''{'continut_functi'}' ELSE '{'continut_functi'}'
	| IF '('cond')''{'continut_functi'}'
	;

cond: if_cond
    | cond COMPARATOR_BOOL if_cond
    ;

if_cond: param'<'param
	         | param'>'param
	         | param COMPARATOR_COMPLEX param
	         | param
             ;

myfor: FOR'('ID TO interval')' '{'continut_functi'}'
	 ;

interval: ID','ID
        | NR','ID
        | ID','NR
        | NR','NR
        ;

main : TIP MAIN'('')' '{' bloc '}' 
     ;
     
bloc :  instructiune ';' 
     | bloc instructiune ';'
     ;

instructiune : ID '=' expresie {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");} else modify($1,$3);}
             | ID'['NR']' '=' expresie {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");} else modify($1,$6);}
             | ID'['NR']''['NR']' '=' expresie {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");} else modify($1,$9);}
             | EVAL'('expresie')' {if(erori==0){writelog($3);}}
             | myfor
             | myif
             | mywhile
             | RETURN expresie
             | CALL ID'('')' {if(exists($2)==-1){yyerror();printf("Functia nu a fost declarata\n");}}
             | CALL ID'('declaratii')' {if(exists($2)==-1){yyerror();printf("Functia nu a fost declarata\n");}}
             ;
         
expresie : expresie '+' expresie {$$=$1+$3;}
		 | expresie '-' expresie {$$=$1-$3;}
		 | expresie '*' expresie {$$=$1*$3;}
	   	 | expresie '/' expresie {$$=$1/$3;}
         | NR {$$=$1;}
         | ID {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");}$$=variabile[exists($1)].valoare;}
         | ID'['NR']' {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");}$$=variabile[exists($1)].valoare;}
         | ID'['NR']''['NR']' {if(exists($1)==-1){yyerror();printf("Variabila nu a fost declarata\n");}$$=variabile[exists($1)].valoare;}
		     ;

%%
int yyerror(char * s){
erori++;
printf("\n!!!  eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
}
