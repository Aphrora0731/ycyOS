
extern old_esp;
enum ProcState
{
	KILLED = 0,
	RUNNING,
	READY,
	BLOCKED
};

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
	enum ProcState state;
	void* page_directory;	//load it in cr3
	int page_num;
	void (*code_start);
};

struct Process ready_list[20];
struct Process* create_process(struct Process* proc);
void run_process(int id);
