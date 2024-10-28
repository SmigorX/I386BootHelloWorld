all: build

build:
	nasm boot.asm -f bin -o boot.bin
	qemu-system-i386 -drive format=raw,file=boot.bin

.PHONY: all build
