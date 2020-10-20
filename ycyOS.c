#include "interrupt.h"


extern int print(char* str,int len,int pos);
extern void clear_screen();
extern void init_sys();
int Cprint(char* mssg,int len,int px)
{
	print(mssg,len,px);
	return 0;
}

void ycyOS(int status)
{	
	clear_screen();
	init_sys();
	char mssg[10] = "0123456789";
	int i = 0;
	while(1)
	{
		provoke_int(33);
		char input = read_ch();
		if( input != '\0')
		{
			mssg[i] = input;
			Cprint(&input,1,i);
			i++;
			if(i == 10 )break;
					}
		//Cprint(&input,1,i);
	}
	Cprint(mssg,10,12);
	//char* mssg = "Welcome to ycyOS!";
	//Cprint(mssg,status);
}

