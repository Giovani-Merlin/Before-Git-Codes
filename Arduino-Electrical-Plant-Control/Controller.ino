#include<avr/io.h>
#include<avr/interrupt.h>

int n=0;
int ref = 51;
double medida;
double u[3] = {0,0,0};
double e[3] = {0,0,0};
int y[400];
int controle[400];
int flag=0;

void setup()
{
  Serial.begin(115200);
  pinMode(A0, INPUT);
  
  analogWrite(3,0);
  delay(5000);
  
  cli(); //stop interrupts
  TCCR1A = 0;// clear register
  TCCR1B = 0;// clear register
  TCNT1  = 0;//reset counter
  OCR1A  = 6599; //must be <65536
  //compare match register = [ 16,000,000Hz/ (prescaler * desired interrupt frequency) ] - 1
  TCCR1B |= (1 << WGM12); //CTC On
  // Set prescaler for 1
  TCCR1B |= (0 << CS12) | (0 << CS11) | (1 << CS10);
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE1A);

  TCCR2A = TCCR2A & B11111000 | B00000001; 
  TCCR2B = TCCR2B & B11111000 | B00000001; 

  sei(); //allow interrupts
}

ISR(TIMER1_COMPA_vect)
{  
  if(flag==0)
  {
    if((n<400))
    {
      y[n] = analogRead(A0);
      medida = y[n];
      medida = medida*255/1023;

      e[0] = e[1];
      e[1] = e[2];
      e[2] = ref - medida;
      
      u[0] = u[1];
      u[1] = u[2];

     //Controller equation
     u[2] = 0.4*u[1] + 0.6*u[0]+  2*e[2] - 0.7994*e[0] -0.8997*e[1] ;

      controle[n] = u[2];
      // Quantization fix
      if(controle[n]>255){
      controle[n]=255;
      }
      analogWrite(3,controle[n]);
      n++;
    }
    else
    {
      flag=1;
    }
  }
}

void loop()
{
  if(flag==1)
  {
    for(int x=0;x<400;x++)
    {
      Serial.print(y[x]);
      Serial.print(", ");
      Serial.println(controle[x]);
    }
    flag=2;
    n=0;
  }
  //other operations
}
