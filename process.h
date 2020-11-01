
enum ProcStatus
{
	KILLED = 0,
	RUNNING,
	READY,
	BLOCKED
}
/*
 * I've been thinking 
 * that these information should be stored in memory space of process 
 * instead of in process list in kernal
struct Context
{
//When process running, it should not change segment register
//therefore, thre is no need to save them
	int eip;
	int eax;
	int ebx;
	int ecx;
	int edx;
	int esi;
	int edi;
	int esp;
	int ebp;
}
*/
unsigned int exist_process = 0;
struct Process
{
	unsigned int pid;
	enum ProcStatus status;
	struct Context context;
	char* mem_start;
	unsigned int mem_size;//byte count
};

struct Process ready_list[20];
int create_process(char* code_start);
void run_process(int id);
