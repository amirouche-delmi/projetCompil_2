%{
    #include <string.h>
    int nb_ligne = 1, col = 1;
    
    char sauvIdf[10][10], sauvTypeDec[10], sauvValDec[20];
    int indiceIdf = 0;

    char sauvOpt[5];
    float sauvOpd;

    char sauvTypeMGAff[10], sauvTypeMDAff[10], sauvValConst[20], sauvIdfConst[20];
    
    char sauvStrOutput[20], sauvValOutput[12];

    int fin_if =0, deb_else =0; 
    int qc=0;
    char tmp [20] ;
    char tmpMGAff [20];
    
%}

%union{
    int intVal;
    float floatVal;
    char* strVal;
    char charVal;
}

%token
<strVal> mc_docprogram          <strVal> mc_sub         <strVal> mc_variable    <strVal> mc_as
<strVal> mc_int                 <strVal> mc_flt         <strVal> mc_chr         <strVal> mc_str
<strVal> mc_bol                 <strVal> mc_array       <strVal> mc_constante   <strVal> mc_and
<strVal> mc_or                  <strVal> mc_not         <strVal> mc_sup         <strVal> mc_inf
<strVal> mc_supe                <strVal> mc_infe        <strVal> mc_ega         <strVal> mc_dif
<strVal> mc_aff                 <strVal> mc_input       <strVal> mc_output      <strVal> mc_if
<strVal> mc_then                <strVal> mc_else        <strVal> mc_do          <strVal> mc_while
<strVal> mc_for                 <strVal> mc_until       <strVal> mc_body        <intVal> entier_s
<intVal> entier                 <floatVal> real_s       <floatVal> real         <charVal> caractere
<strVal> string                 <strVal> true           <strVal> false          <strVal> idf
<strVal> slash_sup              <strVal> inf_slash      <strVal> inf            <strVal> pt_exclamation
<strVal> sup                    <strVal> barre_v        <strVal> pt_virgule     <strVal> deux_pt
<strVal> egal                   <strVal> addition       <strVal> soustraction   <strVal> division
<strVal> multiplication         <strVal> parenthese_o   <strVal> parenthese_f   <strVal> virgule
<strVal> crochet_o              <strVal> crochet_f

%type <strVal> BOOLEEN OPD OPT

%start START



%%
START:  inf pt_exclamation mc_docprogram idf sup
                BODY
        inf_slash mc_docprogram sup {
                printf("\n --> Programme syntaxiquement correct \n");
                YYACCEPT;
        }
        | 
        inf pt_exclamation mc_docprogram idf sup 
                BLOC_DEC_VAR 
                BODY 
        inf_slash mc_docprogram sup {
                printf("\n --> Programme syntaxiquement correct \n");
                YYACCEPT;
        }
        | 
        inf pt_exclamation mc_docprogram idf sup 
                BLOC_DEC_CONST 
                BODY 
        inf_slash mc_docprogram sup {
                printf("\n --> Programme syntaxiquement correct \n");
                YYACCEPT;
        } 
        | 
        inf pt_exclamation mc_docprogram idf sup
                BLOC_DEC_VAR_CONST
                BODY 
        inf_slash mc_docprogram sup {
                printf("\n --> Programme syntaxiquement correct \n");
                YYACCEPT;
        }       
;
BLOC_DEC_VAR_CONST: BLOC_DEC_VAR BLOC_DEC_CONST
                  | BLOC_DEC_CONST BLOC_DEC_VAR
;

BLOC_DEC_VAR:   inf mc_sub mc_variable sup 
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        BLOC_DEC_TAB
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                inf_slash mc_sub mc_variable sup   
                |
                inf mc_sub mc_variable sup
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup 
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup 
                |
                inf mc_sub mc_variable sup
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                inf_slash mc_sub mc_variable sup
                |
                inf mc_sub mc_variable sup
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                        BLOC_DEC_TAB
                        DEC_VAR_SIMPLE
                inf_slash mc_sub mc_variable sup
