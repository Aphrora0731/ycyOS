#define KB_SIZE 16

#define ESC 0x01
#define BACKSPACE 0x0e
#define LEFTCONTROL 0x1d
#define LEFTSHIFT 0x2a
#define RIGHTSHIFT 0x36

#define PRINTABLE_NUM sizeof(printable_ch)/sizeof(char)

int switch_condition = 0;//temporary condition for clk_int() test
int old_esp = 0x12345678;
//scan code should be an array of string
//return value of kb_int(asm) is the offset
//put scan_code[return_value] into KB_BUFF
char printable_ch[] = {
	' ',' ','1','2','3','4','5','6','7','8',
	'9','0','-','=','\b','\t',
	'Q','W','E','R','T','Z','U','I','O','P',
	'[',']','\r',' ','A','S',
	'D','F','G','H','J','K','L',';','\'','`',
	' ','\\','Y','X','C','V',
	'B','N','M',',','.'
};




/*
 *array start[end-start] is a subset of buffer,
 *which restores those charactor just input but not been handled
 * 
 */
struct KeyboardBuffer
{
	char buffer[KB_SIZE];
	int front;//Next charactor to handle
	int rear;//Latest charactor
	int count;
}KB_BUF = {{0},0,0,0};

void ch_in(char);
char ch_out();
char KBF_front();
char KBF_rear();


int provoke_int(int int_number);
//int init_KB_Table();
void kb_int(char scan_code);
char read_ch();


struct TSS
{
	int pre_task,esp0,ss0,esp1,ss1,esp2,ss2;
	int cr3;
	int eip,eflags,eax,ecx,edx,ebx,esp,ebp,esi,edi;
	int es,cs,ss,ds,fs,gs;
	int ldtr,iomap;
};
int create_process(int (*proc)());
int clk_int();



