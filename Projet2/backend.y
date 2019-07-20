%{
#include <iostream>
#include <cstdio>
#include <string>
#include <map>

using namespace std;

int yylex();
int yyerror(const char *);
void dumpChaines();
void dumpRoutines();

int labId = 1000;

map<string,int> tabchn;

extern char yyline[256];
%}

%union {
  char  chaine[1000];
  int   lbl;
  char  var[33];
  int entier;
}

%token ERREUR OUT OUTLN SET JMP JZ JNZ OP DEF IN

%token <chaine> CHAINE
%token <var> VARIABLE
%token <entier> ENTIER LABEL

%type <lbl> chaine variable

%locations

%%

suite : instr suite
      | instr
      ;

instr : out '\n'
      | set '\n'
      | def '\n'
      | in '\n'
      | label '\n'
      | jmp '\n'
      | operation '\n'
      | '\n'
      ;

out : OUT ',' chaine     { cout << endl << "\t\\ " << yyline << endl;
	                   cout << "\t\\ appel à la routine d'affichage de la première chaîne" << endl;
	                   cout << "\tLDA  L" << $3 << "(R0),R5 \\ adresse du premier caractère dans R5" << endl;
	                   cout << "\tLDA  L4(R0),R2            \\ adresse de la routine dans R2" << endl;
	                   cout << "\tBAL  R2,R3                \\ appel avec adresse de de retour dans R3" << endl;
	                 }
    | OUTLN ',' chaine   { cout << endl << "\t\\ " << yyline << endl;
	                   cout << "\t\\ appel à la routine d'affichage de la première chaîne" << endl;
	                   cout << "\tLDA  L" << $3 << "(R0),R5 \\ adresse du premier caractère dans R5" << endl;
	                   cout << "\tLDA  L4(R0),R2            \\ adresse de la routine dans R2" << endl;
	                   cout << "\tBAL  R2,R3                \\ appel avec adresse de de retour dans R3" << endl;
	                   cout << "\tLDA 10(R0),R15            \\ retour de chariot dans R15" << endl;
	                   cout << "\tTRAP                      \\ affiche le retour de chariot" << endl;
	                 }
    | OUT ',' variable   { cout << endl << "\t\\ " << yyline << endl;
	                   cout << "\t\\ appel à la routine d'affichage de la première chaîne" << endl;
	                   cout << "\tLDI  L" << $3 << "(R0),R5 \\ adresse du premier caractère dans R5" << endl;
	                   cout << "\tLDA  L10(R0),R2            \\ adresse de la routine dans R2" << endl;
	                   cout << "\tBAL  R2,R3                \\ appel avec adresse de de retour dans R3" << endl;
	                 }
    | OUTLN ',' variable { cout << endl << "\t\\ " << yyline << endl;
                           cout << "\t\\ appel à la routine d'affichage de la première chaîne" << endl;
                           cout << "\tLDI  L" << $3 << "(R0),R5 \\ adresse du premier caractère dans R5" << endl;
                           cout << "\tLDA  L10(R0),R2            \\ adresse de la routine dans R2" << endl;
                           cout << "\tBAL  R2,R3                \\ appel avec adresse de de retour dans R3" << endl;
                           cout << "\tLDA 10(R0),R15            \\ retour de chariot dans R15" << endl;
                           cout << "\tTRAP                      \\ affiche le retour de chariot" << endl;
                         }
    | OUT ',' ENTIER     { cout << endl << "\t\\ " << yyline << endl;
	                   cout << "\t\\ appel à la routine d'affichage de la première chaîne" << endl;
	                   cout << "\tLDA  " << $3 << "(R0),R5  \\ adresse du premier caractère dans R5" << endl;
	                   cout << "\tLDA  L10(R0),R2            \\ adresse de la routine dans R2" << endl;
	                   cout << "\tBAL  R2,R3                \\ appel avec adresse de de retour dans R3" << endl;
	                 }
    ;

in  : IN ',' variable    { cout << endl << "\t\\ " << yyline << endl;
                           cout << "\tLDA  L14(R0),R2            \\ adresse de la routine dans R2" << endl;
                           cout << "\tBAL  R2,R3                 \\ appel avec adresse de de retour dans R3" << endl;
                           cout << "\tSTI  R5,L" << $3 << "(R0)  \\ sauvegarde la valeur de R5 dans la variable" << endl;
                           cout << "\tPOP  R5" << endl;
                         }
    ;

