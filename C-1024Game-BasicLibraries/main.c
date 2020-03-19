#include "bib1024.h"


/*direita = 77 esquerda = 75 baixo = 80 cima = 72 esc = 27 enter = 13 tamanho 80/25    teclado adicional 224*/

void main(){
int a;
int p[2];

    system ("MODE con cols=56 lines=26");

    a=interface_do_menu();

    apagatela();

    a=JOGO(p,a);


    gotoxy(10,20);

    printf("PONTUACAO: %d", p[0]);
    Sleep(4000);
}