;
DEC_VAR_SIMPLE: inf idf mc_as TYPE slash_sup pt_virgule {   
                        if (declaration($2) == 0)
                            insererType($2, sauvTypeDec, 0);
                        else 
                            printf("\n --> Erreur semantique : double declaration la ligne %d a la col %d !\n", nb_ligne, col);
                }
                | 
                inf idf LISTE_IDF_VAR mc_as TYPE slash_sup pt_virgule {   
                        if (declaration($2) == 0)
                            insererType($2, sauvTypeDec, 0);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                        int i = 0;
                        for (i = 0; i < indiceIdf; i++) {
                            insererType(sauvIdf[i], sauvTypeDec, 0);
                            strcpy(sauvIdf[i], "");
                        }
                        indiceIdf = 0;
                }
                | 
                DEC_VAR_SIMPLE inf idf mc_as TYPE slash_sup pt_virgule {   
                        if (declaration($3) == 0)
                            insererType($3, sauvTypeDec, 0);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                DEC_VAR_SIMPLE inf idf LISTE_IDF_VAR mc_as TYPE slash_sup pt_virgule {   
                        if (declaration($3) == 0)
                            insererType($3, sauvTypeDec, 0);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                        int i = 0;
                        for (i = 0; i < indiceIdf; i++) {
                            insererType(sauvIdf[i], sauvTypeDec, 0);
                            strcpy(sauvIdf[i], "");
                        }
                        indiceIdf = 0;
                }
;
LISTE_IDF_VAR:  barre_v idf {   
                        if (declaration($2) == 0) {
                            strcpy(sauvIdf[indiceIdf], $2);
                            indiceIdf++;
                        } else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                LISTE_IDF_VAR barre_v idf {   
                        if (declaration($3) == 0) {
                            strcpy(sauvIdf[indiceIdf], $3);
                            indiceIdf++;
                        } else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
;
BLOC_DEC_TAB:   inf mc_array mc_as TYPE sup
                inf_slash mc_array sup
                |
                inf mc_array mc_as TYPE sup
                        LISTE_DEC_TAB
                inf_slash mc_array sup
                |
                BLOC_DEC_TAB 
                inf mc_array mc_as TYPE sup
                inf_slash mc_array sup
                |
                BLOC_DEC_TAB 
                inf mc_array mc_as TYPE sup
                        LISTE_DEC_TAB
                inf_slash mc_array sup
;
LISTE_DEC_TAB:  inf idf deux_pt entier slash_sup {
                        if (declaration($2) == 0)
                            if ($4 == 0)     
                                printf("\n --> Erreur semantique : la taille d'un tableau ne peut pas etre 0 a la ligne %d la col %d !\n", nb_ligne, col);
                            else {
                                insererType($2, sauvTypeDec, 0);
                                insererTaille($2, $4);
                            }
                        else   
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);  
                }
                |
                inf idf deux_pt parenthese_o entier_s parenthese_f slash_sup {
                        if (declaration($2) == 0)
                            if ($5 <= 0)     
                                printf("\n --> Erreur semantique : la taille d'un tableau ne peut pas etre <= 0 a la ligne %d la col %d !\n", nb_ligne, col);
                            else {
                                insererType($2, sauvTypeDec, 0);
                                insererTaille($2, $5); 
                            }
                        else   
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);  
                }
                | 
                LISTE_DEC_TAB inf idf deux_pt entier slash_sup {
                        if (declaration($3) == 0)
                            if ($5 <= 0)     
                                printf("\n --> Erreur semantique : la taille d'un tableau ne peut pas etre <= 0 a la ligne %d la col %d !\n", nb_ligne, col);
                            else {
                                    insererType($3, sauvTypeDec, 0);
                                    insererTaille($3, $5); 
                            }
                        else   
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);  
                }
                | 
                LISTE_DEC_TAB inf idf deux_pt parenthese_o entier_s parenthese_f slash_sup {
                        if (declaration($3) == 0)
                            if ($6 <= 0)     
                                printf("\n --> Erreur semantique : la taille d'un tableau ne peut pas etre <= 0 a la ligne %d la col %d !\n", nb_ligne, col);
                            else {
                                insererType($3, sauvTypeDec, 0);
                                insererTaille($3, $6); 
                            }
                        else   
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);  
                }
