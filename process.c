#include "process.h"

struct Process* create_process(struct Process* proc)
{
	proc->page_directory = create_mm(3);	
	set_stack(proc);
	proc->state = READY;
	return proc;
}

//following code seems have some problems
//it could have use a local variable to temporarily save present esp 
//instead of using register esi

//create a new stack for proc
//save new stack in variable old_esp
//recover old stack
int set_stack(int (*proc)())
{
	 asm(
                "mov %%esp,%%esi;"
                "mov $0x6000,%%esp;"
                "sti;"
                "pushf;"
                "cli;"
                "push  $0x8;"
                "push %0;"
                "pusha"
                 :
                 :"m"(proc)
           );//should save eflags cs selector and eip of proc
        asm(
                "mov %%esp,%0"
                :"=r"(old_esp)
                :
           );//save esp for switch to
        asm(
                "mov %%esi,%%esp"
                :
                :
           );
        return 0;
}
