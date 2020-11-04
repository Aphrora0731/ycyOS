
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
struct TSS
{
	int pre_link,esp0,ss0,esp1,ss1,esp2,ss2,cr3;
	int eip,eflags,eax,ecx,edx,ebx,esp,ebp,esi,edi;
	int es,cs,ss,ds,fs,gs;
	int ldtr,iomap;
}task_state = {};

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
