/*
 * Lcd.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 


#include <avr/io.h>
#include "HeaderGeral.h"

void LCD_config ()
{

	DDRD |= 0b11111100; // seta pino D2-7 (Digital 4-7) como saída e n mexe dos D0 e D1 (TX RX)

	
		// 0x33  0x32 -> inicializa em 8bits pra n bugar e muda pra 4 bits (descubro dpois pq, mas vi num site).
		LCD_comando(0x33);
		LCD_comando(0x32);
	 	LCD_comando(0x28);//0x28 -> 4 BITS MODE ON -> como inicia em 8 bits, tem q fazer 2 x msm
	 	LCD_comando(0x0E); // Cursor ON e não pisca
		LCD_comando(0x80); // linha 1 coluna 1;
	    LCD_comando(0x06); // Cursor mexe pra direita
		LCD_comando(0x01);    //display clear
		
		delay_ms(2);
}

void LCD_clear(){
	LCD_comando(0x01);	
}

void LCD_posicao(unsigned char x, unsigned char y){
	unsigned char bordas[] = {0x80, 0xC0, 0x94 , 0xD4}; // 0x80			"3º linha" = final da primeira	0x94
														// 0xC0				0xD4
		LCD_comando(bordas[y-1]+x-1);
		delay_ms(1);
	
}

void LCD_comando(char cmd){
	
	PORTD &= ~_BV(PORTD2); // COMANDO  RS=0; _BV = ( 1<< n) . Força só o bit do RS ser 0
	PORTD |= _BV(PORTD3);// E=1 sem mexe no resto;
	PORTD = (PORTD & 0x0F)|(cmd & 0xF0);	// (PORTD & 0x0F)| -> Deixa os D0-D3 (n afetar resto). (cmd & 0xF0) deixa os high 
	PORTD &= ~_BV(PORTD3); // E=0
	delay_ms(1);
	PORTD |= _BV(PORTD3);
	PORTD = (PORTD & 0x0F)|( (cmd<<4) & 0xF0);	// ( (cmd<<4) & 0xF0) -> pega o low do cmd
	PORTD &= ~_BV(PORTD3);
	delay_ms(1);
	PORTD |= _BV(PORTD3);
	delay_ms(1);
}
	

void LCD_escreve(char const *a){
	
	PORTD |= _BV(PORTD2); // COMANDO  RS=1;
	while(*a != 0){ //enquanto n escreveu td
	LCD_putchar(*a);
	a++;
	}
	
}

void LCD_putchar(char a)
{


	PORTD |= _BV(PORTD3);// E=1 sem mexe no resto;
	PORTD = (PORTD & 0x0F)|(a & 0xF0);	// (PORTD & 0x0F)| -> Deixa os D0-D3 (n afetar resto). (cmd & 0xF0) deixa os high 
	PORTD &= ~_BV(PORTD3); // E=0
	delay_ms(1);
	PORTD |= _BV(PORTD3);
	PORTD = (PORTD & 0x0F)|( (a<<4) & 0xF0);	// ( (cmd<<4) & 0xF0) -> pega o low do cmd
	PORTD &= ~_BV(PORTD3);
	delay_ms(1);
	PORTD |= _BV(PORTD3);
	delay_ms(1);
	

}