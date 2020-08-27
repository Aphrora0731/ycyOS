BITS 32

extern Cprint

section .text
global _start
global print
_start:
mov ax,0x10
mov ds,ax

mov ax,0x20
mov ss,ax

push 0x0e
call Cprint

jmp $

;print affect register EAX(return),ECX,GS
print:
push ebp
mov ebp,esp
push edi
xor edi,edi
push esi
xor esi,esi

;virtual memory start
mov eax,0x0018
mov gs,eax

mov ebx,[ebp+8]
;char* mark
mov ecx,[ebp+12]
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

					;mov byte [gs:0x06],'M'
					;mov byte [gs:0x07],0x0D
pop esi
pop edi

leave
ret


