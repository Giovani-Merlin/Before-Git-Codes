/*
 * Delay.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 


#include <avr/io.h>
#include <avr/interrupt.h>
#include "HeaderGeral.h"

void delay_1ms()
{
	TCNT0=6; //256-250=6 //timer 0 -> A
	TIFR0=1;
	while((TIFR0&1)==0);
}

void delay_ms(unsigned short c)
{
	while(c>0)
	{
		delay_1ms();
		c--;
	}
}