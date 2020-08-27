extern int print(char* str,int len);

int Cprint(int len)
{
	char *mark="This is a mark\0";	
	print(mark,len);
	return 0;
}

