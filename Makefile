build:
	fasm src/boot.asm boot.bin
	fasm src/kernel.asm kernel.bin
	fasm src/os.asm os.img
	rm -f boot.bin kernel.bin

run:
	bochs -f bochs.conf

build_run: build run