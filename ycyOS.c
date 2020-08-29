
extern int print(char* str,int len);
extern void clear_screen();
int Cprint(char* mssg,int len)
{
	print(mssg,len);
	return 0;
}

void ycyOS(int status)
{
	clear_screen();
	char* mssg = "Welcome to ycyOS!";
	Cprint(mssg,status);
}
