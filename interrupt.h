#define KB_SIZE 16

#define ESC 0x01
#define BACKSPACE 0x0e
#define LEFTCONTROL 0x1d
#define LEFTSHIFT 0x2a
#define RIGHTSHIFT 0x36
//scan code should be an array of string
//return value of kb_int(asm) is the offset
//put scan_code[return_value] into KB_BUFF
static char printable_ch[] = {
	' ',' ','1','2','3','4','5','6','7','8',
	'9','0','-','=','\b','\t',
	'Q','W','E','R','T','Y','U','I','O','P',
	'[',']','\r',' ','A','S',
	'D','F','G','H','J','K','L',';','\'','`',
	' ','\\','Z','X','C','V',
	'B','N','M',',','.'
};




/*
 *array start[end-start] is a subset of buffer,
 *which restores those charactor just input but not been handled
 * 
 */
static struct KeyboardBuffer
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
int init_KB_Table();
void kb_int(char scan_code);
char read_ch();
