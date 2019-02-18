format binary
org 500h
use16

cli
lgdt [gdt]

in al, 70h;;
or al, 80h;; A20
out 70h, al;

mov eax, cr0
or al, 1
mov cr0, eax

jmp 08h:protected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;							  ;
;							  ;
use32
protected:
	mov ax,10h
	mov ds,ax;Data segment = code segment. like com prog
	mov es,ax;Second data secgment
	mov fs,ax;Third data segment
	mov gs,ax;4 data segment

	;mov ax,12h
	mov ss,ax;Stack segment

	;mov edi,0xB8000

	mov esp,90000h;Stack end pointer
	mov ebp,50000h;Stack base pointer

	pusha
	lidt [IDTR]
	popa

	;============PIC==============
	push ax

	mov al, 11h
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

	mov al, 00h
	out 0x21, al
	out 0xA1, al

	pop ax
	;=============================
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
	;=================TEST=============

	;=============PCI==================
	;https://wiki.osdev.org/PCI
	;==================================
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
;=========TABLES===============
use16
align 16

gdt_a:;global description table
	dq 0
	dw 0FFFFh, 0, 9A00h, 0CFh;Code - 8
	dw 0FFFFh, 0, 9200h, 08Fh;Data - 16
gdt:
	dw gdt-gdt_a
	dq gdt_a
use32
idt:;interrupts description table
;TODO: keyboard, timer and exceptions
; https://wiki.osdev.org/Interrupt_Vector_Table
	dw ((empty_exception_handler shl 0x30) shr 0x30);0 - Division By Zero
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dd 0,0;1 - reserved

	dw ((empty_exception_handler shl 0x30) shr 0x30);2 - NMI interrupt
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dd 0,0;3 - breakpoint

	dw ((empty_exception_handler shl 0x30) shr 0x30);4 - Overflow
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dw ((empty_exception_handler shl 0x30) shr 0x30);5 - BOUND
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dw ((empty_exception_handler shl 0x30) shr 0x30);6 - Invalid opcode
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dw ((empty_exception_handler shl 0x30) shr 0x30);7 - Device not awable
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dw ((empty_exception_handler shl 0x30) shr 0x30);8 - Double fault
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dd 0,0;9 - coprocessor segment overrun
	dd 0,0;10 - invalid TSS
	dd 0,0;11 - segment not present
	dd 0,0;12 - stack segment fault

	dw ((empty_exception_handler shl 0x30) shr 0x30);13 - general protection fault
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)
	dd 0,0;14 - page fault

	dw ((int_test shl 0x30) shr 0x30);15
	dw 0x8
	db 0
	db 010001110b
	dw (int_test shr 0x10)

	dd 0,0;16 - x87 FPU error
	dd 0,0;17 - Alignment check
	dd 0,0;18 - machine check
	dd 0,0;19 - SIMD floating point exception
	dd 0,0;20
	dd 0,0;21
	dd 0,0;22
	dd 0,0;23
	dd 0,0;24
	dd 0,0;25
	dd 0,0;26
	dd 0,0;27
	dd 0,0;28
	dd 0,0;29
	dd 0,0;30
	dd 0,0;31

	dw ((timer_handler shl 0x30) shr 0x30);32 - 0x20 - irq0 timer  -  calls correct
	dw 0x8
	db 0
	db 010001110b
	dw (timer_handler shr 0x10)

	dw ((keyboard_handler shl 0x30) shr 0x30); irq1 - keyboard  - calls correct
	dw 0x8
	db 0
	db 010001110b
	dw (keyboard_handler shr 0x10);jumps to pop ax iretd

	;dw ((timer_handler shl 0x30) shr 0x30);irq2
	;dw 0x8
	;db 0
	;db 010001110b
	;dw (timer_handler shr 0x10)
IDTR:
	dw IDTR-idt-1;size
	dd idt;address

;================INT HANDLERS================
int_test:
	nop;skips 1 command
	push ax
	mov [0xb8000], dword 0x07690748
	;mov al, 20h
	;out 20h, al
	pop ax
	iretd

empty_exception_handler:
	nop;skips 1 command
	push ax
	;mov al, 20h
	;out 0x20, al
	;out 0xA0, al
	mov [0xB8000], dword 0x7600740
	pop ax
	iretd

keyboard_handler:
	nop;skips 1 command
	push eax
	push ebx
	push ecx
.read_buffer:
	in al, 61h
	xor al, 1h ;Set readed status bit
	out 61h, al

	in al, 60h;read data
.convertToAscii:;Al always 0
	mov ebx, chars_codes

	dec al;AL - 1 because array elem count starts from 0
	mov cl, al
	sub cl, 0x80;if char code ! in chars_codes - it released
	jns .release_char_convert
	mov ah, 0x0;need to add ax to bx
	add bx, ax
	jmp .write

.release_char_convert:
	mov ch, 0x0
	add bx, cx
	jmp .end;Dont need to write key 2 times(when pressed and when released)
.write:
	mov al, [ebx]
	mov ebx, 0xB8001
	add bx, word [i];Style pos
	mov [ebx], byte 0x07

	mov ebx, 0xB8000
	add bx, word [i];symbol pos
	mov [ebx], al
	cmp [i], 2000
	jz .zero_counter
	add [i], 2
	jmp .end
.zero_counter:
	mov [i], 0x00
.end:
	mov al, 20h
	out 0x20, al
	pop ecx
	pop ebx
	pop eax
	iretd

timer_handler:
	nop;skips 1 command
	push ax
	;inc dword [0xb8000]
	mov al,20h
	out 0x20, al
	pop ax
	iretd

;push size
;push text_pointer
print:
	pop eax;addr to ret
	pop ebx;text_pointer
	pop ecx;size
	push eax

	mov eax, 0x0
	mov edx, ecx
	dec edx;size - 1 = iterator
.write:
	mov al, [ebx]
	push ax
	call putc
	inc ebx

	dec edx;iterator
	cmp edx, 0xFFFFFFFF;if edx == -1
	jnz .write
	ret;ret gets address to return from stack and jumps there

;push 'char'
putc:
	pop ecx;ret addr
	pop ax
	push ecx;ret addr

	push ecx
	push ebx
	push eax


	mov ecx, 0xb8000
	add cx, [i]
	mov byte [ecx], al
	inc ecx
	mov byte [ecx], 0x07
	cmp [i], 2000
	jz .clear_counter
	add [i], 2
	jmp .end
.clear_counter:
	mov [i], 0x0
.end:
	pop eax
	pop ebx
	pop ecx
	ret

i dw 0
chars_codes db 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8, \;backspace
	       0, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', \
	       0, 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\', \
	       'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' ', 0, 0, \
	       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7', '8', '9', '-', '4', '5', '6', '+', '1', \
	       '2', '3', '0', '.', 0, 0, 0, 0, 0

test_string db 'hello', 0
times 1024-($-$$) db 0;2 sectors