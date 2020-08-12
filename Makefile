ycyOS.img:bootsect
	@dd if=bootsect of=ycyOS.img bs=512 count=1 conv=notrunc
	@mv ycyOS.img /home/ycy/Learn/ComputerScience/OperatingSystem/bochs-2.6.11
	@rm -f bootsect
bootsect:bootsect.s
	@nasm -f bin bootsect.s
.phony:clean

clean:
	@rm -f bootsect


