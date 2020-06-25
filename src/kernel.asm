format binary
org 0x500
use32

protected_start:
	;setup segment registers
	mov ax,0x10
	mov ds,ax;Data segment = code segment

	mov es,ax;Second data segment
	mov fs,ax;Third data segment
	mov gs,ax;4 data segment

	mov ss,ax;Stack segment

	mov esp,0x90000;Stack end pointer
	mov ebp,0x50000;Stack base pointer

	;mov ax,0x12
	;mov edi,0xB8000

	pusha
	lidt [IDTR]
	popa

	;============Prepare=============
	
	call setup_pic
	;call bruteCheckPCI
	
	mov al, 25
	call print_dec_byte
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
numStr_buf db 8 DUP(0);8 bytes
console_pointer dw 0

times 1024-($-$$) db 0;2 sectors