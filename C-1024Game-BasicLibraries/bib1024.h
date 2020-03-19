typedef struct BLOCO_STRUCT {
        int cor;
        int valor;
        int pontoinicial;
        int pontofinal;
        int dobra;

} BLOCO;

typedef struct str_jogador
{
    char nome[40];
    int pontos;
    char ganhou[5];
}   JOGADOR;


int detecta();
void gerador(BLOCO x[][7],int a);
int vtecla(int a);
void pintador(int x,int y ,int va,int cor);
void blocomestre(BLOCO x[][7],int tecla,int a);
void definevalor(BLOCO x[][7]);
void andador(int tecla,BLOCO x[][7],int a);
void printaosquadrados(BLOCO x[][7],int a);
void dobrageral(BLOCO x[][7],int a,int tecla);
void atualizacor(BLOCO x[][7],int a);
void andaquemdobro(BLOCO x[][7],int a,int tecla);
void NOVOROUND(BLOCO x[][7], int a);
int ELFIMDEJUEGOCHICO(BLOCO x[][7],int a);
int taigual(BLOCO x[][7],BLOCO y[][7],int a);
void igualador(BLOCO x[][7],BLOCO y[][7],int a);
void terminajogo(BLOCO x[][7],int a,int p[]);
int JOGO(int p[],int a);
char getKey();
void imprime_premenu();
void printseta();
void inserejogador(JOGADOR *p, char dest [30]);
void printrank(char dest[30]);
int contalinhas(char dest[30]);
void imprime_centrado(char str[30],int linha);
int pegaTecla_menu();
int interface_do_menu();
int menu_Personalizado();
int menu_Rank();
void apagatela();
