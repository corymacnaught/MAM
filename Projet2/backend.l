%{
#include <stdlib.h>
#include <cstring>

#include "backend.tab.h"

char yyline[256];
%}

%%

^.*$                            { strncpy(yyline,yytext, 255);
                                       REJECT;
                                     }

\".*\"               { strcpy(yylval.chaine, yytext);
                       return CHAINE;
                     }

"//"                 { 
                       int c;
                       while ((c = yyinput()) != '\n' && c != EOF);
                         if (c == EOF) unput(c);
                     }

[0-9]+               { yylval.entier = atoi(yytext);
                       return ENTIER;
                     }

L[0-9]+              { char substr[256];
                       strncpy(substr, yytext+1, strlen(yytext));
                       yylval.entier = atoi(substr) + 20;
                       return LABEL;
                     }

bop                  return OP;

jmp                  return JMP;
jz                   return JZ;
jnz                  return JNZ;

set                  return SET;
def                  return DEF;

out                  return OUT;
outln                return OUTLN;
in                   return IN;

[a-zA-Z_][a-zA-Z0-9_]*   { strcpy(yylval.var, yytext);
                           return VARIABLE;
                         }

","|":"|"+"|"-"|"*"|"/"|"\n"             return yytext[0];

" "|\t               ;

.                    return ERREUR;

%%


