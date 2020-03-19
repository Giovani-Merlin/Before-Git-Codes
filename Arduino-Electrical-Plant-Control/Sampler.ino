#include<avr/io.h>
#include<avr/interrupt.h>

int n=0;
int aux=0;
int u[400];
int y[400];
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
  
  TCCR2B = TCCR2B & B11111000 | B00000001; 

  
  
  sei(); //allow interrupts
}

ISR(TIMER1_COMPA_vect)
{ 
  if(flag==0)
  {
    
    if((n<100))
    {
      
      u[n] = aux;
      analogWrite(3,u[n]);
      y[n] = analogRead(A0);
      n++;
    }
    else{
      flag=1;

    }
  }
}

void loop()
{
  
  if(random(0,5) == 4)
  {
        aux = random(0,255);
  }
  if(flag==1)
  {

    for(int x=0;x<100;x++)
    {
      Serial.print(u[x]);
      Serial.print(", ");
      Serial.println(y[x]);


    }

    flag=0;
    n=0;
  }
  //other operations
}
