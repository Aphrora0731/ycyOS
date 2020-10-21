#include "interrupt.h"


extern int print(char* str,int len,int pos);
extern void clear_screen();
extern void init_sys();
int Cprint(char* mssg,int len,int px,int py)
{
	//80 charactor per line
	//px represents column
	//py represents row
	int pos = px+80*py;
	print(mssg,len,pos);
	return 0;
}

void ycyOS(int status)
{	
	clear_screen();
	init_sys();
	char mssg[80] = "0123456789";
	int i = 0;
	while(1)
	{
		provoke_int(33);
		char input = read_ch();
		if( input != '\0')
		{
			mssg[i] = input;
			Cprint(&input,1,i,0);
			i++;
			if(i == 80 )break;
		}
		//Cprint(&input,1,i);
	}
	Cprint(mssg,80,0,1);
	//char* mssg = "Welcome to ycyOS!";
	//Cprint(mssg,status);
}

