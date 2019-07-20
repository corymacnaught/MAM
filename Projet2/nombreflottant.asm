	\ initialise la pile
	LDA  L0(R0),R1            \ R1 initialisé le bas de la pile


	\ 	def,_n

	\ 	def,_d

	\ 	outln,"Quelle est la numerateur?"
	\ appel à la routine d'affichage de la première chaîne
	LDA  L998(R0),R5 \ adresse du premier caractère dans R5
	LDA  L4(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3
	LDA 10(R0),R15            \ retour de chariot dans R15
	TRAP                      \ affiche le retour de chariot

	\ 	out,"-->"
	\ appel à la routine d'affichage de la première chaîne
	LDA  L997(R0),R5 \ adresse du premier caractère dans R5
	LDA  L4(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3

	\ 	in,_n
	LDA  L14(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                 \ appel avec adresse de de retour dans R3
	STI  R5,L1000(R0)  \ sauvegarde la valeur de R5 dans la variable
	POP  R5

	\ 	outln,"Quelle est la denominateur?"
	\ appel à la routine d'affichage de la première chaîne
	LDA  L996(R0),R5 \ adresse du premier caractère dans R5
	LDA  L4(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3
	LDA 10(R0),R15            \ retour de chariot dans R15
	TRAP                      \ affiche le retour de chariot

	\ 	out,"-->"
	\ appel à la routine d'affichage de la première chaîne
	LDA  L997(R0),R5 \ adresse du premier caractère dans R5
	LDA  L4(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3

	\ 	in,_d
	LDA  L14(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                 \ appel avec adresse de de retour dans R3
	STI  R5,L999(R0)  \ sauvegarde la valeur de R5 dans la variable
	POP  R5

	\ 	def,_r

	\ 	def,_decimales

	\ 	def,_iterations

	\ 	set,T0,1
	LDA  1(R0),R5   \ entier dans R5
	STI  R5,L992(R0)  \ stocker l'entier

	\ 	set,_r,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L995(R0)   \ stocker l'entier

	\ 	set,T0,0
	LDA  0(R0),R5   \ entier dans R5
	STI  R5,L992(R0)  \ stocker l'entier

	\ 	set,_decimale,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L991(R0)   \ stocker l'entier

	\ L2:
L22:

	\ 	set,T0,_r
	LDI  L995(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,0
	LDA  0(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	jz,T0,L1
	LDI L992(R0),R5     \ entier dans R5
	BZE L21(R0)        \ branche si zflag est active

	\ 	bop,/,T2,T1,T0
	LDI L992(R0),R5 \ entier dans R5
	LDI L990(R0),R6 \ entier dans R6
	DIV R6,R5 \ R6 / R5
	STI R5,L989(R0)

	\ 	jnz,T2,L1
	LDI L989(R0),R5     \ entier dans R5
	BNZ L21(R0)        \ branche si zflag n'est pas active

	\ 	set,T0,0
	LDA  0(R0),R5   \ entier dans R5
	STI  R5,L992(R0)  \ stocker l'entier

	\ 	set,_iterations,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L993(R0)   \ stocker l'entier

	\ L4:
L24:

	\ 	set,T0,_n
	LDI  L1000(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,_d
	LDI  L999(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L990(R0)   \ stocker l'entier

	\ 	jnz,T1,L6
	LDI L990(R0),R5     \ entier dans R5
	BNZ L26(R0)        \ branche si zflag n'est pas active

	\ 	jmp,L5
	BRA L25(R0)        \ branche a l'adresse donnee

	\ L6:
L26:

	\ 	bop,/,T2,T0,T1
	LDI L990(R0),R5 \ entier dans R5
	LDI L992(R0),R6 \ entier dans R6
	DIV R6,R5 \ R6 / R5
	STI R5,L989(R0)

	\ 	jz,T2,L3
	LDI L989(R0),R5     \ entier dans R5
	BZE L23(R0)        \ branche si zflag est active

	\ L5:
L25:

	\ 	set,T0,_n
	LDI  L1000(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,_d
	LDI  L999(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L990(R0)   \ stocker l'entier

	\ 	bop,-,T0,T0,T1
	LDI L990(R0),R5 \ entier dans R5
	LDI L992(R0),R6 \ entier dans R6
	SUB R6,R5 \ R6 - R5
	STI R5,L992(R0)

	\ 	set,_n,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L1000(R0)   \ stocker l'entier

	\ 	set,T0,_iterations
	LDI  L993(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,1
	LDA  1(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	bop,+,T0,T0,T1
	LDI L990(R0),R5 \ entier dans R5
	LDI L992(R0),R6 \ entier dans R6
	ADD R6,R5 \ R6 + R5
	STI R5,L992(R0)

	\ 	set,_iterations,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L993(R0)   \ stocker l'entier

	\ 	jmp,L4
	BRA L24(R0)        \ branche a l'adresse donnee

	\ L3:
L23:

	\ 	set,T0,_n
	LDI  L1000(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,_r,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L995(R0)   \ stocker l'entier

	\ 	set,T0,_n
	LDI  L1000(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,10
	LDA  10(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	bop,*,T0,T0,T1
	LDI L990(R0),R5 \ entier dans R5
	LDI L992(R0),R6 \ entier dans R6
	MUL R6,R5 \ R6 * R5
	STI R5,L992(R0)

	\ 	set,_n,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L1000(R0)   \ stocker l'entier

	\ 	set,T0,_iterations
	LDI  L993(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	out,T0
	\ appel à la routine d'affichage de la première chaîne
	LDI  L992(R0),R5 \ adresse du premier caractère dans R5
	LDA  L10(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3

	\ 	set,T0,_decimales
	LDI  L994(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,0
	LDA  0(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	bop,-,T2,T0,T1
	LDI L990(R0),R5 \ entier dans R5
	LDI L992(R0),R6 \ entier dans R6
	SUB R6,R5 \ R6 - R5
	STI R5,L989(R0)

	\ 	jnz,T2,L7
	LDI L989(R0),R5     \ entier dans R5
	BNZ L27(R0)        \ branche si zflag n'est pas active

	\ 	set,T0,_r
	LDI  L995(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,0
	LDA  0(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	jz,T0,L9
	LDI L992(R0),R5     \ entier dans R5
	BZE L29(R0)        \ branche si zflag est active

	\ 	bop,/,T2,T1,T0
	LDI L992(R0),R5 \ entier dans R5
	LDI L990(R0),R6 \ entier dans R6
	DIV R6,R5 \ R6 / R5
	STI R5,L989(R0)

	\ 	jnz,T2,L9
	LDI L989(R0),R5     \ entier dans R5
	BNZ L29(R0)        \ branche si zflag n'est pas active

	\ 	out,","
	\ appel à la routine d'affichage de la première chaîne
	LDA  L988(R0),R5 \ adresse du premier caractère dans R5
	LDA  L4(R0),R2            \ adresse de la routine dans R2
	BAL  R2,R3                \ appel avec adresse de de retour dans R3

	\ L9:
L29:

	\ L7:
L27:

	\ 	set,T0,_decimales
	LDI  L994(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,1
	LDA  1(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	bop,+,T0,T0,T1
	LDI L990(R0),R5 \ entier dans R5
	LDI L992(R0),R6 \ entier dans R6
	ADD R6,R5 \ R6 + R5
	STI R5,L992(R0)

	\ 	set,_decimales,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L994(R0)   \ stocker l'entier

	\ 	set,T0,_decimales
	LDI  L994(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L992(R0)   \ stocker l'entier

	\ 	set,T1,10
	LDA  10(R0),R5   \ entier dans R5
	STI  R5,L990(R0)  \ stocker l'entier

	\ 	jz,T0,L11
	LDI L992(R0),R5     \ entier dans R5
	BZE L31(R0)        \ branche si zflag est active

	\ 	bop,/,T2,T1,T0
	LDI L992(R0),R5 \ entier dans R5
	LDI L990(R0),R6 \ entier dans R6
	DIV R6,R5 \ R6 / R5
	STI R5,L989(R0)

	\ 	jnz,T2,L11
	LDI L989(R0),R5     \ entier dans R5
	BNZ L31(R0)        \ branche si zflag n'est pas active

	\ 	set,T0,0
	LDA  0(R0),R5   \ entier dans R5
	STI  R5,L992(R0)  \ stocker l'entier

	\ 	set,_r,T0
	LDI  L992(R0),R5   \ valeur stockee rentre dans R5
	STI  R5,L995(R0)   \ stocker l'entier

	\ L11:
L31:

	\ 	jmp,L2
	BRA L22(R0)        \ branche a l'adresse donnee

	\ L1:
L21:

	\ fin du programme
	HALT
L988:		\","
	DB 44
	DB 0
L997:		\"-->"
	DB 45
	DB 45
	DB 62
	DB 0
L996:		\"Quelle est la denominateur?"
	DB 81
	DB 117
	DB 101
	DB 108
	DB 108
	DB 101
	DB 32
	DB 101
	DB 115
	DB 116
	DB 32
	DB 108
	DB 97
	DB 32
	DB 100
	DB 101
	DB 110
	DB 111
	DB 109
	DB 105
	DB 110
	DB 97
	DB 116
	DB 101
	DB 117
	DB 114
	DB 63
	DB 0
L998:		\"Quelle est la numerateur?"
	DB 81
	DB 117
	DB 101
	DB 108
	DB 108
	DB 101
	DB 32
	DB 101
	DB 115
	DB 116
	DB 32
	DB 108
	DB 97
	DB 32
	DB 110
	DB 117
	DB 109
	DB 101
	DB 114
	DB 97
	DB 116
	DB 101
	DB 117
	DB 114
	DB 63
	DB 0
L992:		\T0
	DB 0
	DB 0
	DB 0
	DB 0
L990:		\T1
	DB 0
	DB 0
	DB 0
	DB 0
L989:		\T2
	DB 0
	DB 0
	DB 0
	DB 0
L999:		\_d
	DB 0
	DB 0
	DB 0
	DB 0
L991:		\_decimale
	DB 0
	DB 0
	DB 0
	DB 0
L994:		\_decimales
	DB 0
	DB 0
	DB 0
	DB 0
L993:		\_iterations
	DB 0
	DB 0
	DB 0
	DB 0
L1000:		\_n
	DB 0
	DB 0
	DB 0
	DB 0
L995:		\_r
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
