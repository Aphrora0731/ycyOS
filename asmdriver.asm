%include "int_handler.asm"
;extern int_21h

section .data
idtr dw 0,0,0
idt_base dd 0


section .text

global print
global clear_screen
global init_sys
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
;call init_data
;address of int_handler,2th parameter
;question is
;how to produce an interrupt descriptor based on parameter in eax
;and put it into appropriate position

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
pop ebx

leave
ret
