#include "interrupt.h"
//#include "process.h"

extern int print(char *str,int len,int pos);

int Cprint(char* mssg,int len,int px,int py)
{
        //80 charactor per line
        //px represents column
        //py represents row
        int pos = px+80*py;
        print(mssg,len,pos);
        return 0;
}


