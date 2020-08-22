ycyOS.img:bootsect kernal loader
	@dd if=bootsect of=ycyOS.img bs=512 count=1 conv=notrunc
	@dd if=loader of=ycyOS.img bs=512 count=4 seek=1 conv=notrunc
	@dd if=kernal of=ycyOS.img bs=512 count=20 seek=5 conv=notrunc
	@mv ycyOS.img /home/ycy/Learn/ComputerScience/OperatingSystem/bochs-2.6.11
	
bootsect:bootsect.asm
	@nasm -f bin bootsect.asm

loader:loader.asm
	@nasm -f bin loader.asm

kernal:kernal.asm
	@nasm -f bin kernal.asm

.phony:clean

clean:
	@rm -f bootsect
	@rm -f kernal
	@rm -f loader
