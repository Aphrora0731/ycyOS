ycyOS.img:bootsect loader Chernal 
	@dd if=bootsect of=ycyOS.img bs=512 count=1 conv=notrunc
	@dd if=loader of=ycyOS.img bs=512 count=4 seek=1 conv=notrunc
	@dd if=Chernal of=ycyOS.img bs=512 count=40 seek=5 conv=notrunc
	@mv ycyOS.img /home/ycy/Learn/ComputerScience/OperatingSystem/bochs-2.6.11
	
bootsect:bootsect.asm
	@nasm -f bin bootsect.asm

loader:loader.asm
	@nasm -f bin loader.asm

Chernal:kernal.o ycyOS.o interrupt.o asmdriver.o
	ld -lc -m elf_i386 -o Chernal.o kernal.o ycyOS.o interrupt.o asmdriver.o -static -Ttext 0x8800 
	objcopy -O binary -j .text -j .rodata -j .int20h -j .int21h -j .data Chernal.o Chernal

kernal.o:kernal.asm
	@nasm -f elf32 -o kernal.o kernal.asm

ycyOS.o:ycyOS.c interrupt.o
	@gcc -m32 -o ycyOS.o -c ycyOS.c -g -fno-stack-protector

interrupt.o:interrupt.c
	@gcc -m32 -o interrupt.o -c interrupt.c -g

asmdriver.o:asmdriver.asm int_handler.o
	@nasm -f elf32 -o asmdriver.o asmdriver.asm

mycyOS.o:ycyOS.o asmdriver.o interrupt.o
	ld -m elf_i386 -static -o mycyOS.o interrutp.o ycyOS.o asmdriver.o --entry ycyOS -r 

int_handler.o:int_handler.asm
	@nasm -f elf32 -o int_handler.o int_handler.asm

.phony:run

run:ycyOS.img
	@make clean
	@bochs -f ../bochs-2.6.11/bochsrc.txt -q
	
.phony:GUI_run

GUI_run:ycyOS.img
	@make clean
	@bochs -f ../bochs-2.6.11/bochsrcGUI.txt -q


.phony:clean

clean:
	@rm -f bootsect
	@rm -f kernal
	@rm -f loader
	@rm -f Chernal
	@rm -f int_handler
	@rm -f *.o
