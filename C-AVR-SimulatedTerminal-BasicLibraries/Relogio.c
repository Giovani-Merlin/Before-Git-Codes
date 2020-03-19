/*
 * Relogio.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 


#include <avr/io.h>
#include <avr/interrupt.h>
#include "HeaderGeral.h"


int WatchDog=0;
int aff=0; //queria 1 em 1 segundo, mas como led tem q pisca 2x por segundo precisa essa porcaria
int LedOn=0;
void IniciaRelogio(void){

    TIMSK1 = _BV(OCIE1A); //ativa interrupt 1
    TCCR1B =_BV(WGM12) | _BV(CS12) | _BV(CS10); //prescaler 1024 EE usando compare o wgm12
    OCR1A = 7812; //1segundo certim 15625
    DDRB |= _BV(PB5); //led 13 eh output
}

// void SetaRelogio(int min,int hor,int mes,int dia){




// }

ISR(TIMER1_COMPA_vect){
    aff++;
    if(aff==2){
    ContaRelogio();
    aff=0;
    WatchDog++;
    }

    if(WatchDog>=70) { //1 min e 10
    LedOn=1;
        PORTB ^= _BV(PB5);//pisca led
        if(WatchDog>=90)//1min e meio
         Server_FechaSessao();
    }

}

void ZeraWatch(void){
    WatchDog=0;
    if(LedOn)
     PORTB &= ~_BV(PB5);
}

