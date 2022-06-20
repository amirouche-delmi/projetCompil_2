// 1-decalration

typedef struct
{
	char nomEntite[100];
	char codeEntite[10];
	char typeEntite[10];
	char val[20];
	int estConst;
	int taille;
} TypeTS;

// initiation d'un tableau qui va contenir les elements de la table de symbole
TypeTS ts[10000];

// un compteur global pour la table de symbole
int cpTabSym = 0;

// 2-definir une fonction recherche
int recherche(char entite[])
{
	int i = 0;
	while (i < cpTabSym)
	{
		if (strcmp(entite, ts[i].nomEntite) == 0)
			return i;
		i++;
	}
	return -1;
}

// 3-definir la fonction inserer
void inserer(char entite[], char code[])
{
	if (recherche(entite) == -1)
	{
		strcpy(ts[cpTabSym].nomEntite, entite);
		strcpy(ts[cpTabSym].codeEntite, code);
		cpTabSym++;
	}
}
// 4-definir la fonction afficher
void afficher()
{
	printf("\n --> /* ------------------------------- Table des Symboles ------------------------------- */\n");
	printf(" _____________________________________________________________________________________________\n");
	printf(" |            nomEntite    	 | codeEntite | typeEntite | estConst |   valeure   | taille |\n");
	printf(" |_______________________________|____________|____________|__________|_____________|________|\n");
	int i = 0;
	while(i < cpTabSym)
	{
		if(ts[i].estConst == 1)
			printf(" |%30s | %10s | %10s | %8s | %11s | %6s |\n", ts[i].nomEntite, ts[i].codeEntite, ts[i].typeEntite, "CONST", ts[i].val, "");
		else 
			if(ts[i].taille > 0)
				printf(" |%30s | %10s | %10s | %8s | %11s | %6d |\n", ts[i].nomEntite, ts[i].codeEntite, ts[i].typeEntite, "", "", ts[i].taille);
			else
				printf(" |%30s | %10s | %10s | %8s | %11s | %6s |\n", ts[i].nomEntite, ts[i].codeEntite, ts[i].typeEntite, "", "", "");
		i++;
	}
	printf(" |_______________________________|____________|____________|__________|_____________|________|\n");
}

// 5-definir une focntion pour inserer le type
void insererType(char entite[], char type[], int cst)
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
		strcpy(ts[pos].typeEntite, type);
	ts[pos].estConst = cst;
}

// 6-definir une focntion pour inserer la taille d'un tableau
void insererTaille(char entite[], int taille)
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
		ts[pos].taille = taille;
}

// 7-definir une focntion pour inserer la valeure d'une constante
void insererValConst(char entite[], char val[])
{
	int pos;
	pos = recherche(entite);
	if (pos != -1)
		strcpy(ts[pos].val, val);
}

// 8-definir une focntion qui detecte la declaration d'une constante ou variable
int declaration(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (strcmp(ts[pos].typeEntite, "") == 0)
		return 0;
	else
		return 1;
}

// 9-definir une focntion qui detecte si une entite est une constante
int estConst(char entite[])
{
	int pos;
	pos = recherche(entite);
	return ts[pos].estConst;
}

// 10-definir une focntion qui detecte si une constante a une valeure ou non
int aVal(char entite[])
{
	int pos;
	pos = recherche(entite);
	if(strcmp(ts[pos].val, "") == 0)
		return 0;
	return 1;
	
}

// 11-definir une focntion qui detecte si une entite est un tableau et son taille
int tailleTab(char entite[])
{
	int pos;
	pos = recherche(entite);	
	return ts[pos].taille;
}

// 12-definir une focntion qui retourne le type d'un idf
char type(char entite[])
{
	int pos;
	pos = recherche(entite);
	if (strcmp(ts[pos].typeEntite, "INT") == 0)
		return 'I';
	else if (strcmp(ts[pos].typeEntite, "FLT") == 0)
		return 'F';
	else if (strcmp(ts[pos].typeEntite, "CHR") == 0)
		return 'C';
	else if (strcmp(ts[pos].typeEntite, "STR") == 0)
		return 'S';
	else if (strcmp(ts[pos].typeEntite, "BOL") == 0)
		return 'B';
}
