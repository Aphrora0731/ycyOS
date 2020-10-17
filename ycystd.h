char inbyte(int port);
void outbyte(int port,int value);

/*
 *head is first char not handled
 *end is where to put new char from keyboard
 *
 */
typedef struct kb_buffer
{
	//point to first char of buffer
	char* head;
	//point to the next char of the last char in buffer
	char* end; 
	//512 bytes
	const int size = 512;
	char buffer[512];
}
