;set GDT & IDT
;turn on A20 line
;save parameters(why?)
;jump to protect mode
;(transform authorty to kernal code written and running in protec mode)

section .data
mssg db "hello,ycyLoader!"
mssg_len equ $-mssg
;THERE IS A CODE SEG start at 0x8800 with size of 8Mb
;first discriptor is not used, I'm not sure if it's a legal way to set to zero
null_seg dw 0,0,0,0

code_seg dw 0xFFFF,0x0000
	 db 0x00,0x9a,0xc0,0x00
data_seg dw 0xFFFF,0x0000
	 db 0x00,0x92,0xc0,0x00
vmem_seg dw 0x7FFF,0x8000
	 db 0x0B,0x92,0x50,0x00	
stac_seg dw 0xFFFF,0x0000
	 db 0x00,0x93,0x40,0x00
intt_seg dw 0xFFFF,0x0000
	 db 0x00,0x92,0xc0,0x01
inth_seg dw 0xFFFF,0x0000
	 db 0x00,0x9a,0xc0,0x01
kbd_buff dw 0x0200,0x7c00
	 db 0x00,0x92,0x40,0x00
times 0xfc-$+null_seg db 0
gdt_len equ $-null_seg


int0h dd 0x00300000
      dd 0x00008e00

int_table resq 31
;time interrupt
int20h dd 0x00300000
       dd 0x00008e00
;keyboard interrupt
int21h dd 0x00300100
       dd 0x00008e00
	
reserved_int resq 0x5e

gdt_ptr dw  0x00FF
	dd  0x00008050 ;by magic,do not change the file
	
idt_ptr	dd 0x000000000400


section .text
global _start
_start:
push es
mov ax,cs
mov ds,ax


xor esi,esi
xor edi,edi
mov ax,int0h
mov si,ax

mov ax,0x00
mov es,ax

mov ecx,0x400;0x400 byte

rep movsb
pop es
cli ;disable interupt

mov ax,es
mov ds,ax

lgdt [gdt_ptr]
lidt [idt_ptr]

;open A20
in al,0x92
or al,2
out 0x92,al

;open cr0
mov eax,cr0
or al,1
mov cr0,eax



jmp 0x0008:0x8800


