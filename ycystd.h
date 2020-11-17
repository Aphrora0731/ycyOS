
extern int print(char *str,int len,int pos);
extern void _setGDT(int index,int low32,int high32);
int Cprint(char* mssg,int len,int px,int py)
{
        //80 charactor per line
        //px represents column
        //py represents row
        int pos = px+80*py;
        print(mssg,len,pos);
        return 0;
}

void setGDT(int index,void* base,int limit,int type1,int type2)
{
	int _base = (int)base;
	int base00_15 = _base%0x10000;
	_base/=0x10000;
	int base16_23 = _base%0x100;
	_base/=0x100;
	int base24_31 = _base;
	int limit00_15 = limit%0x10000;
	int limit16_19 = limit/0x10000;
	
	index *= 0x08;
	int low32 = limit00_15 + base00_15*0x10000;
	int high32 = base16_23 + type1*0x100 + limit16_19*0x10000
	       	+ type2*0x100000 + base24_31*0x1000000;
	_setGDT(index,low32,high32);
}
