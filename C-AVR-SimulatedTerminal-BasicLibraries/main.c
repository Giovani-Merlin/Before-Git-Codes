/*
 * testeserial.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 

#define F_CPU 16000000UL

#include <avr/io.h>
#include "HeaderGeral.h"
#define F_CPU 16000000UL

void ForaDeOp(void);


int Position=0;
int aux = 0;
int ServerOn = 1;
int login = 0;
int main(void)
{

			
			TCCR0A = 0;  //modo normal fchip=16mhz
			TCCR0B = 0x03;  //prescaler de 64
			LCD_config();
			USART_init();
			Init_Teclado();
			TelaInicial();
			IniciaRelogio();
			
    while (1) 
    {	
				while(ServerOn){
				ZeraWatch();
				aux = PINC;
				delay_ms(50);

				if(Server_Horas()<0x18 && Server_Horas()>0x06)
				if( PINC != aux){
				login = Login();

				}


			//	PrintaBuffer();
				while(login && ServerOn){
				if(Server_Horas()>0x18 || Server_Horas()<0x06)//fora d horario
				EncerraSessao();

					delay_ms(50);
				//	PrintaBuffer();
				}

					
    }		ForaDeOp();
				
				

	}
}

void BloqueiaTerminal(void){
	ServerOn=0;
}

void LiberaTerminal(void){
	ServerOn=1;
}

void ForaDeOp(void){

				LCD_clear();
				delay_ms(300);
				LCD_posicao(1,1); // se nao quiser que fique piscando, só botar um if e quando entrar nao entra mais no if....Mas curti assim
				LCD_escreve("FORA DE");
				LCD_posicao(1,2);
				LCD_escreve("OPERACAO");
				delay_ms(1000);
				if(ServerOn){
				if(login)
				Server_Menu();
				else
				TelaInicial();
				}

}

void EncerraSessao(void){
	login=0;
}