jmp : JMP ',' LABEL               { cout << endl << "\t\\ " << yyline << endl;
                                    cout << "\tBRA L" << $3 << "(R0)        \\ branche a l'adresse donnee" << endl;
                                  }
    | JZ ',' variable ',' LABEL   { cout << endl << "\t\\ " << yyline << endl;
                                    cout << "\tLDI L" << $3 << "(R0),R5     \\ entier dans R5" << endl;
                                    cout << "\tBZE L" << $5 << "(R0)        \\ branche si zflag est active" << endl;
                                  }
    | JNZ ',' variable ',' LABEL  { cout << endl << "\t\\ " << yyline << endl;
                                    cout << "\tLDI L" << $3 << "(R0),R5     \\ entier dans R5" << endl;
                                    cout << "\tBNZ L" << $5 << "(R0)        \\ branche si zflag n'est pas active" << endl;
                                  }
    ;

operation : OP ',' '+' ',' variable ',' variable ',' variable { cout << endl << "\t\\ " << yyline << endl;
                                                                cout << "\tLDI L" << $9 << "(R0),R5 \\ entier dans R5" << endl;
                                                                cout << "\tLDI L" << $7 << "(R0),R6 \\ entier dans R6" << endl;
                                                                cout << "\tADD R6,R5 \\ R6 + R5" << endl;
                                                                cout << "\tSTI R5,L" << $5 << "(R0)" << endl;
                                                              }
          | OP ',' '-' ',' variable ',' variable ',' variable { cout << endl << "\t\\ " << yyline << endl;
                                                                cout << "\tLDI L" << $9 << "(R0),R5 \\ entier dans R5" << endl;
                                                                cout << "\tLDI L" << $7 << "(R0),R6 \\ entier dans R6" << endl;
                                                                cout << "\tSUB R6,R5 \\ R6 - R5" << endl;
                                                                cout << "\tSTI R5,L" << $5 << "(R0)" << endl;
                                                              }
          | OP ',' '*' ',' variable ',' variable ',' variable { cout << endl << "\t\\ " << yyline << endl;
                                                                cout << "\tLDI L" << $9 << "(R0),R5 \\ entier dans R5" << endl;
                                                                cout << "\tLDI L" << $7 << "(R0),R6 \\ entier dans R6" << endl;
                                                                cout << "\tMUL R6,R5 \\ R6 * R5" << endl;
                                                                cout << "\tSTI R5,L" << $5 << "(R0)" << endl;
                                                              }
          | OP ',' '/' ',' variable ',' variable ',' variable { cout << endl << "\t\\ " << yyline << endl;
                                                                cout << "\tLDI L" << $9 << "(R0),R5 \\ entier dans R5" << endl;
                                                                cout << "\tLDI L" << $7 << "(R0),R6 \\ entier dans R6" << endl;
                                                                cout << "\tDIV R6,R5 \\ R6 / R5" << endl;
                                                                cout << "\tSTI R5,L" << $5 << "(R0)" << endl;
                                                              }
      ;

label : LABEL ':' { cout << endl << "\t\\ " << yyline << endl;
		    cout << "L" << $1 << ":" << endl;
                  }
      ;

set : SET ',' variable ',' ENTIER  { cout << endl << "\t\\ " << yyline << endl;
                                     cout << "\tLDA  " << $5 << "(R0),R5   \\ entier dans R5" << endl;
                                     cout << "\tSTI  R5,L" << $3 << "(R0)  \\ stocker l'entier" << endl;
                                   }
    | SET ',' variable ',' variable{ cout << endl << "\t\\ " << yyline << endl;
                                     cout << "\tLDI  L" << $5 << "(R0),R5   \\ valeur stockee rentre dans R5" << endl;
                                     cout << "\tSTI  R5,L" << $3 << "(R0)   \\ stocker l'entier" << endl;
                                   }
    ;

def : DEF ',' variable { cout << endl << "\t\\ " << yyline << endl; }
    ;

chaine : CHAINE        { if (tabchn.find($1) == tabchn.end())
                           tabchn[$1] = labId--;
                         $$ = tabchn[$1];                          
                       }
       ;

variable : VARIABLE    { if (tabchn.find($1) == tabchn.end())
                           tabchn[$1] = labId--;
                         $$ = tabchn[$1];                          
                       }
       ;

%%

int main() {
  cout << "\t\\ initialise la pile" << endl;
  cout << "\tLDA  L0(R0),R1            \\ R1 initialisé le bas de la pile" << endl << endl;

  yyparse();

  cout << endl << "\t\\ fin du programme" << endl;
  cout << "\tHALT" << endl;

  dumpChaines();
  dumpRoutines();

  cout << endl;
  cout << "\\***********************************************************" << endl;
  cout << "\\ Haut de la pile" << endl;
  cout << "\\***********************************************************" << endl;
  cout << "L0:" << endl;
}

