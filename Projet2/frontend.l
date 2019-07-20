%{
#include <stdlib.h>
#include <cstring>

#include "frontend.tab.h"

char yyline[256];

int yycolno = 1;

#define YY_USER_ACTION yylloc.first_line   = yylloc.last_line = yylineno; \
                       yylloc.first_column = yycolno;                     \
                       yylloc.last_column  = yycolno+yyleng-1;            \
                       yycolno            += yyleng;
%}

%option yylineno

%%

^.*$                                 { strncpy(yyline,yytext, 255);
                                       yycolno = 1;

                                       if (strlen(yytext) > 0) 
                                         printf("\t// %s\n", yytext);

                                       REJECT;
                                     }

"//"                                 {
                                       int c;
                                       while ((c = yyinput()) != '\n' && c != EOF);
                                       if (c == EOF) unput(c);
                                     }

"/*"                                 {
                                       int c;
                                       do {
                                         c = yyinput();
                                         if (c == EOF) break;
                                         
                                         if (c == '*') {
                                           c = yyinput();
                                           if (c == '/' || c == EOF) break;
                                         }
                                       } while(1);

                                       if (c == EOF) unput(c);
                                     }

[0-9]+                               { yylval.ival = atoi(yytext); 
                                       return ENTIER;
                                     }

halt                                 return EXIT;
print                                return PRINT;
println                              return PRINTLN;
lire                                 return IN;
var                                  return DECLARE;

si                                   return SI;
alors                                return ALORS;
finsi                                return FINSI;
sinon				     return SINON;

tantque				     return TANTQUE;
faire				     return FAIRE;
fintantque			     return FINTANTQUE;

"=="                                 return EQ;
"!="                                 return NEQ;
">="                                 return GTE;                
"<="                                 return LTE;


[_a-zA-Z][_a-zA-Z0-9]*               { strcpy(yylval.vnom, yytext); 
                                       return VAR;
                                     }

\"(\\.|[^\\"])*\"                    { strcpy(yylval.vnom, yytext); 
                                       return CHAINE;
                                     }

;                                    return SEP;

"+"|"-"|"*"|"/"|"("|")"|"="|"!"|">"|"<"      return yytext[0];

" "|\t                               ;
\n                                   yycolno = 1;

.                                    return ERREUR;

%%

