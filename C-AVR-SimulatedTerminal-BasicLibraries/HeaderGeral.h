/*
 * IncFile1.h
 *
 * Created: 12/05/2019 12:33:16
 *  Author: GiovaniMerlin e DanielWellington
 */ 

#define BAUD 19200
#define F_CPU 16000000UL
#define BUFFER_SIZE 60

#ifndef INCFILE1_H_
#define INCFILE1_H_

void delay_1ms(void);
void delay_ms(unsigned short c);
void LCD_clear(void);
void LCD_comando(char cmd);
void LCD_putchar(char a);
void LCD_config (void);
void LCD_posicao(unsigned char x, unsigned char y);
void LCD_escreve(char const *a);
int Server_Receive(char *c,int pos);
void USART_init(void);
void USART_putstring(char str[], int size);
char Le_teclado(void);
void Init_Teclado(void);
void TelaInicial(void);
int Login(void);
void Server_Login(void);
void BloqueiaTerminal(void);
void LiberaTerminal(void);
void Server_Menu(void);
void PrintaBuffer(void); //debugg
void PrintaUser(void); //debugg
void IniciaRelogio(void);
void ContaRelogio(void);
void MandaRelogio(void);
void Server_FechaSessao(void);
void EncerraSessao(void);
void ZeraWatch(void);
char Server_Horas(void);
#endif /* INCFILE1_H_ */