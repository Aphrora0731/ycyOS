//memory.h
/*
 * It turns out we may need two types data structure to handle our memory space.
 * One for software level to tell kernel which space has been used,
 * another one for hardware level to tell CPU where's page directory or page tables. 
 * WTF!
 */

#include <stddef.h>

#define SYS_PAGE_NUM 0X80000

typedef int Page;

int isUsed(int PTE);//return 1 if page referenced by PTE is used,return 0 if not used
int use_page(int PTE);  //set present bit of PTE
int release_page(int PTE); //clear present bit of PTE


//allocate pages in memory
//return a pointer to page directory
void* create_mm(int page_num);

//return PDE/PTE generated by base address
int init_PDE(int* PT_address);
int init_PTE(int* PG_address);
