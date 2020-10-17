#include "ycystd.h"
char inbyte(int port)
{
	char value;
	asm volatile(
			"in port,%%al ;"
			:"r="(value)
			:
			:"%eax"
		    );
	return value;

}
