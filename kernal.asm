BITS 32

;extern Cprint

section .text
global _start
_start:

mov eax,0x0018

mov ds,eax
mov gs,eax



mov byte [gs:0x00],'N'
mov byte [gs:0x01],0x0F

mov byte [gs:0x02],'A'
mov byte [gs:0x03],0x0D

mov byte [gs:0x04],'S'
mov byte [gs:0x05],0x0D

mov byte [gs:0x06],'M'
mov byte [gs:0x07],0x0D

mov eax,0x1234
;call Cprint



jmp $

