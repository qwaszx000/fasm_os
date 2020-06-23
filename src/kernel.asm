format binary
org 0x500
use16

;Prepare to jmp to protected mode
cli
lgdt [gdt]

in al, 0x70		;
or al, 0x80		; A20
out 0x70, al	;

mov eax, cr0
or al, 1
mov cr0, eax

jmp 0x08:protected_start

;;;;;;;;;;;;;;;;;;;PROTECTED MODE;;;;;;;;;;;;;;;;;;;;;;;;;;
use32
protected_start:
	mov ax,0x10
	mov ds,ax;Data segment = code segment

	mov es,ax;Second data segment
	mov fs,ax;Third data segment
	mov gs,ax;4 data segment

	mov ss,ax;Stack segment

	;mov ax,0x12

	;mov edi,0xB8000

	mov esp,0x90000;Stack end pointer
	mov ebp,0x50000;Stack base pointer

	pusha
	lidt [IDTR]
	popa

	;============PIC==============
	push ax

	mov al, 0x11
	out 0x20, al;Start setting pic
	out 0xA0, al

	mov al,0x20;Master offset
	out 0x21, al
	mov al, 0x28;Slave offset
	out 0xA1, al

	mov al, 4
	out 0x21, al
	mov al, 2
	out 0xA1, al

	mov al, 0x1
	out 0x21, al
	out 0xA1, al

	;mov al, 0x00
	xor al, al ;0x00
	out 0x21, al
	out 0xA1, al

	pop ax
	sti
	
	;============Keyboard controller setup============
	;push eax
	;mov al, 0x20
	;out 0x64, al;Read configuration command
	;in al, 0x60
	;btr ax, 6;Set translation bit to 0
	;push ax;Configuration in stack

	;mov al, 0x60;Send configuration byte command
	;out 0x64, al

	;pop ax;Configuration in ax(al)
	;out 0x60, al;Send configuration
	;pop eax
	;=============PCI==================
	;https://wiki.osdev.org/PCI

	;============TEST=============
	;int 0Fh;15

	push 5
	push test_string
	call print
	
	;push 'h'
	;call putc
	;int 0fh
	;===================================
main_cicle:
	sti
	hlt
	jmp main_cicle


include "inc/tables/gdt_idt.asm";load gdt and idt tables and interrupt handlers
include "inc/stdio/stdio.asm"	;load stdio lib

test_string db 'hello', 0
times 1024-($-$$) db 0;2 sectors