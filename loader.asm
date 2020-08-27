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

code_seg	 dw 0x07FF
		 dw 0x8800
		 db 0x00
		 db 0x9a
		 db 0xc0
		 db 0x00
	
data_seg dw 0x07FF,0x8800
	 db 0x00,0x92,0xc0,0x00
vmem_seg dw 0x7FFF,0x8000
	 db 0x0B,0x92,0x50,0x00	
stac_seg dw 0x07FF,0x7c00
	 db 0x00,0x96,0x40,0x00
gdt_len equ $-null_seg


gdt_ptr dw  0x00FF
	dd  0x00008050 ;by magic,do not change the file
	
idt_ptr	dw 0x0000,0x0000,0x0000  
	


section .text
global _start
_start:
;set cursor
mov ah,02h
mov bh,0
mov dx,50h
int 10h

mov ax,mssg
mov bp,ax
mov cx,mssg_len
mov ax,1301h
mov bx,000ah
mov dx,0300h
int 10h

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



jmp 0x0008:0


