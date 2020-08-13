org 0x7c00

mov ax, cs
mov ds, ax
mov es, ax
call main

;main code
;display a string
main:
;clear the screen
mov ah,07h
mov al,0h
mov cx,0x0000
mov dx,0x144a
int 10h
;set cursor

mov ah,02h
mov bh,0
mov dh,4h
mov dl,0h
int 10h

;print string
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

read_disk:
;read OS into memory
mov dx,0000h	
mov cx,0002h	;0th cylinder 2nd sector
mov ax,0x0800
mov es,ax	;load OS at seg 0x0800
mov bx,0        ;es:bx points to where to load
		;get more information from BIOS IVT
mov ax,0204h	;read 4(ah)sectors

int 13h

jnc OS
jmp read_disk

OS:
;read OS successsfully
;authorise OS

mov ah,02h
mov bh,0
mov dh,5h
mov dl,0h
int 10h

;print string
mov ax,jmp_mssg
mov bp,ax
;load the start of mssg in bp for later print
mov cx,jmp_len
;load the length of the mssg
mov ax,01301h
;set print format
mov bx,000dh
mov dl,0
;set cursor's position
int 10h

jmp 0x0800:0x0000

ret

mssg db "hello,ycy!"
mssg_len equ $-mssg
jmp_mssg db "bye,I'm jmp to OS!"
jmp_len equ $-jmp_mssg
times 510-($-$$) db 0
dw 0xaa55
