%{
#include <iostream>
#include <cstdio>
#include <string>
#include <map>

using namespace std;

// Prototypes
int yylex();
int yyerror(const char *);

map<string,float> tabsym;      // table des symboles

extern char yyline[256];       // dernière ligne d'input lue par le lexer
extern int  yylineno;          // compteur de lignes lues par le lexer

int erreurs = 0;               // compteur d'erreurs de syntaxe

int tempID = 0,                // compteur de variables temporaires
    maxID  = 0,                // nombre de variables temporaires
    labID  = 1;                // compteur d'étiquettes
%}

%union {
  int   ival;                  // pour les entiers
  char  vnom[31];              // pour les noms de variable
}

%left '+' '-'
%left '*' '/'

%token SEP ERREUR EXIT PRINT PRINTLN IN
%token SI ALORS SINON FINSI
%token TANTQUE FAIRE FINTANTQUE
%token EQ GTE LTE NEQ
%token DECLARE

%token <ival> ENTIER 
%token <vnom> VAR CHAINE

%type <ival> expr cond

%locations

%%

suite : suite instr
      |
      ;

instr : IN VAR SEP     { cout<< "\tin,_" << $2 << endl;  }
      | DECLARE VAR SEP   { cout<< "\tdef,_" << $2 << endl; }
      | print SEP
      | aff SEP
      | struc_cond SEP
      | struc_rep SEP
      | SEP     
      | EXIT SEP         { cout << "\thalt\n"; }      
      | error SEP        { yyclearin;
                           yyerrok;

                           erreurs++;
                         }
      ;

aff : VAR '=' expr     { cout << "\tset,_" << $1 << ",T" << $3 << endl; 
                         if (tempID > maxID) maxID = tempID;
                         tempID = 0;
                       }
    ;

print : PRINT expr     { cout << "\tout,T" << $2 << endl; 
                         if (tempID > maxID) maxID = tempID;
                         tempID = 0;
                       }
      | PRINT CHAINE   { cout << "\tout," << $2 << endl; }
      | PRINTLN expr     { cout << "\toutln,T" << $2 << endl; 
                         if (tempID > maxID) maxID = tempID;
                         tempID = 0;
                       }
      | PRINTLN CHAINE   { cout << "\toutln," << $2 << endl; }
      ;

expr : expr '+' expr   { cout << "\tbop,+,T" << $1;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         $$ = $1;
                       }   
     | expr '-' expr   { cout << "\tbop,-,T" << $1;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         $$ = $1;
                       }
     | expr '*' expr   { cout << "\tbop,*,T" << $1;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         $$ = $1;
                       }
     | expr '/' expr   { cout << "\tbop,/,T" << $1;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         $$ = $1;
                       }
     | '(' expr ')'    { $$ = $2; }
     | ENTIER          { cout << "\tset,T" << tempID << "," << $1 << endl; 
                         $$ = tempID++;
                       }
     | VAR             { cout << "\tset,T" << tempID << ",_" << $1 << endl; 
                         $$ = tempID++;
                       }
     ;

struc_cond  : SI cond ALORS suite FINSI     { cout << "L" << $2 << ":\n";        }
            | SI cond ALORS suite           { cout << "\tjmp,L" << $2+1 << endl;
                                              cout << "L" << $2 << ":" << endl;
                                            } 
              SINON suite FINSI             { cout << "L" << $2+1 << ":\n";      }
            ;

struc_rep : TANTQUE                         { cout << "L" << labID + 1 << ":" << endl; }
            cond FAIRE suite FINTANTQUE     { cout << "\tjmp,L" << $3+1 << endl;
                                              cout << "L" << $3 << ":\n";      
                                            }
          ;

cond : expr            { cout << "\tjz,T" << $1 << ",L" << labID << endl; 
			 $$ = labID;
                         labID += 2;
                         tempID = 0;
                       }         
     | '!' expr        { cout << "\tjnz,T" << $2 << ",L" << labID << endl; 
                         $$ = labID;
                         labID += 2;
                         tempID = 0;
                       }
     | expr EQ expr    { cout << "\tbop,-,T" << tempID;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         cout << "\tjnz,T" << tempID << ",L" << labID << endl; 
                         $$ = labID;
                         labID += 2;
                         tempID = 0;
                       }
     | expr NEQ expr   { cout << "\tbop,-,T" << tempID;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         cout << "\tjz,T" << tempID << ",L" << labID << endl; 
                         $$ = labID;
                         labID += 2;
                         tempID = 0;
                       }
     | expr '<' expr   { cout << "\tjz,T" << $3 << ",L" << labID << endl;
                         cout << "\tbop,/,T" << tempID;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         cout << "\tjnz,T" << tempID << ",L" << labID << endl; 
                         $$ = labID;
                         labID += 2;
                         tempID = 0;
                       }
     | expr '>' expr   { cout << "\tjz,T" << $1 << ",L" << labID << endl;
                         cout << "\tbop,/,T" << tempID;
                         cout << ",T" << $3 << ",T" << $1 << endl;
                         cout << "\tjnz,T" << tempID << ",L" << labID << endl; 
                         $$ = labID;
                         labID += 2;
                         tempID = 0;
                       }
     | expr LTE expr   { cout << "\tjnz,T" << $1 << ",L" << labID+3 << endl;
                         cout << "\tjmp,L" << labID+2 << endl;
                         cout << "L" << labID+3 << ":\n";
                         cout << "\tbop,/,T" << tempID;
                         cout << ",T" << $3 << ",T" << $1 << endl;
                         cout << "\tjz,T" << tempID << ",L" << labID << endl;
                         cout << "L" << labID+2 << ":\n";
                         $$ = labID;
                         labID += 4;
                         tempID = 0;
                       }
     | expr GTE expr   { cout << "\tjnz,T" << $3 << ",L" << labID+3 << endl;
                         cout << "\tjmp,L" << labID+2 << endl;
                         cout << "L" << labID+3 << ":\n";
                         cout << "\tbop,/,T" << tempID;
                         cout << ",T" << $1 << ",T" << $3 << endl;
                         cout << "\tjz,T" << tempID << ",L" << labID << endl;
                         cout << "L" << labID+2 << ":\n";
                         $$ = labID;
                         labID += 4;
                         tempID = 0;
                       }
     ;

%%

// Invoque l'analyseur syntaxique.
int main(int argc, char *argv[]) {
  FILE *fin;
  extern FILE *yyin;

  if (argc > 1)
    if (!(fin = fopen(argv[1], "r"))) 
      cerr << "ATTENTION - fichier inaccessible: " << (char *)argv[1] << endl;
    else
      yyin = fin;

  if (yyparse() == 0 && erreurs == 0)
    cerr << "Frontend: compilation réussie." << endl;
  else
    cerr << "Frontend: " << erreurs << " erreur" << (erreurs > 1 ? "s" : "") 
         << " de syntaxe." << endl;
}

// Routine d'affichage des erreurs de syntaxe.
int yyerror(const char * s) {
  cerr << "ERREUR [" << yylineno << "]: " << s << endl;
  cerr << "       "  << yyline << endl;

  int tokstart = yylloc.first_column - 1;
  int toklen   = yylloc.last_column - yylloc.first_column + 1;
  cerr << "       "  << string(tokstart, ' ') << string(toklen, '^') << endl;

  return -1;
}


