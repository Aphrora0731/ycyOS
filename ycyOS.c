#include "interrupt.h"


extern int print(char* str,int len);
extern void clear_screen();
extern void init_sys();
int Cprint(char* mssg,int len)
{
	print(mssg,len);
	return 0;
}

void ycyOS(int status)
{	
	clear_screen();
	init_sys();
	while(1)
	{
		provoke_int(33);
		char input = read_ch();
		Cprint(&input,1);
	}
	char* mssg = "Welcome to ycyOS!";
	Cprint(mssg,status);
}

