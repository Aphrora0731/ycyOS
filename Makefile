ycyOS.img:bootsect loader Chernal
	@dd if=bootsect of=ycyOS.img bs=512 count=1 conv=notrunc
	@dd if=loader of=ycyOS.img bs=512 count=4 seek=1 conv=notrunc
	@dd if=Chernal of=ycyOS.img bs=512 count=20 seek=5 conv=notrunc
	@mv ycyOS.img /home/ycy/Learn/ComputerScience/OperatingSystem/bochs-2.6.11
	
bootsect:bootsect.asm
	@nasm -f bin bootsect.asm

loader:loader.asm
	@nasm -f bin loader.asm

kernal:kernal.asm
	@nasm -f bin kernal.asm

Chernal:kernal.o ycyOS.o
	ld -lc -s -m elf_i386 -static -o Chernal.o kernal.o ycyOS.o -static
	objcopy -O binary -j .text -j .rodata Chernal.o Chernal

kernal.o:kernal.asm
	nasm -f elf32 -o kernal.o kernal.asm

ycyOS.o:ycyOS.c
	gcc -m32 -o ycyOS.o -c ycyOS.c

.phony:clean

clean:
	@rm -f bootsect
	@rm -f kernal
	@rm -f loader
	@rm -f kernal.o
	@rm -f ycyOS.o
	@rm -f Chernal
	@rm -f Chernal.o
