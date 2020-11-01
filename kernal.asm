;kernal.asm
BITS 32
extern ycyOS
;extern init_sys

section .text
global _start
;global print
;global clear_screen
_start:
mov ax,0x10
mov ds,ax

mov ax,0x20
mov ss,ax

xor esp,esp
mov esp,0x7000
mov ebp,esp
call setINT
;call init_sys

xor edi,edi

push 0x10
call ycyOS

jmp $


;set8259A
setINT:

;initialise 8259A
;ICW1
;edge trigger
;ICW4 required
;more than 1 8259A
mov al,0x11
out 0x20,al
;out 0xa0,al

;ICW2
;intel keep 0-31 int themself
;therefore we replace hardware interrupt from 32-47
;which is 0x20->0x2f,0b00100xxx->0b00101xxx
;xxx will be automatically filled,we only need to specify the start address
mov al,0x20
out 0x21,al
;mov al,0x28
;out 0xa1,al

;ICW3
;set priority
mov al,0x04
out 0x21,al
;mov al,0x02
;out 0xa1,al

;ICW4
mov al,0x01
out 0x21,al
;out 0xa1,al

;slave 8259A
mov al,0x11 ;ICW1
out 0xa0,al
mov al,0x28 ;ICW2
out 0xa1,al
mov al,0x02 ;ICW3
out 0xa1,al
mov al,0x01 ;ICW4
out 0xa1,al 

mov al,0xFD
out 0x21,al

ret
