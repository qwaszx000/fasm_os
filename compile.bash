#!/bin/bash

fasm src/boot.asm boot.bin
fasm src/kernel.asm kernel.bin
fasm src/os.asm os.img
rm -f boot.bin kernel.bin