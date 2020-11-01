#include "ycystd.h"


extern void clear_screen();
extern void init_sys();

int proc1()
{
	//print a line,determine system are running the process
	//then entering a dead loop
	//if mssg is only printed once,we are not exit proc1
	char *mssg = "proc1\n";
	Cprint(mssg,6,0,0);
	Cprint(mssg,6,0,1);
	return 0;//only exit position
}

int proc2()
{
	//if success_mssg is printed,proc switch is working
	char *success_mssg = "hello ycy!";
	Cprint(success_mssg,10,0,3);
	return 0;
}
void ycyOS(int status)
{	
	clear_screen();
	init_sys();

	create_process(proc1);
	enable_clk();
	//create_process defined in interrupt.h
	//instantiate in interrupt.c
	//create_process(proc1);
	proc2();
	while(1){}	
	//create_process(proc2);
	/*
	 * print module test
	char mssg[80] = "0123456789";
	int i = 0;
	while(1)
	{
		enable_int(0x21);
		char input = read_ch();
		if( input != '\0')
		{
			mssg[i] = input;
			Cprint(&input,1,i,0);
			i++;
			if(i == 80 )break;
		}
	}
	Cprint(mssg,80,0,1);
	*/
}

