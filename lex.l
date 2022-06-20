%{
    #include "syn.tab.h"
    #include "fonctions.h"
    extern nb_ligne, col;
    extern YYSTYPE yylval;
    #include "pgm.h"
%}

idf         [A-Za-z_][A-Za-z0-9_]*
cstInt      [+-]?[0-9]+
cstFlt      [+-]?[0-9]{1,7}\.[0-9]{1,3}
errFlt      [+-]?[0-9]+\.[0-9]+
cstChr      \'.\'
cstStr      \"[^"]*\"
cstBol      TRUE|FALSE
slashSup    \/[ ]*\>
infSlash    \<[ ]*\/
comment     <!--.*-->

%%

docprogram  {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_docprogram;}
SUB         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_sub;}
VARIABLE    {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_variable;}
AS          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_as;}
INT         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_int;}
FLT         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_flt;}
CHR         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_chr;}
STR         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_str;}
BOL         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_bol;}
ARRAY       {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_array;}
CONSTANTE   {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_constante;}
AND         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_and;}
OR          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_or;}
NOT         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_not;}
SUP         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_sup;}
INF         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_inf;}
SUPE        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_supe;}
INFE        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_infe;}
EGA         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_ega;}
DIF         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_dif;}
AFF         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_aff;}
INPUT       {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_input;}
OUTPUT      {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_output;}
IF          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_if;}
THEN        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_then;}
ELSE        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_else;}
DO          {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_do;}
WHILE       {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_while;}
FOR         {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_for;}
UNTIL       {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_until;}
body        {inserer(yytext, "mc"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return mc_body;}

{cstInt}    { 
                if(atoi(yytext) >= -32768 && atoi(yytext) <= 32767)
                {
                    inserer(yytext, "cst");
                    yylval.intVal = atoi(yytext);
                    col = col + strlen(yytext);
                    if(yytext[0] == '+' || yytext[0] == '-')
                       return entier_s;
                    else
                        return entier;                        
                }else
                    printf("Erreur lexical a la ligne %d  la col %d l'entier %s n'appartient pas a l'intervalle [-32768, 32767] \n", nb_ligne, col, yytext);
            }
{cstFlt}    {
                inserer(yytext, "cst");
                yylval.floatVal = atof(yytext);
                col = col + strlen(yytext);
                if(yytext[0] == '+' || yytext[0] == '-')
                    return real_s;
                else 
                    return real;
            }
{errFlt}    {printf("erreur lexical a la ligne %d la col %d le real %s ne respcte pas la forme [1-7.1-3] \n", nb_ligne, col, yytext);}
{cstChr}    {inserer(yytext, "cst"); yylval.charVal = yytext[1]; col = col + strlen(yytext); return caractere;}
{cstStr}    {inserer(yytext, "cst"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return string;}
{cstBol}    {
                inserer(yytext, "cst");
                yylval.strVal = strdup(yytext);
                col = col + strlen(yytext);
                if(strcmp(yytext, "TRUE") == 0)
                    return true;
                else 
                    return false;                   
            }
{idf}       {inserer(yytext, "idf"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return idf;}
{slashSup}  {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return slash_sup;}
{infSlash}  {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return inf_slash;}
{comment}   {col = col + strlen(yytext);}

\<          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return inf;}
\!          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return pt_exclamation;}
\>          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return sup;}
\|          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return barre_v;}
\;          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return pt_virgule;}
\:          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return deux_pt;}
\=          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return egal;}
\+          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return addition;}
\-          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return soustraction;}
\/          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return division;}
\*          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return multiplication;}
\(          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return parenthese_o;}
\)          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return parenthese_f;}
\,          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return virgule;}
\[          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return crochet_o;}
\]          {inserer(yytext, "sep"); yylval.strVal = strdup(yytext); col = col + strlen(yytext); return crochet_f;}

[ \t]       {col = col + strlen(yytext);}
\n          {col =1; nb_ligne++;}
.           {printf("Erreur lexical à la ligne %d à la col %d entite %s \n", nb_ligne, col, yytext);}
