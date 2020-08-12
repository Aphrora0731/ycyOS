org 0x7c00

mov ax, cs
mov ds, ax
mov es, ax
call main

;main code
;display a string
main:
mov ah,02h
mov bh,0
mov dh,4h
mov dl,4h
int 10h
;set cursor

mov ax,mssg
mov bp,ax
;load the start of mssg in bp for later print
mov cx,mssg_len
;load the length of the mssg
mov ax,01301h
;set print format
mov bx,000dh
mov dl,0
;set cursor's position
int 10h
ret

mssg db "hello,ycy!"
mssg_len equ $-mssg
times 510-($-$$) db 0
dw 0xaa55
