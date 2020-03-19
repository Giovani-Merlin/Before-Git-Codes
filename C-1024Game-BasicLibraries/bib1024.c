#include "bib1024.h"
#include <stdio.h>
#include <conio.h>
#include <conio2.h>
#include <windows.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#define altura 2
#define largura 20
#define qaltura 4
#define qlargura 5
#define DMAX 56
#define HMAX 26
#define TEMPO 150

int pintax[7]={largura,largura+qlargura,largura+2*qlargura,largura+3*qlargura,largura+4*qlargura,largura+5*qlargura,largura+6*qlargura};
//grade da coluna
int pintay[7]={altura,altura+qaltura,altura+2*qaltura,altura+3*qaltura,altura+4*qaltura,altura+5*qaltura,altura+6*qaltura};
//grade da linha


// **************************** FUNÇÕES PADRÕES (ANTIGA MAIN) **************************************************//

int detecta(){
int a;
    a=getch();
    if(a==224){ //se ta no segundo teclado
    a=getch();
    a=vtecla(a);
        return(a);
    }
    if(a==27)
        return(24);

    return(3);
}

void gerador(BLOCO x[][7],int a){

int va,t=0;
int i,j;
srand(time(NULL));
while(t==0){
        i= rand() %(a+1);
        j= rand() % (a+1);
        va=1+ rand() % 2; // valor 1 ou 2

        if(x[i][j].valor==0){
                if(va==1)
                    x[i][j].cor=LIGHTGREEN;
                if(va==2)
                    x[i][j].cor=MAGENTA;

            x[i][j].valor=va;
            pintador(pintax[j],pintay[i],va,x[i][j].cor);
            t=1;
        }

}

}

int vtecla(int a){
    switch(a){
        case 77: return(2);
        case 75: return(-2);
        case 80: return(1);
        case 72: return(-1);
        default: return(3);
    }
    return(a);
}

void pintador(int x,int y ,int va,int cor){ //printa os quadrados
    int i,j;



    textbackground(cor);


    for(i=0;i<qaltura;i++){ //i= linha, j=coluna
        for(j=0;j<qlargura;j++){
            gotoxy(x+j,y+i);
            printf(" ");
         }
         if(cor!=BLACK){ //se nao é um quadrado vazio, printa seu valor
    textcolor(BLACK);
    gotoxy(x+qlargura/2,y+qaltura/2);
        printf("%d",va);
}
        else{   textbackground(LIGHTGRAY);
                for(i=0;i<qaltura;i++){ //i= linha, j=coluna
        for(j=0;j<qlargura;j++){
            gotoxy(x+j,y+i);
            printf(" ");
         }
            textcolor(BLACK); //se é, faz um pontinho
            gotoxy(x+qlargura/2,y+qaltura/2);
            printf(" . ");
        }
}
}}

void blocomestre(BLOCO x[][7],int tecla,int a){ //chama atualizacor e entao andador

int i,j;
int verifica;
int temp;
switch(tecla){



case -2:
     for(i=0;i<=a;i++){   // i=linha

        for(j=0;j<a;j++){      // j = coluna


            if(x[i][j+1].valor!=0){ //se o quadrado não é zero


            if(x[i][j].valor==0 || x[i][j].valor==x[i][j+1].valor){ //se o da frente é zero ou igual valor

            if(x[i][j].valor!=x[i][j+1].valor){ //primeira opcao, vai andar

            for(verifica=j;verifica>=0;verifica--){ //até quanto vai anda
                    if(x[i][verifica].valor!=0){
                   temp=verifica;break; }
            }



            if(verifica==-1){ //se matou o for, vai até o inicio da grade
                    temp=-1;
                    }



                x[i][temp+1].valor=x[i][j+1].valor; //atualiza o valor
                x[i][j+1].valor=0;

                 if(x[i][temp+1].valor==x[i][temp].valor) //se quando terminou de andar dobra
                            if(x[i][temp].dobra==0) //se o prox ja nao vai dobrar
                                x[i][temp+1].dobra=1;

                            x[i][temp+1].pontoinicial=pintax[j+1];
                            x[i][temp+1].pontofinal=pintax[temp+1];




        }}
        else{
                if(x[i][j].dobra==0) //se o prox n vai dobra
                    x[i][j+1].dobra=1;

        }

        }



}} break;

///////////////////////////////////////////////////////
case 2:
        for(i=0;i<=a;i++){   //  i = linha

        for(j=a;j>0;j--){      //  j = coluna


            if(x[i][j-1].valor!=0){ //se o elemento em questao é não-nulo


            if(x[i][j].valor==0 || x[i][j].valor==x[i][j-1].valor){ //se o de trás é nulo ou o mesmo valor

            if(x[i][j].valor!=x[i][j-1].valor){  //se o anterior é nulo, isto é, se vai andar

            for(verifica=j;verifica<=a;verifica++){  //verifica até qual termo pode andar
                    if(x[i][verifica].valor!=0){
                   temp=verifica;break; }
            }



                    if(verifica==a+1){ //se matou o for, isto é, vai até o fim da grade
                    temp=a+1;}


                x[i][temp-1].valor=x[i][j-1].valor; //atualiza o valor
                x[i][j-1].valor=0;

                    if(x[i][temp-1].valor==x[i][temp].valor) //se quando terminou de andar dobra
                            if(x[i][temp].dobra==0)
                                x[i][temp-1].dobra=1; //se o prox ja nao vai dobrar

                            x[i][temp-1].pontoinicial=pintax[j-1];
                            x[i][temp-1].pontofinal=pintax[temp-1];




        }
        else{  if(x[i][j].dobra==0) //se o prox n vai dobrar
                x[i][j-1].dobra=1;


                   }

        }



}}}



break;
/////////////////////////////////////////////////////
case 1:
     for(i=0;i<=a;i++){   // i  = coluna

        for(j=a;j>0;j--){      //  j  = linha


            if(x[j-1][i].valor!=0){ //se o elemento em questao é não-nulo


            if(x[j][i].valor==0 || x[j][i].valor==x[j-1][i].valor){ //se o de cima é nulo ou o mesmo valor

            if(x[j][i].valor!=x[j-1][i].valor){  //se o de cima é nulo, isto é, se vai andar

            for(verifica=j;verifica<=a;verifica++){  //verifica até qual termo pode andar
                    if(x[verifica][i].valor!=0){
                   temp=verifica;break; }
            }



                    if(verifica==a+1){ //se matou o for, isto é, vai até o fim da grade
                    temp=a+1;}


                x[temp-1][i].valor=x[j-1][i].valor; //atualiza o valor
                x[j-1][i].valor=0;

                    if(x[temp-1][i].valor==x[temp][i].valor) //se quando terminou de andar dobra
                            if(x[temp][i].dobra==0)
                                x[temp-1][i].dobra=1; //se o prox ja nao vai dobrar

                            x[temp-1][i].pontoinicial=pintay[j-1];
                            x[temp-1][i].pontofinal=pintay[temp-1];




        }
        else{  if(x[j][i].dobra==0) //se o prox n vai dobrar
                x[j-1][i].dobra=1;


                   }

        }



}}}



break;
////////////////////////////////////////////////////
case -1:

     for(i=0;i<=a;i++){   // i = coluna

        for(j=0;j<a;j++){      // j = linha


            if(x[j+1][i].valor!=0){ //se o que eu to nao é zero


            if(x[j][i].valor==0 || x[j][i].valor==x[j+1][i].valor){ //se o de baixo é zero ou igual valor

            if(x[j][i].valor!=x[j+1][i].valor){ //primeira opcao, vai andar

            for(verifica=j;verifica>=0;verifica--){ //até quanto vai anda
                    if(x[verifica][i].valor!=0){
                   temp=verifica;break; }
            }



            if(verifica==-1){ //se matou o for, vai até o inicio da grade
                    temp=-1;
                    }



                x[temp+1][i].valor=x[j+1][i].valor; //atualiza o valor
                x[j+1][i].valor=0;

                 if(x[temp+1][i].valor==x[temp][i].valor) //se quando terminou de andar dobra
                            if(x[temp][i].dobra==0) //se o prox ja nao vai dobrar
                                x[temp+1][i].dobra=1;

                            x[temp+1][i].pontoinicial=pintay[j+1];
                            x[temp+1][i].pontofinal=pintay[temp+1];




        }
        else{
                if(x[j][i].dobra==0) //se o prox n vai dobra
                    x[j+1][i].dobra=1;

        }

        }



}}} break;

///////////////////////////////////////////////////////
case 0: clrscr();puts("NOOB");
////////////////////////////////////////////////////
}
atualizacor(x,a);
andador(tecla,x,a);


}