void dumpChaines() {
  for(map<string,int>::iterator it = tabchn.begin(); it != tabchn.end(); it++) {
    string chaine = it->first;
    int    labl = it->second;

    cout << "L" << labl << ":\t\t\\" << chaine << endl;
    if (chaine[0] == '"') {
      for (int i = 1; i < chaine.length()-1; i++) {
        char c = chaine[i];
        cout << "\tDB " << (int)c << endl;
      }
      cout << "\tDB 0" << endl;
    }
    else {
      for (int i = 0; i < 4; i++) {
        cout << "\tDB 0" << endl;
      }
    }
  }
}

void dumpRoutines() {
  cout << "\t\\***********************************************************" << endl;
  cout << "\t\\* ROUTINE: affichage d'une chaine de caractères" << endl;
  cout << "\t\\*" << endl;
  cout << "\t\\*     Paramètres:" << endl;
  cout << "\t\\*        R1  - registre de pile" << endl;
  cout << "\t\\*        R3  - adresse de retour" << endl;
  cout << "\t\\*        R5  - adresse du premier caractère à afficher" << endl;
  cout << "\t\\***********************************************************" << endl;
  cout << "L4:" << endl;
  cout << "\t\\ empile les registres utilisés par la routine" << endl;
  cout << "\tPSH  0(R5)" << endl;
  cout << "\tPSH  0(R15)" << endl;
  cout << endl;
  cout << "L5:" << endl;
  cout << "\tLDI  0(R5),R15            \\ prochain caractère dans octet de" << endl;
  cout << "\t                          \\ droite de R15" << endl;
  cout << "\tAND  0x000000FF(R0),R15   \\ ne garder que le premier caractère" << endl;
  cout << "\t                          \\ à afficher dans R15" << endl;
  cout << endl;
  cout << "\tBZE  L6(R0)               \\ fin si caractere nul" << endl;
  cout << "\tTRAP                      \\ affiche le caractère" << endl;
  cout << "\tLDA  1(R5),R5             \\ adresse du prochain caractere dans R5" << endl;
  cout << "\tBRA  L5(R0)               \\ itérations suivantes" << endl;
  cout << endl;
  cout << "L6:" << endl;
  cout << "\t\\ restaurer les registres modifiés" << endl;
  cout << "\tPOP  R15" << endl;
  cout << "\tPOP  R5" << endl;
  cout << endl;
  cout << "\tBRA  0(R3)                \\ retour de l'appel" << endl;
  cout << endl;
  cout << "\t\\***********************************************************" << endl;
  cout << "\t\\* ROUTINE: affichage d'un entier" << endl;
  cout << "\t\\*" << endl;
  cout << "\t\\*     Paramètres:" << endl;
  cout << "\t\\*        R1    registre de pile" << endl;
  cout << "\t\\*        R3    adresse de retour" << endl;
  cout << "\t\\*        R5    entier à afficher" << endl;
  cout << "\t\\***********************************************************" << endl;
  cout << "L10:" << endl;
  cout << "\t\\ empile les registres utilisés par la routine" << endl;
  cout << "\tPSH  0(R5)" << endl;
  cout << "\tPSH  0(R15)" << endl;
  cout << "\tPSH  0(R8)" << endl;
  cout << "\tPSH  0(R9)" << endl;
  cout << "\tPSH  0(R4)" << endl;
  cout << endl;
  cout << "\t\\##############################################" << endl;
  cout << "\t\\######## INSÉRER CODE D'AFFICHAGE ICI ########" << endl;
  cout << "\t\\##############################################" << endl;
  cout << "\t\\inverse la valeur d'entre" << endl;
  cout << "L13:" << endl;
  cout << "\tLDA 10(R0),R8              \\ R8 = 10" << endl;
  cout << "\tDIV R5,R8                  \\ R8 = R5 / R8 (R8 = 3026)" << endl;
  cout << endl;
  cout << "\tLDA 10(R0),R9              \\ R9 = 10" << endl;
  cout << "\tMUL R9,R8                  \\ R8 = R8 * 10  (R8 = 30260)" << endl;
  cout << endl;
  cout << "\tSUB R5,R8                  \\ R8 = dernier digit de R5 (R8 = 7)" << endl;
  cout << endl;
  cout << "\tMUL R9,R4                  \\ R4 = R4 * 10 (R4 = 0)" << endl;
  cout << "\tADD R8,R4                  \\ R4 = R4 + R8 (R4 = 7)" << endl;
  cout << endl;
  cout << "\\ On se debarasse du dernier digit de R5" << endl;
  cout << "\tLDA 10(R0),R8              \\ R8 = 10" << endl;
  cout << "\tDIV R5,R8                  \\ R8 = R5 / 10 (R8 = 3026)" << endl;
  cout << "\tLDR R8,R5                  \\ R5 = R8 (R5 = 3026)" << endl;
  cout << endl;
  cout << "\\ Prochaine iteration" << endl;
  cout << "\tBNZ L13(R0)" << endl;
  cout << endl;
  cout << "L11:" << endl;
  cout << "\tLDA 10(R0),R8              \\ R8 = 10" << endl;
  cout << "\tDIV R4,R8                  \\ R8 = R4 / R8 (R8 = 3026)" << endl;
  cout << endl;
  cout << "\tLDA 10(R0),R9              \\ R9 = 10" << endl;
  cout << "\tMUL R9,R8                  \\ R8 = R8 * 10  (R8 = 30260)" << endl;
  cout << endl;
  cout << "\tSUB R4,R8                  \\ R8 = dernier digit de R4 (R8 = 7)" << endl;
  cout << endl;
  cout << "\tLDA 48(R0),R9              \\ R9 = 10" << endl;
  cout << "\tADD R9,R8                  \\ R8 = code ASCII du digit (R8 = 55)" << endl;
  cout << endl;
  cout << "\tLDR R8,R15                 \\ R15 = R8 (R15 = 55)" << endl;
  cout << endl;
  cout << "\tTRAP                       \\ print R15" << endl;
  cout << endl;
  cout << "\t\\ On se debarasse du dernier digit de R5" << endl;
  cout << "\tLDA 10(R0),R8              \\ R8 = 10" << endl;
  cout << "\tDIV R4,R8                  \\ R8 = R4 / 10 (R8 = 3026)" << endl;
  cout << "\tLDR R8,R4                  \\ R5 = R8 (R4 = 3026)" << endl;
  cout << endl;
  cout << "\t\\ Prochaine iteration" << endl;
  cout << "\tBNZ L11(R0)" << endl;
  cout << endl;
  cout << "\t\\ restaurer les registres modifiés" << endl;
  cout << "\tPOP  R4" << endl;
  cout << "\tPOP  R9" << endl;
  cout << "\tPOP  R8" << endl;
  cout << "\tPOP  R15" << endl;
  cout << "\tPOP  R5" << endl;
  cout << endl;
  cout << "\tBRA  0(R3)                \\ retour de l'appel" << endl;
  cout << endl;
  cout << "\t\\ lire une entier du console et le met dans la registre R5" << endl;
  cout << "L14:" << endl;
  cout << "\tPSH 0(R5)	\\ conteneur de la valeur d'entre" << endl;
  cout << "\tPSH 0(R15)	\\ registre de trap" << endl;
  cout << "\tPSH 0(R14)  \\ registre temporaire de la valeur de 14" << endl;
  cout << "\tPSH 0(R9)	\\ valeur temp 1" << endl;
  cout << "\tPSH 0(R8)	\\ valeur temp 2" << endl;
  cout << endl;
  cout << "\tLDA 0(R0),R5" << endl;
  cout << "L15:" << endl;
  cout << "\tLDA 0x80000000(R0),R15      \\ met le bit la plus significatif a 1 dans R15" << endl;
  cout << "\tTRAP                        \\ demande au console une caractere" << endl;
  cout << "\tTRAP                        \\ Affiche a l'ecran la valeur de R15" << endl;
  cout << endl;
  cout << "\t\\ Arrete de boucler si un retour de chariot a ete entre" << endl;
  cout << "\tLDR R15, R14                \\ Copie R15 dans R14" << endl;
  cout << "\tLDA 10(R0),R9               \\ retour de chariot dans R9" << endl;
  cout << "\tSUB R14,R9                  \\ soustrait R14 par Retour de chariot" << endl;
  cout << "\tBZE L16(R0)                  \\ Branche a L16 si R14 = 0" << endl;
  cout << endl;
  cout << "\t\\ Rentre la valeur entre dans R5" << endl;
  cout << "\tLDA 10(R0),R9               \\ R9 = 10" << endl;
  cout << "\tMUL R9,R5                   \\ Multiplie R5 par 10" << endl;
  cout << "\tLDA 48(R0),R8		\\ R8 = 48" << endl;
  cout << "\tSUB R15,R8		        \\ Soustrait R15 par 48 (Convertit en entier)" << endl;
  cout << "\tADD R8,R5		        \\ Ajoute la valeur de R8 dans R5" << endl;
  cout << endl;
  cout << "\tBRA L15(R0)                 \\ branche a L15" << endl;
  cout << "L16:" << endl;
  cout << endl;
  cout << "\t\\ stack pop" << endl;
  cout << "\tPOP R8" << endl;
  cout << "\tPOP R9" << endl;
  cout << "\tPOP R14" << endl;
  cout << "\tPOP R15" << endl;
  //cout << "\tPOP R5" << endl;
  cout << endl;
  cout << "\tBRA 0(R3)                \\ retour de l'appel" << endl;
 }

int yyerror(const char * s) {
  cerr << "*** ERREUR: " << s << endl;
  return -1;
}


