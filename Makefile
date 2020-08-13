ycyOS.img:bootsect kernal
	@dd if=bootsect of=ycyOS.img bs=512 count=1 conv=notrunc
	@dd if=kernal of=ycyOS.img bs=512 count=4 seek=1
	@mv ycyOS.img /home/ycy/Learn/ComputerScience/OperatingSystem/bochs-2.6.11
	
bootsect:bootsect.s
	@nasm -f bin bootsect.s


kernal:kernal.s
	@nasm -f bin kernal.s
.phony:clean

clean:
	@rm -f bootsect