void andador(int tecla,BLOCO x[][7],int a){ //chama dobrageral
int l,i,j,k;
    switch(tecla){
    case 1:

        for(k=pintay[0];k<pintay[a];k++){
            Sleep(10);
        for(i=0;i<=a;i++){  // j = linha, i = coluna
            for(j=a;j>=0;j--){ //começa da ultima linha
                if(x[j][i].pontofinal>x[j][i].pontoinicial){ //se vai anda
                    pintador(pintax[i],x[j][i].pontoinicial+1,x[j][i].valor,x[j][i].cor); //printa o valor do ponto final(atualizado) do ponto inicial em diante


                        textbackground(LIGHTGRAY);
                        for(l=0;l<qlargura;l++){ //apaga a andada
                        gotoxy(pintax[i]+l,x[j][i].pontoinicial);
                                    printf(" ");

                            }
            x[j][i].pontoinicial++; //conta que andou uma unidade
            }

        }
        }
        }
         break;
         ////////////////////////////////////////
    case 2:

        for(k=pintax[0];k<pintax[a];k++){
            Sleep(10);
        for(i=0;i<=a;i++){ // j = coluna, i = linha
            for(j=a;j>=0;j--){
                if(x[i][j].pontofinal>x[i][j].pontoinicial){ //se vai anda
                    pintador(x[i][j].pontoinicial+1,pintay[i],x[i][j].valor,x[i][j].cor); //printa o valor do ponto final(atualizado) do ponto inicial em diante


                        textbackground(LIGHTGRAY);
                        for(l=0;l<qaltura;l++){ //apaga a andada
                        gotoxy(x[i][j].pontoinicial,pintay[i]+l);
                                    printf(" ");

                            }
            x[i][j].pontoinicial++; //conta que andou um pouco
            }

        }
        }
        }
         break;
         ////////////////////////////////////////
    case -2:
        for(k=pintax[a];k>pintax[0];k--){
                Sleep(10);
        for(i=0;i<=a;i++){ //i = linha, j = coluna

        for(j=0;j<a;j++){
                 if(x[i][j].pontofinal<x[i][j].pontoinicial){ //se vai anda
                    pintador(x[i][j].pontoinicial-1,pintay[i],x[i][j].valor,x[i][j].cor); //printa o valor do ponto final(atualizado) do ponto inicial em diante


                        textbackground(LIGHTGRAY);
                        for(l=0;l<qaltura;l++){ //apaga a andada
                        gotoxy(x[i][j].pontoinicial+qlargura-1,pintay[i]+l);
                                    printf(" ");

                            }
            x[i][j].pontoinicial--; //conta que andou um pouco
            }


        }}} break;
    ////////////////////////////////////////
    case -1:


        for(k=pintay[a];k>pintay[0];k--){
                Sleep(10);
        for(i=0;i<=a;i++){ // j = linha, i = coluna

        for(j=0;j<a;j++){
                 if(x[j][i].pontofinal<x[j][i].pontoinicial){ //se vai anda
                    pintador(pintax[i],x[j][i].pontoinicial-1,x[j][i].valor,x[j][i].cor); //printa o valor do ponto final(atualizado) do ponto inicial em diante


                        textbackground(LIGHTGRAY);
                        for(l=0;l<qlargura;l++){ //apaga a andada
                        gotoxy(pintax[i]+l,x[j][i].pontoinicial+qaltura-1);
                                    printf(" ");

                            }
            x[j][i].pontoinicial--; //conta que andou um pouco
            }


        }}} break;

    }
dobrageral(x,a,tecla);
}

