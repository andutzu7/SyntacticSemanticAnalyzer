#include<string.h>
struct vars{
	int valoare;
	char nume[100];
    char tip[100];
    int lini;
    int coloane;
};

struct vars variabile[100];
int cont=0;
char log[3000]="";

void decl_vect(char x[], char h[], int v)
{	
	strcpy(variabile[cont].nume,x);
	strcpy(variabile[cont].tip,h);
	variabile[cont].lini=v;
	cont++;
}
void decl_matr(char x[], char h[], int v,int w)
{	
	strcpy(variabile[cont].nume,x);
	strcpy(variabile[cont].tip,h);
	variabile[cont].lini=v;
    variabile[cont].coloane=w;
	cont++;
}
void declrvar(char x[],int v, char h[])
{	
	strcpy(variabile[cont].nume,x);
	strcpy(variabile[cont].tip,h);
	variabile[cont].valoare=v;
	cont++;
}
void declr(char x[], char h[])
{
	strcpy(variabile[cont].nume,x);
	strcpy(variabile[cont].tip,h);
	cont++;
}
int exists(char x[])
{
    int i;
    for(i=0;i<=cont;i++)
        if(strcmp(x,variabile[i].nume)==0) return i;
    return -1;
}

void modify(char x[],int v)
{
    int p=exists(x);
    variabile[p].valoare=v;
}
void writelog(int intreg)
{
	char log1[30];
	sprintf(log1,"%d",intreg);
	strcat(log,log1);
	strcat(log,"\n");
}
