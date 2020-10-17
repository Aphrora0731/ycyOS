#include "interrupt.h"

//User application request a system call
//System call contains interrupt handlers
//struct KeyboardBuffer KB_Table = {0x38,0x7e00,0} ;

int provoke_int(int int_number)
{
	if(int_number <= 31)return -1;
	int_number -= 32;
	int (*int_ptr)(int);
	//enble keyboard interrupt	
	asm("sti;"
	    "movb $0xFD,%%al;"
	    "out %%al,$0x21;"
	    :
	    :
	   );
	asm("int $0x21");

	asm("movb $0x20,%%al;"
	    "out %%al,$0x20;"
	    :
	    :
	   );
	return 0;
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