void definevalor(BLOCO x[][7]){ //só inicializaçao
int i,j;

for(i=0;i<7;i++){
    for(j=0;j<7;j++){
        x[i][j].valor=0;
        x[i][j].cor=BLACK;
        x[i][j].pontoinicial=0;
        x[i][j].pontofinal=0;
        x[i][j].dobra=0;

    }
}



}

void printaosquadrados(BLOCO x[][7],int a){ //autoexplicativo
int i,j;

for(i=0;i<=a;i++){
    for(j=0;j<=a;j++){
       if(x[i][j].valor!=0){

        pintador(pintax[j],pintay[i],x[i][j].valor,x[i][j].cor);
       }
        else{
            pintador(pintax[j],pintay[i],x[i][j].valor,BLACK);
        }
    }

}


}


void dobrageral(BLOCO x[][7],int a,int tecla){ //chama andaquemdobro, atualizacor e printa


int i,j;
    switch(tecla){

   case 1:
        for(i=0;i<=a;i++){
            for(j=a;j>0;j--){

                    if(x[j-1][i].dobra==1){

                            x[j][i].valor=2*x[j-1][i].valor; //se vai dobra, dobra ué
                            x[j-1][i].dobra=0;
                            x[j-1][i].valor=0;

                    }

            }
     }
     break;
     //////////////////////


    case 2:

     for(i=0;i<=a;i++){
            for(j=a;j>0;j--){

                    if(x[i][j-1].dobra==1){

                            x[i][j].valor=2*x[i][j-1].valor; //se vai dobra, dobra ué
                            x[i][j-1].dobra=0;
                            x[i][j-1].valor=0;

                    }

            }
     }
     break;//////////////////////////

    case -2:
        for(i=0;i<=a;i++){

        for(j=0;j<a;j++){

        if(x[i][j+1].dobra==1){

                            x[i][j].valor=2*x[i][j+1].valor; //se vai dobra, dobra ué
                            x[i][j+1].dobra=0;
                            x[i][j+1].valor=0;

                    }

            }




    } break;
    ////////////////////////////////////////
    case -1:

        for(i=0;i<=a;i++){

        for(j=0;j<a;j++){

        if(x[j+1][i].dobra==1){

                            x[j][i].valor=2*x[j+1][i].valor; //se vai dobra, dobra ué
                            x[j+1][i].dobra=0;
                            x[j+1][i].valor=0;

                    }

            }




    } break;
    ////////////////////////////////////////
    }
    andaquemdobro(x,a,tecla);
    atualizacor(x,a);
    printaosquadrados(x,a);



    }


void atualizacor(BLOCO x[][7],int a){ //autoexplicativo


int i,j;
    for(i=0;i<=a;i++){
        for(j=0;j<=a;j++){
            if(x[i][j].valor==1){
                x[i][j].cor=LIGHTGREEN;
            }
            if(x[i][j].valor==2){
                x[i][j].cor=MAGENTA;
            }
            if(x[i][j].valor==4){
                x[i][j].cor=LIGHTBLUE;
            }
            if(x[i][j].valor==8){
                x[i][j].cor=LIGHTCYAN;
            }
            if(x[i][j].valor==16){
                x[i][j].cor=YELLOW;
            }
            if(x[i][j].valor==32){
                x[i][j].cor=LIGHTMAGENTA;
            }
            if(x[i][j].valor==64){
                x[i][j].cor=CYAN;
            }
            if(x[i][j].valor==128){
                x[i][j].cor=DARKGRAY;
            }
            if(x[i][j].valor==256){
                x[i][j].cor=WHITE;
            }
            if(x[i][j].valor==512){
                x[i][j].cor=GREEN;
            }
            if(x[i][j].valor==1024){
                x[i][j].cor=BLUE;
            }
            if(x[i][j].valor==2048){
                x[i][j].cor=RED;
            }
            if(x[i][j].valor==4096){
                x[i][j].cor=BROWN;
            }
            if(x[i][j].valor==8192){
                x[i][j].cor=MAGENTA;
            }
            if(x[i][j].valor==16384){
                x[i][j].cor=LIGHTGREEN;
            }
        }
    }


}

void andaquemdobro(BLOCO x[][7],int a,int tecla){ //autoexplicativo
int i,k,j;

    switch(tecla){

   case 1:

         for(i=0;i<=a;i++){ //coluna
            for(j=a-1;j>=0;j--){ //começa pela penultima linha

        if(x[j][i].valor!=0){ //eu n sou zero

             for(k=j+1;k<=a;k++){//até ond o prox é zero
                if(x[k][i].valor!=0){
                    break;
                }

             }
             if(k!=j+1){
             x[k-1][i].valor=x[j][i].valor;
             x[j][i].valor=0;
             }


                    }
    }


}break;
//////////////////////////////




    case 2:

         for(i=0;i<=a;i++){ //linha
            for(j=a-1;j>=0;j--){ //começa pela penultima coluna

        if(x[i][j].valor!=0){ //eu n sou zero

             for(k=j+1;k<=a;k++){//até ond o prox é zero
                if(x[i][k].valor!=0){
                    break;
                }

             }
             if(k!=j+1){
             x[i][k-1].valor=x[i][j].valor;
             x[i][j].valor=0;
             }


                    }
    }


}break;
//////////////////////////////
    case -2:
        for(i=0;i<=a;i++){ //linha

        for(j=1;j<=a;j++){ //começa pela segunda coluna

            if(x[i][j].valor!=0){ //eu n sou zero

             for(k=j-1;k>=0;k--){//até ond o prox é zero
                if(x[i][k].valor!=0){
                    break;
                }

             }
             if(k!=j-1){
             x[i][k+1].valor=x[i][j].valor;
             x[i][j].valor=0;
             }


                    }
    }





    } break;
     //////////////////////////////
    case -1:


        for(i=0;i<=a;i++){ //linha

        for(j=1;j<=a;j++){ //começa pela segunda linha

            if(x[j][i].valor!=0){ //eu n sou zero

             for(k=j-1;k>=0;k--){//até ond o prox é zero
                if(x[k][i].valor!=0){
                    break;
                }

             }
             if(k!=j-1){
             x[k+1][i].valor=x[j][i].valor;
             x[j][i].valor=0;
             }


                    }


        }}break;
         //////////////////////////////





}
}
void NOVOROUND(BLOCO x[][7], int a){
int i,j;
for(i=0;i<=a;i++){
    for(j=0;j<=a;j++){
          x[i][j].pontoinicial=0;
         x[i][j].pontofinal=0;
         x[i][j].dobra=0;
    }
}

}


int taigual(BLOCO x[][7],BLOCO y[][7],int a){ //verifica se ouve movimento
    int k,j,l=0,i;

    for(i=0;i<=a;i++){
        for(j=0;j<=a;j++){
            if(x[i][j].valor==y[i][j].valor)
                l++;
        }
    }
    if(l==(a+1)*(a+1)) //se nao houve movimento, terá ocorrido (a+1)*(a+1) entradas no if
        return(1);
    else
        return (0);

}
void igualador(BLOCO x[][7],BLOCO y[][7],int a){


int i,j;
    for(i=0;i<=a;i++){
        for(j=0;j<=a;j++){
            y[i][j].valor=x[i][j].valor;

        }
    }

}

int ELFIMDEJUEGOCHICO(BLOCO x[][7],int a){
    int i,j;
    for(i=0;i<=a;i++){
        for(j=0;j<=a;j++){
            if(x[i][j].valor==0){//testa se tem algum espaço vazio
                return(1);}

            if(j<a) //testa se alguem é dobravel (em relacao a coluna)
                if(x[i][j+1].valor==x[i][j].valor){
                    return(2);}

            if(i<a) //testa se alguem é dobravel (em relacao a linha)
                if(x[i+1][j].valor==x[i][j].valor){
                    return(3);}
        }
    }
    return(0); //se nao bateu nenhum teste, gg




}

int JOGO(int p[],int a){  //p[0] vai ser a pontuacao e p[1] se ganhou ou nao (1 ganhou, 0 nao), retorna 0 quando acaba

int tecla,i;
BLOCO bloco[7][7];
BLOCO verificador[7][7];

    definevalor(bloco);
    definevalor(verificador);
    a--; //MANDA O "A" COMO TAMANHO DA GRADE, MAS PRA FIM DE COERENCIA COM ESPAÇO DOS ARRAYS EU DO ESSE A--

    //if(a==0)
     //   system ("MODE con cols=30 lines=15");

    printaosquadrados(bloco,a); //inicia a grade


 while(tecla)
    {

    gerador(bloco,a);

    if(!ELFIMDEJUEGOCHICO(bloco,a))
    { //se cabo o jogo, retornará 0 E GG MODAFUCKA
        Sleep(1000);
        textbackground(BLACK);
        clrscr();
        apagatela();
        gotoxy(1,7);
        textcolor(GREEN);

        imprime_centrado("   ######  #####   ######   ######    #####  ##  ##   ", 4);
        imprime_centrado("   ##  ##  ##      ##   ##  ##   ##   ##     ##  ##   ", 5);
        imprime_centrado("   ######  #####   ######   ##    ##  #####  ##  ##   ", 6);
        imprime_centrado("   ##      ##      ##  ##   ##   ##   ##     ##  ##   ", 7);
        imprime_centrado("   ##      #####   ##   ##  ######    #####  ######   ", 8);






        /*for(i=0;i<=25;i++)
        {
            gotoxy(60,10+i);
            textbackground(LIGHTGREEN);
            puts("PERDEU PERDEU PERDEU PERDEU PERDEU PERDEU PERDEU ");

        }*/
        terminajogo(bloco,a,p); Sleep(2000); return(0);
    }


    do
    {   igualador(bloco,verificador,a);
        tecla=detecta();
        blocomestre(bloco,tecla,a);  //faz tudo

    }while(taigual(bloco,verificador,a)); //confere se mudou


    NOVOROUND(bloco,a); //zera as variaveis do blocomestre pra andar o quadrado


    }

}

void terminajogo(BLOCO x[][7],int a,int p[]){
int i,j;
int pontuacao=0;
    p[1]=0;
    for(i=0;i<=a;i++){
        for(j=0;j<=a;j++){
            pontuacao+=x[i][j].valor;
            if(x[i][j].valor>=1024){
                p[1]=1;
                printf("GANHOOOOOOOOOOOOOOOOOOU!");
        }}
    }
    p[0]=pontuacao;
}

char dest[30] = "jogadores";

void imprime_premenu()
{
#define num_opcoes 5

    gotoxy(1,7);
    textcolor(YELLOW);
    //textcolor(LIGHTGREEN);
    imprime_centrado("   ##   ######   ######    ##  ##   ", 4);
    //textcolor(YELLOW);
    imprime_centrado("   ##   ##  ##       ##    ##  ##   ", 5);
    //textcolor(LIGHTBLUE);
    imprime_centrado("   ##   ##  ##   ######    ######   ", 6);
    //textcolor(LIGHTMAGENTA);
    imprime_centrado("   ##   ##  ##   ##            ##   ", 7);
    //textcolor(LIGHTRED);
    imprime_centrado("   ##   ######   ######        ##   ", 8);


    textcolor(BROWN);
    imprime_centrado(" ------------------------------- ", 10);
    imprime_centrado("|        DESENVOLVIDO POR:      |",11);
    imprime_centrado("|     Giovani Bernardes Merlin  |",14);
    imprime_centrado("|          Alex Treviso         |", 12);
    imprime_centrado("|         Filipe Tcacenco       |", 13);
    imprime_centrado(" ------------------------------- ", 15);
}

void destinotxt(char *dest)
{
    int ndest;

    ndest = strlen(dest);
    dest[ndest]='.';
    dest[ndest+1]='t';
    dest[ndest+2]='x';
    dest[ndest+3]='t';
    dest[ndest+4]='\0';
}

void destinobin(char *dest)
{
    int ndest;

    ndest = strlen(dest);
    dest[ndest]='.';
    dest[ndest+1]='b';
    dest[ndest+2]='i';
    dest[ndest+3]='n';
    dest[ndest+4]='\0';
}

char getKey()
{
    int tecla;

    fflush(stdin);

    do
    {
        if(GetAsyncKeyState(VK_RETURN))
            tecla = 0;

        if(GetAsyncKeyState(VK_LEFT))
        {
            tecla = 1;
        }
        else if(GetAsyncKeyState(VK_UP))
        {
            tecla = 2;
        }
        else if(GetAsyncKeyState(VK_RIGHT))
        {
            tecla = 3;
        }
        else if(GetAsyncKeyState(VK_DOWN))
        {
            tecla = 4;
        }

        else if(GetAsyncKeyState(VK_ESCAPE))
        {
            tecla = 5;
        }
        Sleep(50);
    }
    while(tecla!=0 && tecla!=1 && tecla!=2 && tecla!=3 && tecla!=4 && tecla !=5);

    return tecla;
}

void printrank10(char dest[30])
{
    int ndest;
    int i=0;
    char destbin[40];
    char desttxt[40];
    int tecla;
    JOGADOR p;
    FILE *arq;
    int num;

    clrscr();

    strcpy(desttxt, dest);
    destinotxt(desttxt);

    strcpy(destbin, dest);
    destinobin(destbin);

    gotoxy(5, 1);
    printf("NOME");
    gotoxy(28, 1);
    printf("PONTUACAO");
    gotoxy(41, 1);
    printf("GANHOU");

    if(contalinhas(desttxt)>10)
        num = 10;
    else
        num = contalinhas(desttxt);

    if(arq = fopen(destbin, "rb+"))
    {
        ordenharank(dest);

        rewind(arq);

        for(i=1; i<=num; i++)
        {

            fread(&p, sizeof(JOGADOR), 1, arq);

            switch(i)
            {
            case 1:
                textcolor(LIGHTCYAN);
                break;
            case 2:
                textcolor(LIGHTGREEN);
                break;
            case 3:
                textcolor(LIGHTRED);
                break;
            case 4:
            case 5:
                textcolor(LIGHTBLUE);
                break;
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:
                textcolor(WHITE);
                break;
            }

            gotoxy(5, 2+i);
            printf("%s", p.nome);
            gotoxy(28, 2+i);
            printf("%d", p.pontos);
            gotoxy(41, 2+i);
            printf("%s", p.ganhou);
        }
    }
    do
    {
        tecla = getKey();
    }
    while(tecla!=0 && tecla!=5);
}

void printseta(int i, FILE *arq, int nlinhas)
{
    int k;
    int tecla;
    k = 1;
    fseek(arq, 0, SEEK_SET);

    do
    {
        fflush(stdin);
        tecla = getKey();
        switch(tecla)
        {
        case 2:
            gotoxy(3, i);
            printf("  ");
            i--;
            if(i>=3)
            {
                k--;
                gotoxy(3, i);
                printf("->");
            }
            else if(k>1)
            {
                k--;
                i++;
                refreshrank(arq, i, k);
                gotoxy(3, i);
                printf("->");
            }
            else
            {
                i++;
                gotoxy(3, i);
                printf("->");
            }
            break;
        case 4:
            if(i>=3 && i<=25)
            {
                if(i==nlinhas+2)
                    break;
                gotoxy(3, i);
                printf("  ");
                i++;
                gotoxy(3, i);
                printf("->");
                k++;
            }
            else if(k<nlinhas)
            {
                k++;
                refreshrank(arq, i, k);
                gotoxy(3, i);
                printf("->");
            }
            break;

        }
    }
    while(tecla!=5);
}

int jogadorexistente(char desttxt[30], char nome[30], int pontuacao, int *indice, int l)
{
    FILE *arq;
    int i=1;
    char linha[150];
    char n[30];
    char pchar[30];
    int p;
    int re = 0;

    if((arq = fopen(desttxt, "r")))
    {
        while(i<=l)
        {
            fgets(linha, sizeof(linha), arq);
            strtok(linha, " ");
            strcpy(n, (strtok(NULL, ";")));
            strtok(NULL, " ");
            p = (atoi(strcpy(pchar, (strtok(NULL, ";")))));

            if(strcmp(nome, n)==0)
            {
                if(pontuacao>p)
                {
                    *indice = i;
                    re = 1;
                }
                else
                {
                    re = 2;
                }
            }
            i++;
        }
        fclose(arq);
        return re;
    }
}

void inserejogador(JOGADOR *p, char dest [30]) //PASSAR POR PARAMETRO O JOGADOR E A STRING DO DESTINO DA PASTA
{
    char desttxt[40];
    char destbin[40];
    int ndest;
    FILE *arq;
    int l = 10;
    int var;
    char n[7] = "NOME:";
    textcolor(YELLOW);
    fflush(stdin);
    gotoxy(5, 1);
    printf("NOME:");
    gotoxy(21, 1);
    printf("PONTUACAO:%d", p->pontos);
    gotoxy(37, 1);
    printf("GANHOU:%s", p->ganhou);
    gotoxy(10, 1);
    gets(p->nome);

    strcpy(desttxt, dest);
    destinotxt(desttxt);

    strcpy(destbin, dest);
    destinobin(destbin);

    if((jogadorexistente(desttxt, p->nome, p->pontos, &var, contalinhas(desttxt)))!=2 )
    {
        if((arq = fopen(desttxt, "a+")))
        {
            fprintf(arq, "Nome: %s;Pontuacao: %d;Ganhou: %s;\n", p->nome, p->pontos, p->ganhou);
            fclose(arq);
        }
        if((arq = fopen(destbin, "ab+")))
        {
            fwrite(p, sizeof(*p), 1, arq);
            fclose(arq);
        }
    }

    ordenharank(dest);
}

void refreshrank(FILE *arq, int i, int k)
{
    int j, l;
    char linhachar[50];
    char linharank[100];
    char nome[40], pontos[15], g[4];
    int pts;
    char ganhou[5];
    char tecla;

    clrscr();

    textcolor(YELLOW);
    gotoxy(5, 1);
    printf("NOME");
    gotoxy(28, 1);
    printf("PONTUACAO");
    gotoxy(41, 1);
    printf("GANHOU");

    if(i>=24)
        for(j=1; j<=k-24; j++)
            fgets (linhachar, sizeof(linhachar), arq);

    else
        for(j=1; j<=k-1; j++)
            fgets (linhachar, sizeof(linhachar), arq);

    for(j=1; j<=24; j++)
    {
        fgets (linhachar, sizeof(linhachar), arq);
        strtok(linhachar, " ");
        strcpy (nome,strtok(NULL, ";"));
        strtok(NULL, " ");
        pts = atoi(strcpy (pontos,strtok(NULL, ";")));
        strtok(NULL, " ");
        strcpy (ganhou,strtok(NULL, ";"));
        if(i>=24)
            l = j + k-24;
        else
            l = j + k-1;


        switch(l)
        {
        case 1:
            textcolor(LIGHTCYAN);
            break;
        case 2:
            textcolor(LIGHTGREEN);
            break;
        case 3:
            textcolor(LIGHTRED);
            break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
            textcolor(LIGHTBLUE);
            break;
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
            textcolor(LIGHTMAGENTA);
            break;
        default:
            textcolor(WHITE);
            break;
        }


        gotoxy(5, j+2);
        printf("%s", nome);
        gotoxy(28, j+2);
        printf("%d", pts);
        gotoxy(41, j+2);
        printf("%s", ganhou);
    }

    fseek(arq, 0, SEEK_SET);

    textcolor(YELLOW);
}

void printrank(char dest[30])
{
    int i=1;
    int nlinhas;
    char linhachar[50];
    char linharank[100];
    char nome[40], pontos[15], g[4];
    int pts;
    char desttxt[40];
    char ganhou[5];
    char tecla;
    int ndest;
    FILE *arq;
    clrscr();

    strcpy(desttxt, dest);
    destinotxt(desttxt);

    nlinhas = contalinhas(desttxt);

    if((arq = fopen(desttxt, "r+")) && nlinhas>=24)
    {
        gotoxy(5, 1);
        printf("NOME");
        gotoxy(28, 1);
        printf("PONTUACAO");
        gotoxy(41, 1);
        printf("GANHOU");

        for(i=1; i<=24; i++)
        {
            fgets (linhachar, sizeof(linhachar), arq);
            strtok(linhachar, " ");
            strcpy (nome,strtok(NULL, ";"));
            strtok(NULL, " ");
            pts = atoi(strcpy (pontos,strtok(NULL, ";")));
            strtok(NULL, " ");
            strcpy (ganhou,strtok(NULL, ";"));



            switch(i)
            {
            case 1:
                textcolor(LIGHTCYAN);
                break;
            case 2:
                textcolor(LIGHTGREEN);
                break;
            case 3:
                textcolor(LIGHTRED);
                break;
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
                textcolor(LIGHTBLUE);
                break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
                textcolor(LIGHTMAGENTA);
                break;
            default:
                textcolor(WHITE);
                break;
            }


            gotoxy(5, i+2);
            printf("%s", nome);
            gotoxy(28, i+2);
            printf("%d", pts);
            gotoxy(41, i+2);
            printf("%s", ganhou);
        }
    }
    else if((arq = fopen(desttxt, "r+")) && nlinhas<24)
    {
        gotoxy(5, 1);
        printf("NOME");
        gotoxy(28, 1);
        printf("PONTUACAO");
        gotoxy(41, 1);
        printf("GANHOU");

        for(i=1; i<=nlinhas; i++)
        {
            fgets (linhachar, sizeof(linhachar), arq);
            strtok(linhachar, " ");
            strcpy (nome,strtok(NULL, ";"));
            strtok(NULL, " ");
            pts = atoi(strcpy (pontos,strtok(NULL, ";")));
            strtok(NULL, " ");
            strcpy (ganhou,strtok(NULL, ";"));


            switch(i)
            {
            case 1:
                textcolor(LIGHTCYAN);
                break;
            case 2:
                textcolor(LIGHTGREEN);
                break;
            case 3:
                textcolor(LIGHTRED);
                break;
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
                textcolor(LIGHTBLUE);
                break;
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
                textcolor(LIGHTMAGENTA);
                break;
            default:
                textcolor(WHITE);
                break;
            }


            gotoxy(5, i+2);
            printf("%s", nome);
            gotoxy(28, i+2);
            printf("%d", pts);
            gotoxy(41, i+2);
            printf("%s", ganhou);
        }
    }

    if(fopen(desttxt, "r+"))
    {
        textcolor(YELLOW);
        gotoxy(3, 3);
        printf("->");
        gotoxy(3, 1);
        i=3;
        printseta(i, arq, nlinhas);
    }
}

int contalinhas(char dest[30])
{
    char linhachar[100];
    FILE *arq;
    int cont=-1;
    if((arq = fopen(dest, "r+")))
    {
        while(!feof(arq))
        {
            fgets (linhachar, sizeof(linhachar), arq);
            cont++;
        }
    }
    fclose(arq);
    return cont;
}

void ordenharank(char dest[30])//ORDENA O RANK EM ORDEM DECRECEMTE
{
    int nlinhas;
    char destbin[40], desttxt[40];
    int i, j;
    int m=0;
    int var;
    int posl;
    JOGADOR ps;
    FILE *arq;
    char linhachar[100];
    int ndest;
    int limfor;

    strcpy(desttxt, dest);
    destinotxt(desttxt);

    strcpy(destbin, dest);
    destinobin(destbin);

    int pos[contalinhas(desttxt)];
    char pontos[contalinhas(desttxt)][20];
    JOGADOR p[contalinhas(desttxt)];

    limfor = contalinhas(desttxt);

    for(i=0; i<limfor; i++)
    {
        pos[i]=i;
    }

    if((arq = fopen(desttxt, "a+")))
    {
        for(i=0; i<limfor; i++)
        {
            fgets (linhachar, sizeof(linhachar), arq);
            strtok(linhachar, " ");
            strcpy (p[i].nome,strtok(NULL, ";"));
            strtok(NULL, " ");
            p[i].pontos = atoi(strcpy (pontos[i],strtok(NULL, ";")));
            strtok(NULL, " ");
            strcpy (p[i].ganhou,strtok(NULL, ";"));
        }
        fclose(arq);

            if((jogadorexistente(desttxt, p[i-1].nome, p[i-1].pontos, &var, (limfor-1))) == 1)
            {
                limfor--;
                p[var-1] = p[i-1];
            }

        for(j=0; j<limfor; j++)
        {
            for(i=0; i<limfor-j-1; i++)
            {
                if(p[pos[i]].pontos<p[pos[i+1]].pontos)
                {
                    posl = pos[i];
                    pos[i] = pos[i+1];
                    pos[i+1] = posl;
                }

            }
        }
    }
    else
        printf("Erro na abertura de %s", desttxt);

    if((arq = fopen(desttxt, "w")))
    {
        for(i=0; i<limfor; i++)
        {
            fprintf(arq, "Nome: %s;Pontuacao: %d;Ganhou: %s;\n", p[(pos[i])].nome, p[pos[i]].pontos, p[pos[i]].ganhou);
        }
        fclose(arq);
    }

    if((arq = fopen(destbin, "wb")))
    {
        for(i=0; i<limfor; i++)
        {
            fwrite(&p[pos[i]], sizeof(p), 1, arq);
        }
        fclose(arq);
    }
    else
        printf("Erro na abertura");
}

void imprime_centrado(char str[30],int linha) //IMPRIME NA TELA UMA STRING CENTRADA
{
    gotoxy((DMAX-strlen(str))/2,linha);
    puts(str);
}

void salvarank(char dest[30])
{
    char desttxt[40];
    char dests[80];
    char linha[150];
    FILE *arq1;
    FILE *arq2;
    int n, i;
    char c;

    strcpy(desttxt, dest);
    destinotxt(desttxt);

    n = contalinhas(desttxt);
    fflush(stdin);

    while((c= getchar()) != '\n' && c != EOF)
            /* discard */ ;

    gotoxy(2, 19);
    textcolor(CYAN);
    printf("Insira o Diretorio e o nome que deseja salvar o Rank:\n");
    gotoxy(2, 21);
    textcolor(WHITE);
    fflush(stdin);
    gets(dests);

    destinotxt(dests);

    if((arq1 = fopen(desttxt, "a+")))
    {
        if((arq2 = fopen(dests, "w")))
        {
            for(i=1; i<=n; i++)
            {
                fgets(linha, sizeof(linha), arq1);
                fputs(linha, arq2);
            }
        }
        fclose(arq1);
        fclose(arq2);
    }
}

int pegaTecla_menu() //FUNÇÃO QUE PEGA A TECLA PARA SELEÇÃO NO MENU
{
    int tecla;

    getch();
    do
    {
        if(GetAsyncKeyState(38))
            tecla = 1;

        else if(GetAsyncKeyState(40))
            tecla = 2;

        else if(GetAsyncKeyState(13))
            tecla = 3;

    }
    while(tecla!=1 && tecla!=2 && tecla!=3);

    return tecla;
}

int interface_do_menu() //FUNÇÃO QUE COMANDA A INTERFACE DO MENU
{
#define num_opcoes 5
    int tecla, person;
    int i, op_escolhida=0;  //op_escolhida é o retorno da função
    int cont_op=1;  //Controla a opcao que está destacada (em amarelo)

    imprime_premenu();

    char opcao1[5][20]= {"Modo Classico","Modo Facil","Modo Personalizado","Ranking","Sair"};
    char opcao1a[6][20]= {"Muito Facil","Facil","Normal","Dificil","Muito Dificil","Voltar"};

    textcolor(YELLOW);
    imprime_centrado(opcao1[0],17);  //Imprime a primeira opção em amarelo, já que é onde o 'cursor' inicia

    textcolor(CYAN);

    for(i=1; i<num_opcoes; i++)
        imprime_centrado(opcao1[i],17+i);    //imprime as outras opcoes

    textcolor(BROWN);
    imprime_centrado("                           2016 All Rights Reserved", 25);


    do
    {
        tecla = pegaTecla_menu();

        textcolor(CYAN);
        imprime_centrado(opcao1[cont_op-1],16+cont_op);  //Isso apaga a opcao que estava em amarelo

        switch(tecla)   //De acordo com a tecla pressionada, move o cursor ou seleciona a opcao destacada
        {
        case 1:
            cont_op--;  //Isso faz a opcao destaca subir em uma linha
            if (cont_op<1)  //Reseta para o fim
                cont_op=num_opcoes;
            break;

        case 2:
            cont_op++;  //Opcao destacada desce uma linha
            if(cont_op>num_opcoes)
                cont_op=1;  //Reseta para o inicio
            break;

        case 3:
            op_escolhida=cont_op;   //Escolhe a opcao destacada.
            break;
        }

        textcolor(YELLOW);
        imprime_centrado(opcao1[cont_op-1],16+cont_op);
        Sleep(TEMPO);
    }
    while(tecla!=3);     //Roda enquanto nao há opcao escolhida

    for(i=0; i<num_opcoes; i++)
    {
        imprime_centrado("                         ",17+i); //Limpa a tela
    }
    if(op_escolhida==1)
        return 4;

    if(op_escolhida==2)
        return 4;

    if (op_escolhida==3)
    {
      person=menu_Personalizado();
      return person;
    }

    if (op_escolhida==4)
        menu_Rank();

    if (op_escolhida==5)
        return 0;



}

int menu_Personalizado() //FUNÇÃO DE CONTROLE DA SELEÇÃO MENU PERSONALIZADO
{
#define TAM 5
    char personalizado[TAM][30] = {"4x4", "5x5", "6x6", "Personalizado", "Voltar ao Menu Principal"};
    int i, y;
    int op_escolhida=0, cont_op=1;
    int tecla;

    textcolor(YELLOW);
    imprime_centrado(personalizado[0],17);  //IMPRIME A PRIMEIRA OPÇÃO EM AMARELO JÁ QUE É ONDE INICIA O CURSOR

    textcolor(CYAN);

    for(i=1; i<TAM; i++)
        imprime_centrado(personalizado[i],17+i);    //IMPRIME AS OUTRAS OPÇÕES



    do
    {
        tecla = pegaTecla_menu();

        textcolor(CYAN);
        imprime_centrado(personalizado[cont_op-1], 16+cont_op);  //APAGA A OPÇÃO QUE ESTAVA EM AMARELO

        switch(tecla)   //DE ACORDO COM A TECLA, MOVE O CURSOR OU SELECIONA A OPÇÃO
        {
        case 1:
            cont_op--;  //OPÇÃO DESTACADA SOBE UMA LINHA
            if (cont_op<1)
                cont_op=TAM;    //RESETA PARA O FIM
            break;

        case 2:
            cont_op++;  //OPÇÃO DESTACADA DESCE UMA LINHA
            if(cont_op>TAM)
                cont_op=1;  //RESETA PARA O INICIO
            break;

        case 3:
            op_escolhida=cont_op;   //ESCOLHE A OPÇÃO DESTACADA
            break;
        }

        textcolor(YELLOW);
        imprime_centrado(personalizado[cont_op-1],16+cont_op);
        Sleep(TEMPO);
    }
    while(tecla!=3);

    for(i=0; i<TAM; i++)
        imprime_centrado("                         ",17+i); //LIMPA A TELA

    if (cont_op==1)
        y=4;

    if (cont_op==2)
        y=5;

    if (cont_op==3)
        y=6;

    if (cont_op==4)
    {
        textcolor(CYAN);
        imprime_centrado("MAXIMO 6x6 ", 18);
        gotoxy(1,19);
        printf("            Altura/Largura: ");
        gotoxy(25,18);
        scanf("%d", &y);

        if(y>6){
        imprime_centrado("TAMANHO INVALIDO", 22);
        Sleep(1000);
        apagatela();
        imprime_premenu();
        y=menu_Personalizado();}

    }

    if (cont_op==5)
        interface_do_menu();

    return y;
}

int menu_Rank() //FUNÇÃO DE CONTROLE DA SELEÇÃO RANKING NO MENU PRINCIPAL
{
#define TAM 5
    char rank[TAM][30] = {"Exibir Ranking[TOP 10]", "Exibir Todo Ranking", "Resetar Ranking", "Salvar Ranking", "Voltar ao Menu Principal"};
    int i;
    int op_escolhida=0, cont_op=1;
    int tecla;
    char desttxt[40];
    char destbin[40];
    char c;

    strcpy(desttxt, dest);
    destinotxt(desttxt);

    strcpy(destbin, dest);
    destinobin(destbin);

    textcolor(YELLOW);
    imprime_centrado(rank[0],17);  //IMPRIME A PRIMEIRA OPÇÃO EM DESTAQUE

    textcolor(CYAN);

    for(i=1; i<TAM; i++)
        imprime_centrado(rank[i],17+i);    //IMPRIME AS OUTRAS OPÇÕES




    do
    {
        tecla = getKey();

        textcolor(CYAN);
        imprime_centrado(rank[cont_op-1],16+cont_op);  //APAGA A OPÇÃO QUE ESTAVA DESTACADA

        switch(tecla)   //DE ACORDO COM A TECLA SOBE, DESCE OU SELECIONA A OPÇÃO
        {

        case 2:
            cont_op--;  //OPÇÃO DESTACADA SOBE UMA LINHA
            if (cont_op<1)  //RESETA PARA O FIM
                cont_op=TAM;
            break;

        case 4:
            cont_op++;  //OPÇÃO DESTACADA DESCE UMA LINHA
            if(cont_op>TAM)
                cont_op=1;  //RESETA PARA O INICIO
            break;

        case 0:
            op_escolhida=cont_op;   //ESCOLHE A OPÇÃO DESTACADA
            break;
        }

        textcolor(YELLOW);
        imprime_centrado(rank[cont_op-1],16+cont_op);
        Sleep(TEMPO);
    }
    while(tecla!=0 && tecla!=5);

    for(i=0; i<TAM; i++)
        imprime_centrado("                         ",17+i); //LIMPA A TELA

    if(tecla==0)
    {
        switch(cont_op)
        {
        case 1:
            printrank10(dest);
            clrscr();
            imprime_premenu();
            menu_Rank();
            break;

        case 2:
            printrank(dest);
            clrscr();
            imprime_premenu();
            menu_Rank();
            break;

        case 3:
            remove(desttxt);
            remove(destbin);
            menu_Rank();
            break;

        case 4:
            while((c= getchar()) != '\n' && c != EOF)
            /* discard */ ;
            fflush(stdin);
            clrscr;
            imprime_premenu();
            salvarank(dest);
            clrscr();
            fflush(stdin);
            imprime_premenu();
            fflush(stdin);
            menu_Rank();
            break;


        case 5:
            interface_do_menu();
            break;
        }
    }
    else
        interface_do_menu();
}

void apagatela()
{
    int i;
    int j;

    for(i=0; i<DMAX; i++)
    {
        for(j=0; j<HMAX; j++){
            gotoxy(i,j);
            printf("  ");}
    }
}