;
BLOC_DEC_CONST: inf mc_sub mc_constante sup 
                inf_slash mc_sub mc_constante sup
                |
                inf mc_sub mc_constante sup
                        LISTE_DEC_CONST
                inf_slash mc_sub mc_constante sup                
;
LISTE_DEC_CONST: inf idf egal VALEURE slash_sup pt_virgule {   
                        if (declaration($2) == 0) {
                            insererType($2, sauvTypeDec, 1);                                    
                            insererValConst($2, sauvValDec);
                        } else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                inf idf mc_as TYPE slash_sup pt_virgule {   
                        if (declaration($2) == 0)
                            insererType($2, sauvTypeDec, 1);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                inf idf LISTE_IDF_CONST mc_as TYPE slash_sup pt_virgule {  
                        if (declaration($2) == 0)
                            insererType($2, sauvTypeDec, 1);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                        int i = 0;
                        for (i = 0; i < indiceIdf; i++) {
                            insererType(sauvIdf[i], sauvTypeDec, 1);
                            strcpy(sauvIdf[i], "");
                        }
                        indiceIdf = 0;
                }
                | 
                LISTE_DEC_CONST inf idf egal VALEURE slash_sup pt_virgule {   
                        if (declaration($3) == 0) {
                            insererType($3, sauvTypeDec, 1);                                    
                            insererValConst($3, sauvValDec);
                        } else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                LISTE_DEC_CONST inf idf mc_as TYPE slash_sup pt_virgule {   
                        if (declaration($3) == 0)
                            insererType($3, sauvTypeDec, 1);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                LISTE_DEC_CONST inf idf LISTE_IDF_CONST mc_as TYPE slash_sup pt_virgule { 
                        if (declaration($3) == 0)
                            insererType($3, sauvTypeDec, 1);
                        else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                        int i = 0;
                        for (i = 0; i < indiceIdf; i++) {
                            insererType(sauvIdf[i], sauvTypeDec, 1);
                            strcpy(sauvIdf[i], "");
                        }
                        indiceIdf = 0;
                }
;
LISTE_IDF_CONST: barre_v idf {   
                        if (declaration($2) == 0) {
                            strcpy(sauvIdf[indiceIdf], $2);
                            indiceIdf++;
                        } else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
                | 
                LISTE_IDF_CONST barre_v idf {   
                        if (declaration($3) == 0) {
                            strcpy(sauvIdf[indiceIdf], $3);
                            indiceIdf++;
                        } else 
                            printf("\n --> Erreur semantique : double declaration a la ligne %d la col %d !\n", nb_ligne, col);
                }
;
VALEURE:  entier                                {strcpy(sauvTypeDec, "INT"); sprintf(sauvValDec, "%d", $1);}
        | parenthese_o entier_s parenthese_f    {strcpy(sauvTypeDec, "INT"); sprintf(sauvValDec, "%d", $2);}
        | real                                  {strcpy(sauvTypeDec, "FLT"); sprintf(sauvValDec, "%f", $1);}
        | parenthese_o real_s parenthese_f      {strcpy(sauvTypeDec, "FLT"); sprintf(sauvValDec, "%f", $2);}
        | true                                  {strcpy(sauvTypeDec, "BOL"); strcpy(sauvValDec, $1);}
        | false                                 {strcpy(sauvTypeDec, "BOL"); strcpy(sauvValDec, $1);}
        | caractere                             {strcpy(sauvTypeDec, "CHR"); char s[4]; s[0] = '\''; s[1] = $1; s[2] = '\''; s[3] = '\0'; strcpy(sauvValDec, s);}
        | string                                {strcpy(sauvTypeDec, "STR"); strcpy(sauvValDec, $1);}
;
TYPE: mc_int {strcpy(sauvTypeDec, $1);}
    | mc_flt {strcpy(sauvTypeDec, $1);}
    | mc_chr {strcpy(sauvTypeDec, $1);}
    | mc_str {strcpy(sauvTypeDec, $1);}
    | mc_bol {strcpy(sauvTypeDec, $1);}
;

/* -------------------------------------- BODY -------------------------------------- */

BODY:   inf mc_body sup 
        inf_slash mc_body sup
        | 
        inf mc_body sup 
                LISTE_INST 
        inf_slash mc_body sup
;
LISTE_INST: INST | LISTE_INST INST
;
INST: AFFECTATION 
    | INPUT 
    | OUTPUT 
    | CONDITION_IF
    | BOUCLE_DO_WHILE
    | BOUCLE_FOR 
;
AFFECTATION: inf mc_aff deux_pt M_G_AFF virgule M_D_AFF slash_sup {
                if (strcmp(sauvTypeMGAff, sauvTypeMDAff) != 0)
                    printf("\n --> Erreur semantique : incompatibilite des types a la ligne %d la col %d !\n", nb_ligne, col); 
                else
                    if(strcmp(sauvIdfConst, "") != 0)
                        insererValConst(sauvIdfConst, sauvValConst);
                strcpy(sauvTypeMGAff, "");
                strcpy(sauvTypeMDAff, "");
                strcpy(sauvIdfConst, "");

                quadr("=",tmp,"vide",tmpMGAff);
        }                 
;
M_G_AFF: idf {   
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else
                    if (estConst($1) == 1)
                        if (aVal($1) == 1)
                            printf("\n --> Erreur semantique : on peut pas changer la valeur d'une consatante a la ligne %d la col %d !\n", nb_ligne, col);
                        else 
                            strcpy(sauvIdfConst, $1);
                switch (type($1)) {
                    case 'I' : strcpy(sauvTypeMGAff, "INT"); break;
                    case 'F' : strcpy(sauvTypeMGAff, "FLT"); break;
                    case 'C' : strcpy(sauvTypeMGAff, "CHR"); break;
                    case 'S' : strcpy(sauvTypeMGAff, "STR"); break;
                    case 'B' : strcpy(sauvTypeMGAff, "BOL"); break;
                }

                sprintf(tmpMGAff,"%s",$1);

        }
        |
        idf crochet_o entier crochet_f {
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if (tailleTab($1) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if ($3 >= tailleTab($1))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else {
                    sauvValConst [0]='\0';
                    printf("%s",sauvValConst);
                    strcat(sauvValConst, $1);
                    strcat(sauvValConst, $2);
                    char s[5];
                    sprintf(s, "%d", $3);
                    strcat(sauvValConst, s);
                    strcat(sauvValConst, $4); 
                    sprintf(tmpMGAff,"%s",sauvValConst);   
                }  
                switch (type($1)) {
                    case 'I' : strcpy(sauvTypeMGAff, "INT"); break;
                    case 'F' : strcpy(sauvTypeMGAff, "FLT"); break;
                    case 'C' : strcpy(sauvTypeMGAff, "CHR"); break;
                    case 'S' : strcpy(sauvTypeMGAff, "STR"); break;
                    case 'B' : strcpy(sauvTypeMGAff, "BOL"); break;
                }
        }
        | 
        idf crochet_o parenthese_o entier_s parenthese_f crochet_f { 
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if (tailleTab($1) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if ($4 >= tailleTab($1))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $1, nb_ligne, col);
                else if ($4 < 0)
                    printf("\n --> Erreur semantique : on peut pas avoir un indice < 0 a la ligne %d la col %d !\n", nb_ligne, col);                   
                else {
                    sauvValConst [0]='\0';
                    printf("%s",sauvValConst);
                    strcat(sauvValConst, $1);
                    strcat(sauvValConst, $2);
                    char s[5];
                    sprintf(s, "%d", $4);
                    strcat(sauvValConst, s);
                    strcat(sauvValConst, $6); 
                    sprintf(tmpMGAff,"%s",sauvValConst);   
                }               
                switch (type($1)) {
                    case 'I' : strcpy(sauvTypeMGAff, "INT"); break;
                    case 'F' : strcpy(sauvTypeMGAff, "FLT"); break;
                    case 'C' : strcpy(sauvTypeMGAff, "CHR"); break;
                    case 'S' : strcpy(sauvTypeMGAff, "STR"); break;
                    case 'B' : strcpy(sauvTypeMGAff, "BOL"); break;
                }
        }
; 
M_D_AFF: caractere { 
                char s[4]; s[0] = '\''; s[1] = $1; s[2] = '\''; s[3] = '\0';
                strcpy(sauvValConst, s);
                strcpy(sauvTypeMDAff, "CHR");
                sprintf(tmp,"%c",$1);
        }
        | string {
                strcpy(sauvValConst, $1);
                strcpy(sauvTypeMDAff, "STR");
                sprintf(tmp,"%s",$1);
        }
        | BOOLEEN
        | EXPRESSION     
;
BOOLEEN: true {
                strcpy(sauvValConst, $1);
                strcpy(sauvTypeMDAff, "BOL");
                sprintf(tmp,"%s",$1);
        }
        | false {
                strcpy(sauvValConst, $1);
                strcpy(sauvTypeMDAff, "BOL");
                sprintf(tmp,"%s",$1);
        }
;
EXPRESSION: EXP_ARITH | EXP_LOGIQUE | EXP_COMPARAISON
;
EXP_ARITH: OPD A
         | OPD A OPT EXP_ARITH {
            // char* src1= strdup($<strVal>1); 
            // quad("+",src1,$<strVal>3,$<strVal>$);
            // printf("%s",$<strVal>3 );
            
         }
         | EXP_ARITH_PAR 
;
EXP_ARITH_PAR: parenthese_o EXP_ARITH parenthese_f
             | parenthese_o EXP_ARITH parenthese_f OPT EXP_ARITH
;
A:  {   
        if(strcmp(sauvOpt, "/") == 0 && sauvOpd == 0) 
            printf("\n --> Erreur semantique : division sur 0 a la ligne %d la col %d !\n", nb_ligne, col);
        strcpy(sauvOpt, "");
        sauvOpd = 1;
    }
;
OPD: entier {
                sauvOpd = $1;
                sprintf(sauvValConst, "%d", $1);
                strcpy(sauvTypeMDAff, "INT");
                sprintf(tmp,"%d",$1);
        }
        | parenthese_o entier_s parenthese_f {
                sauvOpd = $2;
                sprintf(sauvValConst, "%d", $2);
                strcpy(sauvTypeMDAff, "INT");
                sprintf(tmp,"%s",sauvValConst); 
        }
        | real {
                sauvOpd = $1;
                sprintf(sauvValConst, "%f", $1);
                strcpy(sauvTypeMDAff, "FLT");
                sprintf(tmp,"%f",$1);
        } 
        | parenthese_o real_s parenthese_f {
                sauvOpd = $2;
                sprintf(sauvValConst, "%f", $2);
                strcpy(sauvTypeMDAff, "FLT");
                sprintf(tmp,"%s",sauvValConst); 
        }
        | idf {
                if(declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else
                    strcpy(sauvValConst, $1);                
                switch (type($1)) {
                    case 'I' : strcpy(sauvTypeMDAff, "INT"); break;
                    case 'F' : strcpy(sauvTypeMDAff, "FLT"); break;
                    case 'C' : strcpy(sauvTypeMDAff, "CHR"); break;
                    case 'S' : strcpy(sauvTypeMDAff, "STR"); break;
                    case 'B' : strcpy(sauvTypeMDAff, "BOL"); break;
                } 
                sprintf(tmp,"%s",$1);       
        }
        | 
        idf crochet_o entier crochet_f {
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if (tailleTab($1) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if ($3 >= tailleTab($1))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $1, nb_ligne, col);
                else {
                    sauvValConst [0]='\0';
                    printf("%s",sauvValConst);
                    strcat(sauvValConst, $1);
                    strcat(sauvValConst, $2);
                    char s[5];
                    sprintf(s, "%d", $3);
                    strcat(sauvValConst, s);
                    strcat(sauvValConst, $4); 
                    sprintf(tmp,"%s",sauvValConst);   
                }   
                switch (type($1)) {
                    case 'I' : strcpy(sauvTypeMDAff, "INT"); break;
                    case 'F' : strcpy(sauvTypeMDAff, "FLT"); break;
                    case 'C' : strcpy(sauvTypeMDAff, "CHR"); break;
                    case 'S' : strcpy(sauvTypeMDAff, "STR"); break;
                    case 'B' : strcpy(sauvTypeMDAff, "BOL"); break;
                }
                          
        }
        | 
        idf crochet_o parenthese_o entier_s parenthese_f crochet_f {
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if (tailleTab($1) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if ($4 >= tailleTab($1))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $1, nb_ligne, col);
                else if ($4 < 0)
                    printf("\n --> Erreur semantique : on peut pas avoir un indice < 0 a la ligne %d la col %d !\n", nb_ligne, col);
                else {
                    sauvValConst [0]='\0';                    
                    strcat(sauvValConst, $1);
                    strcat(sauvValConst, $2);
                    char s[5];
                    sprintf(s, "%d", $4);
                    strcat(sauvValConst, s);   
                    strcat(sauvValConst, $6);  
                    sprintf(tmp,"%s",sauvValConst);   
                }                    
                switch (type($1)) {
                    case 'I' : strcpy(sauvTypeMDAff, "INT"); break;
                    case 'F' : strcpy(sauvTypeMDAff, "FLT"); break;
                    case 'C' : strcpy(sauvTypeMDAff, "CHR"); break;
                    case 'S' : strcpy(sauvTypeMDAff, "STR"); break;
                    case 'B' : strcpy(sauvTypeMDAff, "BOL"); break;
                }
        }
;
OPT: addition       {strcpy(sauvOpt, $1);}
   | soustraction   {strcpy(sauvOpt, $1);} 
   | multiplication {strcpy(sauvOpt, $1);} 
   | division       {strcpy(sauvOpt, $1);}
;
EXP_LOGIQUE: mc_and parenthese_o EXP LISTE_EXP parenthese_f {
               // quadr("AND",$3 ,"vide", "vide");
            }
           | mc_or parenthese_o EXP LISTE_EXP parenthese_f {
            //    quadr("OR", "","vide", tmp);
           }
           | mc_not parenthese_o EXP parenthese_f {
            //    quadr("NOT", "","vide", "vide");
           }
;
EXP: BOOLEEN  
    | caractere 
    | string 
    | EXPRESSION
;
LISTE_EXP: virgule EXP
         | virgule EXP LISTE_EXP
;
EXP_COMPARAISON: MC_COMP parenthese_o M_D_AFF virgule M_D_AFF parenthese_f 
;
MC_COMP: mc_sup | mc_inf | mc_supe | mc_infe | mc_ega | mc_dif
;
INPUT: inf mc_input deux_pt idf string slash_sup {
                if (declaration($4) == 0)
                    printf("\n --> Erreur semantique : %s non declarer a la ligne %d la col %d !\n", $4, nb_ligne, col);
                else {
                    char chain[50], sgf;
                    strcpy(chain, $5);
                    int i, j = 0;
                    for (i = 0 ; i < strlen(chain) ; i++) {
                        if (chain[i] == '$' || chain[i] == '%' || chain[i] == '#' || chain[i] == '&' || chain[i] == '@') {
                            j++; 
                            sgf = chain[i];
                        }
                        if (j > 1) {
                            printf("\n --> Erreur semantique : plus d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                            break;
                        }                        
                    }
                    if (j == 1)
                        switch (sgf) {
                            case '$': 
                                if (type($4) != 'I')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '%':
                                if (type($4) != 'F')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '#':
                                if (type($4) != 'S')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '&':
                                if (type($4) != 'C')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '@':
                                if (type($4) != 'B')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                        }
                    else if (j == 0)
                        printf("\n --> Erreur semantique : monque d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                }
        }
        | 
        inf mc_input deux_pt idf crochet_o entier crochet_f string slash_sup {
                if (declaration($4) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $4, nb_ligne, col); 
                else if (tailleTab($4) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $4, nb_ligne, col); 
                else if ($6 >= tailleTab($4))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $4, nb_ligne, col);
                else {
                    char chain[50], sgf;
                    strcpy(chain, $8);
                    int i, j = 0;
                    for (i = 0 ; i < strlen(chain) ; i++) {
                        if (chain[i] == '$' || chain[i] == '%' || chain[i] == '#' || chain[i] == '&' || chain[i] == '@') {
                            j++; 
                            sgf = chain[i];
                        }
                        if (j > 1) {
                            printf("\n --> Erreur semantique : plus d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                            break;
                        }                        
                    }
                    if (j == 1)
                        switch (sgf) {
                            case '$':   
                                if (type($4) != 'I')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '%':   
                                if (type($4) != 'F')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '#': 
                                if (type($4) != 'S')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '&': 
                                if (type($4) != 'C')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '@': 
                                if (type($4) != 'B')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                        }
                    else if (j == 0)
                        printf("\n --> Erreur semantique : monque d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                }
        }
        | 
        inf mc_input deux_pt idf crochet_o parenthese_o entier_s parenthese_f crochet_f string slash_sup {
                if (declaration($4) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $4, nb_ligne, col); 
                else if (tailleTab($4) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $4, nb_ligne, col); 
                else if ($7 >= tailleTab($4))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $4, nb_ligne, col);
                else if ($7 < 0)
                    printf("\n --> Erreur semantique : on peut pas avoir un indice < 0 a la ligne %d la col %d !\n", nb_ligne, col);
                else {
                    char chain[50], sgf;
                    strcpy(chain, $10);
                    int i, j = 0;
                    for (i = 0 ; i < strlen(chain) ; i++) {
                        if (chain[i] == '$' || chain[i] == '%' || chain[i] == '#' || chain[i] == '&' || chain[i] == '@') {
                            j++; 
                            sgf = chain[i];
                        }
                        if (j > 1) {
                            printf("\n --> Erreur semantique : plus d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                            break;
                        }                        
                    }
                    if (j == 1)
                        switch (sgf) {
                            case '$':   
                                if (type($4) != 'I')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '%':   
                                if (type($4) != 'F')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '#': 
                                if (type($4) != 'S')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '&': 
                                if (type($4) != 'C')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                            case '@': 
                                if (type($4) != 'B')
                                    printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                                break;
                        }
                    else if (j == 0)
                        printf("\n --> Erreur semantique : monque d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                }
        }
;
OUTPUT: inf mc_output deux_pt string  {strcpy(sauvStrOutput, $4);} LISTE_OUTPUT slash_sup
;
LISTE_OUTPUT: addition ELE_OUTPUT B
            | addition ELE_OUTPUT B addition string {strcpy(sauvStrOutput, $5);} LISTE_OUTPUT
            | {
                char chain[50];
                strcpy(chain, sauvStrOutput);
                int i;
                for (i = 0 ; i < strlen(chain) ; i++)
                    if (chain[i] == '$' || chain[i] == '%' || chain[i] == '#' || chain[i] == '&' || chain[i] == '@') {
                        printf("\n --> Erreur semantique : il ne doit pas y avoir un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                        break;
                    }
                strcpy(sauvStrOutput, "");                     
        }
;
B:  {
        char chain[50], sgf;
        strcpy(chain, sauvStrOutput);
        int i, j = 0;
        for (i = 0 ; i < strlen(chain) ; i++) {
            if (chain[i] == '$' || chain[i] == '%' || chain[i] == '#' || chain[i] == '&' || chain[i] == '@') {
                j++; 
                sgf = chain[i];
            }
            if (j > 1) {
                printf("\n --> Erreur semantique : plus d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
                break;
            }
        }                        
        if (j == 1)
            switch (sgf) {
                case '$':   
                    if (type(sauvValOutput) != 'I')
                        printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                    break;
                case '%':   
                    if (type(sauvValOutput) != 'F')
                        printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                    break;
                case '#': 
                    if (type(sauvValOutput) != 'S')
                        printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                    break;
                case '&': 
                    if (type(sauvValOutput) != 'C')
                        printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                    break;
                case '@': 
                    if (type(sauvValOutput) != 'B')
                        printf("\n --> Erreur semantique : signe de formatage incompatible a la ligne %d la col %d !\n", nb_ligne, col);
                    break;
            }
        else
            printf("\n --> Erreur semantique : monque d'un signe de formatage a la ligne %d la col %d !\n", nb_ligne, col);
        strcpy(sauvStrOutput, "");
        strcpy(sauvValOutput, "");
    }
;
ELE_OUTPUT: idf {   
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else 
                    strcpy(sauvValOutput, $1);
        }
        |
        idf crochet_o entier crochet_f {
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if (tailleTab($1) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if ($3 >= tailleTab($1))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $1, nb_ligne, col);
                else 
                    strcpy(sauvValOutput, $1);
        }
        | 
        idf crochet_o parenthese_o entier_s parenthese_f crochet_f {
                if (declaration($1) == 0)
                    printf("\n --> Erreur semantique : %s non declare a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if (tailleTab($1) == 0) 
                    printf("\n --> Erreur semantique : %s n'est pas un tableau a la ligne %d la col %d !\n", $1, nb_ligne, col); 
                else if ($4 >= tailleTab($1))
                    printf("\n --> Erreur semantique : depassement de la taille du tableau %s a la ligne %d la col %d !\n", $1, nb_ligne, col);
                else if ($4 < 0)
                    printf("\n --> Erreur semantique : on peut pas avoir un indice < 0 a la ligne %d la col %d !\n", nb_ligne, col);
                else
                    strcpy(sauvValOutput, $1);
        }
;
CONDITION_IF:   inf mc_if deux_pt CONDITION sup
                        inf mc_then sup
                        inf_slash mc_then sup
                inf_slash mc_if sup 
                |
                inf mc_if deux_pt CONDITION sup
                        inf mc_then sup
                                LISTE_INST
                        inf_slash mc_then sup
                inf_slash mc_if sup
                |
                inf mc_if deux_pt CONDITION sup
                        inf mc_then sup
                        inf_slash mc_then sup
                        inf mc_else sup
                        inf_slash mc_else sup
                inf_slash mc_if sup
                |                 
                inf mc_if deux_pt CONDITION sup
                        inf mc_then sup                               
                        inf_slash mc_then sup
                        inf mc_else sup
                                LISTE_INST
                        inf_slash mc_else sup
                inf_slash mc_if sup
                |     
                inf mc_if deux_pt CONDITION sup
                        inf mc_then sup
                                LISTE_INST
                        inf_slash mc_then sup
                        inf mc_else sup
                        inf_slash mc_else sup
                inf_slash mc_if sup
                |             
                inf mc_if deux_pt CONDITION sup
                        inf mc_then sup
                                LISTE_INST
                        inf_slash mc_then sup
                        inf mc_else sup
                                LISTE_INST
                        inf_slash mc_else sup
                inf_slash mc_if sup
;
CONDITION: BOOLEEN | EXP_COMPARAISON | EXP_LOGIQUE
;

BOUCLE_DO_WHILE: inf mc_do sup                        
                inf mc_while deux_pt CONDITION slash_sup
                inf_slash mc_do sup
                |
                inf mc_do sup
                        LISTE_INST
                inf mc_while deux_pt CONDITION slash_sup
                inf_slash mc_do sup
;

BOUCLE_FOR:     inf mc_for idf egal entier mc_until entier sup
                inf_slash mc_for sup
                |
                inf mc_for idf egal entier mc_until entier sup
                        LISTE_INST
                inf_slash mc_for sup
;

%%
main()
{
    yyparse();
    afficher();
    afficher_qdr();
}
yywrap() {}
yyerror(char* msg)
{
    printf("\n --> Erreur syntaxique a la ligne %d a la col %d !\n", nb_ligne, col);
}
