/*
 * testeserial.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>  // BIBLIOTECA PARA VALOR DO UBRR
#include "HeaderGeral.h"
#include <util/setbaud.h>

//#define BRC ( (F_CPU/(16*BAUD) - 1) //valor pro ubbrn assincrono normal

char RBuffer[BUFFER_SIZE];
unsigned int RBPosition=0;
char TBuffer[BUFFER_SIZE];
unsigned int TBWPosition = 0;
unsigned int TBRPosition = 0;
unsigned int TSize=0;
unsigned check = 0;
unsigned Char[2];
int PreServer=0;

void USART_init()
{
   
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE; 
    // se n usasse pacote <util/setbaud.h> era simplesmente
	// UBRR0H = (BRC >> 8);
    // UBBR0L = BRC;  // 16 BITS ELE, tem q dividir em 8 bits cada parte
	
	UCSR0A &= ~_BV(U2X0); // DESABILITA DOUBLE-ASYNC(VELOCIDADE DUPLA)
	UCSR0B |= _BV(RXCIE0) | _BV(TXCIE0); // HABILITA RECEIVER E TRANSMITTER INTERRUPT
	UCSR0B |= _BV(RXEN0) | _BV(TXEN0); // HABILITA RX E TX
	UCSR0C |= _BV(UCSZ01)| _BV(UCSZ00); // SETA COMUNICACAO PARA DADOS DE 8 BITS
	
	sei(); // FLAG GLOBAL DOS INTERRUPTS
}


void USART_putstring(char str[], int size)
{
	int i;

	for(i=0;i<size;i++){


		TBuffer[TBWPosition]=str[i]; //TBW é até que posição ja foi escrito, size é só quanto quero mandar da string. (1 vira char)

		TBWPosition++;

		if(TBWPosition>=BUFFER_SIZE)
			TBWPosition=0;


	}


	    if(UCSR0A & (1 << UDRE0)) //se ta livre, faz começar o processo!
    {
        UDR0 = 0;
    }
	


}



ISR(USART_TX_vect){

	if(TBRPosition!=TBWPosition){ //buffer n foi todo lido

 	UDR0=TBuffer[TBRPosition];
	 TBRPosition++;
	}
	if(TBRPosition>=BUFFER_SIZE)
		TBRPosition=0;

}

ISR(USART_RX_vect) // INTERRUPT DA BIBLIOTECA QUE ATIVA QUANDO RXC E RXCIE ESTAO ALTOS
{	
	
	RBuffer[RBPosition] = UDR0;
	Server_Receive(&RBuffer[0],RBPosition);
	
	RBPosition++;
	
	if(RBPosition>BUFFER_SIZE){		
		RBPosition=0;
	}

	

}

void PrintaBuffer(void){ //debugger
USART_putstring("   ",3);
delay_ms(100);
	USART_putstring(RBuffer,BUFFER_SIZE-1);
}





