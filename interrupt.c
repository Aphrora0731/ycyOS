#include "interrupt.h"

//User application request a system call
//System call contains interrupt handlers
//struct KeyboardBuffer KB_Table = {0x38,0x7e00,0} ;

int provoke_int(int int_number)
{
	if(int_number <= 31)return -1;
	int_number -= 32;
	//enble keyboard interrupt	
	asm("sti;"
	    "movb $0xFD,%%al;"
	    "out %%al,$0x21;"
	    :
	    :
	   );
	asm("hlt");
	//asm("int $0x21");

	asm("movb $0x20,%%al;"
	    "out %%al,$0x20;"
	    :
	    :
	   );
	return 0;
}

int enable_clk()
{	//try to save kernal process state before enable clk int
	//asm("mov %%esp,%0;"
	//	:"=r"(old_esp)
	//	:
	//   );
	asm("sti;"
	    "movb $0xFE,%%al;"
	    "out %%al,$0x21;"
	    :
	    :
	   );
}
void kb_int(char scan_code)
{
	//in printable_ch table
	//the i-th element is the ascii code for scan code i
	int offset = (int)scan_code;
	if(offset > 0x36)return;//seems theese charactor aren't supported yet
	offset %= 0x80;//press and release
	char ascii = 'A';
	ascii = printable_ch[offset];
	ch_in(ascii);//write to keyboard buffer
}
void ch_in(char ascii)
{
	//KB_BUF.front is next to KB_BUF.rear,buffer is full
	//discard new input
	if((KB_BUF.rear+1)%KB_SIZE == KB_BUF.front)
	{
		return;
	}

	//buffer not full
	KB_BUF.buffer[KB_BUF.rear] = ascii;
	KB_BUF.rear++;
	KB_BUF.rear %= KB_SIZE;
}

char ch_out()
{
	if(KB_BUF.front == KB_BUF.rear)//empty buffer
	{
		return '\0';
	}
	//not empty
	int return_index = KB_BUF.front;
	KB_BUF.front++;
	KB_BUF.front %= KB_SIZE;
	return KB_BUF.buffer[return_index];
}

char read_ch()
{
	return ch_out();
}


int create_process(int (*proc)())
{
	//cannot simply leave context on stack by pushing
	//which will ruin the stack frame
	//cause function cannot get proper return address
	//I think it's better to create another stack frame
	asm(
		"mov %%esp,%%esi;"	
		"mov $0x6000,%%esp;"
		"sti;"
		"pushf;"
		"cli;"
		"push  $0x8;"
		"push %0;"
		"pusha"
		 :
		 :"m"(proc)
	   );//should save eflags cs selector and eip of proc
	asm(
		"mov %%esp,%0"
		:"=r"(old_esp)
		:
	   );//save esp for switch to
	asm(
		"mov %%esi,%%esp"
		:
		:
	   );
	return 0;

	//proc();
}

//most process schedule happened here
//accept present eps as argument
//before entering function body,switch to kernal stack
int clk_int(int esp)
{
//	if(clk++)return stack_frame[0]; //one esp
//	else return stack_frame[1];	//another esp
					//let's see if it saves 	
	int next_esp = old_esp;
	old_esp = esp;//save present esp
	return next_esp;
}



