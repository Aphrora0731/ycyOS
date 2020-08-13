section .data
mssg db "hello,ycyOS!"
mssg_len equ $-mssg


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
mov dl,0
int 10h

int 80h
