%{
#include <stdio.h>
#include "y.tab.h"
#include<string.h>
%}
%option noyywrap
libtip "iostream"|"fstream"|"string"|"math"|"stdlibio"
%%
return {return RETURN;}
">="|"<="|"=="|"!=" {return COMPARATOR_COMPLEX;}
"or"|"and" {return COMPARATOR_BOOL;}
while {return WHILE;}
if {return IF;}
call {return CALL;}
else {return ELSE;}
for {return FOR;}
to {return TO;}
main {return MAIN;}
"public:" {return PUBLIC;}
"private:" {return PRIVATE;}
"protected:" {return PROTECTED;}
include {return INCLUDE;}
" <"{libtip}">" {return LIBTIP;}
"int"|"float"|"char"|"string"|"bool"|"class"|"function" {yylval.tip=strdup(yytext);return TIP;}
maxim {return MAX;}
minim {return MIN;}
modul {return MOD;}
cmmdc {return CMMDC;}
cmmmc {return CMMMC;}
eval {return EVAL;}
[a-zA-Z][a-zA-Z0-9]*  {yylval.nume=strdup(yytext);return ID;}
"-"?[1-9][0-9]* {yylval.val=atoi(yytext);return NR;}
[ \t\f]+ ;
"\r\n"|"\n" {yylineno++;}
. {return yytext[0];}
%%
