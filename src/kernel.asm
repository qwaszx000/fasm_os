format binary
org 0x500
use32

protected_start:
	;setup segment registers
	mov ax,0x10;data segment = 0x10 - see gdt.asm
	mov ds, ax

	mov es,ax;Second data segment
	mov fs,ax;Third data segment
	mov gs,ax;4 data segment

	mov ss,ax;Stack segment

	mov esp,0x90000;Stack end pointer
	mov ebp, esp;Stack base pointer ;mov ebp, 0x50000
	;stack grows in reverse direction
	;i.e: esp grows from 0x90000 to 0x8FFE0, then from 0x8FFE0 to ...

	;mov ax,0x12
	;mov edi,0xB8000

	pusha
	lidt [IDTR]
	popa

	;============Prepare=============
	
	call setup_pic
	call bruteCheckPCI

	;mov eax, test_string
	;call print
	
	;mov eax, 0xffffffff
	;call print_hex
	;===================================
main_cicle:
	hlt
	jmp main_cicle


include "inc/kernel_setup/controllers/pic.asm"
include "inc/kernel_setup/controllers/keyboard.asm"
include "inc/kernel_setup/controllers/pci.asm"
include "inc/kernel_setup/tables/idt.asm";load idt table and interrupt handlers

include "inc/std/stdlib.asm"	;load stdio lib
include "inc/std/stdio.asm"	;load stdio lib


test_string db 'hello', 0
numStr_buf db 11 DUP(0);4,294,967,295 - max 32 bits uint = 10 chars + '\0' char = 11
console_pointer dw 0

times 1536-($-$$) db 0;3 sectors 512*3