int section_data = 0;
const int section_bss = 13;
char* string_data = "hello,ycy.";

int foo(int a)
{
	a++;
	return a;
}
int main()
{
	int a = foo(section_data);
	char ch = string_data[3];
	return 0;
}
