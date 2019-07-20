	\ initialise la pile
	LDA  L0(R0),R1            \ R1 initialisé le bas de la pile


	\ 	set,T0,4
	LDA  4(R0),R5   \ entier dans R5
	STI  R5,L1000(R0)  \ stocker l'entier

	\ 	out,T0
	\ appel à la routine d'affichage de la première chaîne
	LDI  L1000(R0),R5 \ adresse du premier caractère dans R5
	LDA  L10(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3

	\ fin du programme
	HALT
L1000:		\T0
	DB 0
	DB 0
	DB 0
	DB 0
	\***********************************************************
	\* ROUTINE: affichage d'une chaine de caractères
	\*
	\*     Paramètres:
	\*        R1  - registre de pile
	\*        R3  - adresse de retour
	\*        R5  - adresse du premier caractère à afficher
	\***********************************************************
L4:
	\ empile les registres utilisés par la routine
	PSH  0(R5)
	PSH  0(R15)

L5:
	LDI  0(R5),R15            \ prochain caractère dans octet de
	                          \ droite de R15
	AND  0x000000FF(R0),R15   \ ne garder que le premier caractère
	                          \ à afficher dans R15

	BZE  L6(R0)               \ fin si caractere nul
	TRAP                      \ affiche le caractère
	LDA  1(R5),R5             \ adresse du prochain caractere dans R5
	BRA  L5(R0)               \ itérations suivantes

L6:
	\ restaurer les registres modifiés
	POP  R15
	POP  R5

	BRA  0(R3)                \ retour de l'appel

	\***********************************************************
	\* ROUTINE: affichage d'un entier
	\*
	\*     Paramètres:
	\*        R1    registre de pile
	\*        R3    adresse de retour
	\*        R5    entier à afficher
	\***********************************************************
L10:
	\ empile les registres utilisés par la routine
	PSH  0(R5)
	PSH  0(R15)
	PSH  0(R8)
	PSH  0(R9)
	PSH  0(R4)

	\##############################################
	\######## INSÉRER CODE D'AFFICHAGE ICI ########
	\##############################################
	\inverse la valeur d'entre
L13:
	LDA 10(R0),R8              \ R8 = 10
	DIV R5,R8                  \ R8 = R5 / R8 (R8 = 3026)

	LDA 10(R0),R9              \ R9 = 10
	MUL R9,R8                  \ R8 = R8 * 10  (R8 = 30260)

	SUB R5,R8                  \ R8 = dernier digit de R5 (R8 = 7)

	MUL R9,R4                  \ R4 = R4 * 10 (R4 = 0)
	ADD R8,R4                  \ R4 = R4 + R8 (R4 = 7)

\ On se debarasse du dernier digit de R5
	LDA 10(R0),R8              \ R8 = 10
	DIV R5,R8                  \ R8 = R5 / 10 (R8 = 3026)
	LDR R8,R5                  \ R5 = R8 (R5 = 3026)

\ Prochaine iteration
	BNZ L13(R0)

L11:
	LDA 10(R0),R8              \ R8 = 10
	DIV R4,R8                  \ R8 = R4 / R8 (R8 = 3026)

	LDA 10(R0),R9              \ R9 = 10
	MUL R9,R8                  \ R8 = R8 * 10  (R8 = 30260)

	SUB R4,R8                  \ R8 = dernier digit de R4 (R8 = 7)

	LDA 48(R0),R9              \ R9 = 10
	ADD R9,R8                  \ R8 = code ASCII du digit (R8 = 55)

	LDR R8,R15                 \ R15 = R8 (R15 = 55)

	TRAP                       \ print R15

	\ On se debarasse du dernier digit de R5
	LDA 10(R0),R8              \ R8 = 10
	DIV R4,R8                  \ R8 = R4 / 10 (R8 = 3026)
	LDR R8,R4                  \ R5 = R8 (R4 = 3026)

	\ Prochaine iteration
	BNZ L11(R0)

	\ restaurer les registres modifiés
	POP  R4
	POP  R9
	POP  R8
	POP  R15
	POP  R5

	BRA  0(R3)                \ retour de l'appel

	\ lire une entier du console et le met dans la registre R5
L14:
	PSH 0(R5)	\ conteneur de la valeur d'entre
	PSH 0(R15)	\ registre de trap
	PSH 0(R14)  \ registre temporaire de la valeur de 14
	PSH 0(R9)	\ valeur temp 1
	PSH 0(R8)	\ valeur temp 2

	LDA 0(R0),R5
L15:
	LDA 0x80000000(R0),R15      \ met le bit la plus significatif a 1 dans R15
	TRAP                        \ demande au console une caractere
	TRAP                        \ Affiche a l'ecran la valeur de R15

	\ Arrete de boucler si un retour de chariot a ete entre
	LDR R15, R14                \ Copie R15 dans R14
	LDA 10(R0),R9               \ retour de chariot dans R9
	SUB R14,R9                  \ soustrait R14 par Retour de chariot
	BZE L16(R0)                  \ Branche a L16 si R14 = 0

	\ Rentre la valeur entre dans R5
	LDA 10(R0),R9               \ R9 = 10
	MUL R9,R5                   \ Multiplie R5 par 10
	LDA 48(R0),R8		\ R8 = 48
	SUB R15,R8		        \ Soustrait R15 par 48 (Convertit en entier)
	ADD R8,R5		        \ Ajoute la valeur de R8 dans R5

	BRA L15(R0)                 \ branche a L15
L16:

	\ stack pop
	POP R8
	POP R9
	POP R14
	POP R15

	BRA 0(R3)                \ retour de l'appel

\***********************************************************
\ Haut de la pile
\***********************************************************
L0:
