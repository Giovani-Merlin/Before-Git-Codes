/*
 * Teclado.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 


#include <avr/io.h>
#include "HeaderGeral.h"


char bounce = 5;

char Teclas[4][4] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
char DebounceB(void);
char DebounceC(void);

char DebounceB(){
	
	char count = 0;
	char last_tecla = 0;
	char tecla_agora;
	
	while(count != bounce){
		
		delay_ms(5);
		tecla_agora = PINB;
		if(tecla_agora == last_tecla)
			count++;
	
		else
		count=0;
	
	last_tecla=tecla_agora;
	}
	return last_tecla;
}

char DebounceC(){
	
	char count = 0;
	char last_tecla = 0;
	char tecla_agora;
	
	while(count != bounce){
		
		delay_ms(5);
		tecla_agora = PINC;
		if(tecla_agora == last_tecla)
		count++;
		
		else
		count=0;
		
		last_tecla=tecla_agora;
	}
	return last_tecla;
}

void Init_Teclado(){
    //Portas B (linha) são output e C (colunas) são input (inicialmente)
    DDRB  = (DDRB & 0xF0) | (0x0F);
    DDRC  = (DDRC & 0xF0);
    //Linhas 0 e Colunas 1
    PORTB = (PORTB & 0xF0);
    PORTC = (PORTC & 0xF0) | (0x0F);


}

char Le_teclado()
{   
    // pega o valor das colunas
    unsigned int KeyC;
    unsigned int KeyB,aux;
     KeyC = DebounceC();
		 if((~KeyC & 0x0F)==0)
		     return 0;
     //Inverte input e output (pra poder ler a linha)
     DDRB  =  (DDRB & 0xF0);
     DDRC  =  (DDRC & 0xF0) | (0x0F);
    //Inverte High e low (linha 1 e coluna 0) (agora só ler a linha)
     PORTB = (PORTB & 0xF0) | (0x0F);
	 PORTC = (PORTC & 0xF0);
     aux = DebounceB();
	   Init_Teclado();
	 if(KeyC != DebounceC()) //se nesse tempo ja trocou
		return 0;

	   KeyB = (~aux & 0x0F); //pega os d interesse;
		 if((~KeyB & 0x0F)==0)
		 return 0;
   
     
     aux = KeyC;
     KeyC = (~aux & 0x0F);

		
		
		KeyB = KeyB>>1;
		KeyC = KeyC>>1;
		if(KeyB==4)
			KeyB--;
		if(KeyC==4)
			KeyC--;
			
			
      return(Teclas[KeyB][KeyC]);

	
}

