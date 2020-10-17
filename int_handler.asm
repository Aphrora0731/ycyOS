BITS 32
extern kb_int
;CLK interrupt
[section .int20h]
int_20h:

mov byte [gs:esi],ch
;inc esi
mov byte [gs:esi],0x0D
;inc esi
inc cx
mov al,0x20
out 0x20,al
out 0xa0,al
iret

times 0x100-($-$$) db 0 ;save 256 bytes for every int-handler

;keyboard interrupt
[section .int21h]
int_21h:
push es
mov ax,0x18
mov es,ax
xor eax,eax

;read keyboard input
;.loop:
in al,0x60
;cmp al,0xfa
;jz .loop

push eax
call kb_int
;mov byte [es:edi],al
;inc edi
;mov byte [es:edi],0x0D
;inc edi
add esp,4
pop es
iret

times 0x100-($-$$) db 0
