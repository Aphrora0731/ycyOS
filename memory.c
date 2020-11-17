#include "memory.h"

//sys_page indexes the whole memory space(2048M / 4K = 0x8 0000 pages)
const Page* sys_page = 0x00101000;//

//considering all page should be initialised in asmdriver.asm
//this function seems no need to exist anymore.
 
void init_memory()
{
	return;
	int i;
	for(i=0;i<SYS_PAGE_NUM;i++)
	{	
		//512 pages(2M) used by kernel
		if(i<512)
		{
			use_page(sys_page[i]);
		}else
		{
			release_page(sys_page[i]);
		}
		//sys_page is initialised in asmdriver.asm,no need to init anymore
		//sys_page[i].page_base = 0x1000*i;
	}
	return;
}


/* 
 * There are 3 types of array needs to be indexed:sys_page,PD and PT
 * we need to know where we've found when searching available system page
 * we need to know next PDE to init(if we need to)
 * we need to know next PTE to init
 * 
 * we search sys_page in order,when finding a free page:
 * 	if it's our first page,take it as our PD
 * 	(theretically we need to check if we need more PD,
 * 	but our memory space is too small to have more than one page directory.
 * 	And we are just create mm,we could add more space when we actually need them.
 * 	So there is no need to create very big memory space.)
 * 		else if it's our second page,take it as our first PT(PD[0])
 * 			else take it as normal page for loading process code and data.
 */
void* create_mm(int page_num)
{
	int* page_directory = NULL;
	int sys = 511;
	int usr = 0;
	for(;usr < page_num; usr++)
	{
		for(;sys < SYS_PAGE_NUM; sys++)
		{
			if(isUsed(sys_page[sys]))
			{
				//first allocated page is used to set page dirctory
				if(page_directory == NULL)
				{
					int page_base = sys_page[sys]/0x1000;
					page_directory = (int*)page_base;
					//kernel space start at 3G
					//all kernel space is indexed by page table located
					//at 0x101007
					page_directory[768] = init_PDE(0x200007);
					continue;
				}else
				{
					//second page is used to set page table(first PDE)
					if(usr == 1)
					{
						int page_base = sys_page[sys]/0x1000;
						page_directory[0] =
						       init_PDE((int*)page_base);
					}else//didn't consider more than one page table
					{
						int PT_base = page_directory[0];//first table
						PT_base /= 0x1000;//get PT base
						int* page_table = (int*)PT_base;
						int page_base = sys_page[sys]/0x1000;
						page_table[usr-2] = 
							init_PTE((int*)page_base);
					}
				}
			}
		}
	}

	return (void*)page_directory;
}

int init_PDE(int* base)
{
	base+=7;
	return base;
}
int init_PTE(int* base)
{
	return init_PDE(base);
}

int isUsed(int PTE)
{
	return PTE%2;
}

int use_page(int PTE)
{
	if(PTE%2)return 0;//present bit is set,page has been used already
	return ++PTE;
}

int release_page(int PTE)
{
	if(PTE%2)//present bit is set,page is used.
	{
		return --PTE;
	}
	return 0;
	//If 1th page in memory(start at phisical address 0)is released,this is a problem
	//but,you should never release that page,so there's no need to worry.
}
