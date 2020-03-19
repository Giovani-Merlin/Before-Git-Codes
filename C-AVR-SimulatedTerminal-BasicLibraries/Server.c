/*
 * testeserial.c
 *
 * Created: 11/05/2019 12:58:48
 * Author : GiovaniMerlin e DanielWellington
 */ 


#include "HeaderGeral.h"
char AtualizaHoras=0;
int auxhoras=0;

int PegaNome=0;
char User[7];
char Senha[7];
int Usuario=1;
int count=0;
int Normal=1;
int countNome=0;
int LIBERA=0;
char UserNome[30];
int TamanhoNome=0;
char Letra[2];


char segundos=0;
char minutos=0;
char horas=0;
char mes=0;
char dia=0;


int Server_Receive(char *c,int pos){
    
	int aux = pos;
	if(aux==0)
		aux=BUFFER_SIZE;

    ZeraWatch();    

    if(AtualizaHoras){
        auxhoras++;
		segundos=0;
        if(auxhoras==1)
        dia=c[pos];
        if(auxhoras==2)
        mes=c[pos];
        if(auxhoras==3)
        horas=c[pos];
        if(auxhoras==4){
            minutos=c[pos];
            auxhoras=0;
            AtualizaHoras=0;
            Normal=1;
            USART_putstring("PH",2);
          }

       }
		
	if(Normal){ // NÃO TA RECEBENDO NOME
        if(c[pos] == 'L')
            if(c[aux-1] == 'S'){
                LiberaTerminal();
                 USART_putstring("PL",2);
              
            }

        if(c[pos] == 'T')
                if(c[aux-1] == 'S'){
                    BloqueiaTerminal();
                    USART_putstring("PT",2);
                }
        
       if(c[pos] == 'H')
            if(c[aux-1] == 'S'){
                    AtualizaHoras=1;
                    Normal=0;
                                    }
        
        if(c[pos] == 'O')
                if(c[aux-1] == 'S'){
                    PegaNome=1;
                    Normal=0;
                        return 1;
                }
        
        if(c[pos] == 'A')
            if(c[aux-1] == 'P'){
                    //Server_Venda
                    USART_putstring("SA",2);
                }

        if(c[pos] == 'P')
            if(c[aux-1] == 'P'){
                    //Server_Consulta
                    USART_putstring("SP",2);
                }

        if(c[pos] == 'C')
            if(c[aux-1] == 'P'){
                    //Server_ConfirmaCompra
                    USART_putstring("SC",2);
                }

        if(c[pos] == 'F')
                if(c[aux-1] == 'P'){
                    //Server_FechaVenda
                    USART_putstring("SF",2);
                }

        if(c[pos] == 'X')
            if(c[aux-1] == 'S'){
                    Server_FechaSessao();
                    // LCD_clear();
                    // LCD_posicao(1,1);
                    // LCD_escreve("sucesso");
                    // delay_ms(5000);
                }

        if(c[pos] == 'I')
            if(c[aux-1] == 'P'){
                    //Server_Comprovante
                    USART_putstring("SI",2);
                }

        if(c[pos] == 'B')
            if(c[aux-1] == 'L'){
                    //Server_CodigoDeBarra
                    USART_putstring("PB",2);
                }
    }

    if(PegaNome){  
                if(TamanhoNome == 0 && Normal == 0){
                TamanhoNome = (int) c[pos];
                LIBERA=0;}

                else{
                UserNome[countNome]=c[pos];
                countNome++;

                if(countNome==TamanhoNome){
                char Block[] = "Nao Autorizado";
  
                for(int i=0;i<TamanhoNome;i++){
                    if(UserNome[i]!=Block[i])
                        LIBERA=1;
                       
                }
                UserNome[countNome]=TamanhoNome;
                Normal=1;
                PegaNome=0;
                countNome=0; //No deslogar tem que fazer Libera=0;
                TamanhoNome=0;

                }

                
            }


        }
    return 0;

}

void PrintaUser(void){
    USART_putstring(UserNome,20);
    USART_putstring("    ",4);
}

void TelaInicial(void){
        LCD_clear();
        LCD_posicao(1,2);
        LCD_escreve("Senha:");
        LCD_posicao(1,1);
        LCD_escreve("Login:");
        

}
void Server_Login(void){ 
     char aux[] = {14};
    USART_putstring("PO",2);
    USART_putstring(aux,1);
    USART_putstring(User,7);
    USART_putstring(Senha,7);
   

}

void Server_Menu(void){
        LCD_clear();
        LCD_posicao(1,2);
        LCD_escreve("Quantidade:");
        LCD_posicao(1,1);
        LCD_escreve("Produto:");
}

int Login(void){

    	Letra[0]=Le_teclado();

			if(Usuario){ //Digitando usuario
				if(Letra[0] != 0 && Letra[0] != '#'){
						User[count]=Letra[0];
						count++;
                        LCD_escreve(Letra);
					

					}
					else if(Letra[0] == '#'){ //ERROOOU

						User[count]=0;
						Letra[0]=' ';
                        
                        if(count>0){
                        count--;
                        LCD_posicao(7+count,1);
                        LCD_escreve(Letra);
                        LCD_posicao(7+count,1);
                        }
  
                        
						
					}
					
					if(count==6){ //digitou usuario
					Usuario=0;
					count=0;
                    LCD_posicao(7,2);
					}
                    }

			else{ //Se é senha
					
				if(Letra[0] != 0 && Letra[0] != '#'){
						Senha[count]=Letra[0];
						count++;
						LCD_escreve("*");
					}
					else if(Letra[0] == '#'){ //ERROOOU
						Senha[count]=0;
						Letra[0]=' ';
                        
                        if(count>0){
                        count--;
                        LCD_posicao(7+count,2);
                        LCD_escreve(Letra);
                        LCD_posicao(7+count,2);
                        }                       
						
					}
					

					if(count==6){ //digitou senha
					Usuario=1;
					count=0;
                    LCD_posicao(7,1);
                    Server_Login();
                    delay_ms(400); //se nao da um delay ele printa o "nao autorizado".
               
                    if(!LIBERA){

                    for(int i=0;i<3;i++){
                      LCD_clear();
                      delay_ms(300);
                      LCD_posicao(1,1);
                      LCD_escreve("NAO AUTORIZADO");
                      delay_ms(1000);
                        
                    }
                    TelaInicial();

                    }
                    if(LIBERA) { //não tenho ideia porque if else nao funciona no atmel
                        Server_Menu();
                    }

                    return LIBERA;
					}

					

					}
                    return 0;
									
}

void ContaRelogio(void){
	segundos++;
	if(segundos==60){
		segundos=0;
		minutos++;
		if(minutos==60){
			minutos=0;
			horas++;
		}
	}
}

void MandaRelogio(void){ //podia mandar em HEX -> Sim, mas como tamo em string fica mais bonito
	char r[14];

    r[0]=  (mes/10) + 48;
    r[1]=  (mes%10) + 48;
    r[2] ='/';
    r[3]=  (dia/10) + 48;
    r[4]=  (dia%10) + 48;
    r[5]=' ';

    r[6]=  (horas/10) + 48;
    r[7]=  (horas%10) + 48;
    r[8]=':';
    r[9]=  (minutos/10) + 48;
    r[10]=  (minutos%10) + 48;
    r[11]=':';
    r[12]=  (segundos/10) + 48;
    r[13]=  (segundos%10) + 48;
    USART_putstring(r,14);
}


void Server_FechaSessao(void){
    TelaInicial();
    EncerraSessao();
    LIBERA=0;
    USART_putstring("PX",2);
}

char Server_Horas(void){
    return(horas);
}