%include "int_handler.asm"
;extern int_21h

section .data
idtr dw 0,0,0
idt_base dd 0
gdtr dw 0,0,0
gdt_base dd 0
page_dirctory dd 0

section .text

global print
global clear_screen
global init_sys
global _setGDT
print:
push ebp
mov ebp,esp
push edi
xor edi,edi
push esi
xor esi,esi

push ebx

;virtual memory start
mov eax,0x0018
mov gs,eax

mov ebx,[ebp+8]
;char* mark
;the offset of string with respect to ss regiester
;to get the offset with respect to ds,add the difference between ds and ss
;which is 0x7000-0x0000
;add ebx,0x7000
mov ecx,[ebp+12]
mov edi,[ebp+16]
shl edi,1
;int len

;local loop
.loop:
        mov byte al,[ebx+esi]
        mov byte [gs:edi],al
        inc edi
        mov byte [gs:edi],0x0D
        inc edi
        inc esi
        loop .loop

push ebx
pop esi
pop edi

leave
ret

clear_screen:
push ebp
mov ebp,esp

push edi
xor edi,edi
mov eax,0x0018
mov gs,eax

mov ecx,0x7fff

.loop:
        mov byte [gs:edi],0x00
        inc edi 
        loop .loop
pop edi

leave
ret

;put idtr and idt_base in variables
init_data:
push ebp
mov ebp,esp

sidt [idtr];load idtr in idtr
mov ebx,idtr;load address of idtr in ebx
mov eax,dword[ebx];eax stores base of IDT 
mov ebx,idt_base;ebx stores idt_base
mov dword[ebx],eax

leave
ret


init_sys:
push ebp
mov ebp,esp

push ebx

lea eax,[int_20h];store int_21h address in eax
mov ebx,0 ;store idt base in ebx(0x00)

mov dword [ebx+0x20*8],eax
mov dword [ebx+0x20*8+4],eax
;theoratically,21th Int Descriptor should be OFFSET|OFFSET
;by changing type and seg selector afterwards,we get a right descriptor
mov word [ebx+0x20*8+4],0x8e00
mov word [ebx+0x20*8+2],0x0008


lea eax,[int_21h];store int_21h address in eax
mov ebx,0 ;store idt base in ebx(0x00)

mov dword [ebx+0x21*8],eax
mov dword [ebx+0x21*8+4],eax
;theoratically,21th Int Descriptor should be OFFSET|OFFSET
;by changing type and seg selector afterwards,we get a right descriptor
mov word [ebx+0x21*8+4],0x8e00
mov word [ebx+0x21*8+2],0x0008

;enable page here,we need to
;1.set page directory(at 1M == 0x10 0000)
;2.set page tables (at 1M+4K == 0x10 1000)
push edi
xor ecx,ecx
xor edi,edi

;One PDE represents one page table(4KB),which contains 1024 pages,
;referencing 4M bytes memory
;first page dirctory entry:
;0x00200 007
;  BASE  TYPE
;BASE = 2M    
mov edi,0x001FF000 ;page directory starts at 2M-4KB 
mov eax,0x00200007 ;first PDE(referenced a PT) starts at 2M
mov [edi],eax	 ;		31..12  11..0

mov edi,0x00200000 ;start of first page table(2M) 
mov eax,0x00000007
mov ecx,1024	   ;1024 PTE(one referencing one page) to initialise

.init_page_table:
mov [edi],eax
add eax,0x1000	   ;4KB a page,base of entry grows 4KB each by each
add edi,4	   ;4 bytes each entry
loop .init_page_table


;[ ... |PD|PT1|PT2...PT511]
;[ 1M  pg0 pg1 pg2 pg
;now pg0(start at 2M )should be a page table that indexes first 4M memory

mov ecx,0x7FC00 ;rest memory(2048M-4M) for user,need 0x80000-1024 PTE
sub eax,1	;clear present bit
.init_usr_table:
mov [edi],eax
add eax,0x1000
add edi,4
loop .init_usr_table	

mov eax,0x001FF000 ;stores base of page directory(0x0010 0000 = 1M)
mov cr3,eax	   ;load page directory base in cr3

mov eax,cr0
or eax,0x80000000
mov cr0,eax	   ;set BIT 31 of cr0,enable paging


pop edi	
pop ebx

leave
ret

_setGDT:
push ebp
mov ebp,esp

push edi
push eax
xor edi,edi

sgdt [gdtr] 
lea eax,[gdtr]  ;eax is the address of first byte of gdtr
add eax,2	;gdtr = [base base base base |limit limit]	     	
		;			^now	    ^byte eax point to before

;this part put base of GDT(its address stores in eax)into edi
;and get offset of descriptor from stack,add things up to form the address
;of descriptor
mov edi,[eax]   ;mov value in address eax stores into edi,edi now is base of gdt
mov eax,edi     ;eax now stores the base of gdt
mov edi,[ebp+8]	;first argument is offset with respect to gdt start
add edi,eax	;add offset(edi) and base(eax),edi is the address of descriptor

mov eax,[ebp+12];second argument is low 32 bit
mov [edi],eax

add edi,4
mov eax,[ebp+16];high 32 bit
mov [edi],eax

pop eax
pop edi

leave
ret
