format binary
org 500h
use16

on_load:
	mov ax,0003h
	int 10h

	;mov cx,8
	;mov bp,on_ld
	;call print_m
	;in al,92h;;=========Чтение из порта=============
	;or al,02h;;	    A20 через 92h порт
	;out 92h,al;=========Запись в порт===============

	cli;Запрет прерываний
	in al, 70h;=====================================
	or al, 80h;	       Запрет NMI
	out 70h,al;=====================================
	cli

	lgdt [gdt_a]

	in al, 92h;;
	or al, 2  ;;	      A20
	out 92h, al;

	mov eax,cr0;====================================
	or al,1    ;	      Protected Mode
	mov cr0,eax;====================================

	jmp 08h:protected; Обновляем cs на 8


print_m:;CX - длина  bp - адрес сообщения
	mov ax,1301h
	mov bh,00h
	mov bl,01h
	int 10h
	ret

;=========================================================
use32
protected:
	;=================================
	mov eax,16
	mov ds,ax
	mov ss,ax
;	 mov ax,24
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov edi,0xB8000
	mov esp,90000h
	mov ebp,90000h

	pusha
	lidt [IDTR]
	popa
	;=========SETUP PIC=============Programmable interupt controller
	push ax;Save register al

	mov al, 0x11;00010001
	out 0x20, al;Start setting up master PIC
	out 0xA0, al;Slave PIC

	mov al, 0x20
	out 0x21, al
	mov al, 0x28
	out 0xA1, al

	mov al, 0x4;00000100
	out 0x21, al
	mov al, 0x2;00000010
	out 0xA1, al

	mov al, 0x1;00000001
	out 0x21, al
	out 0xA1, al

	mov al, 0x0;End of setting PIC
	out 0x21, al
	out 0xA1, al

	pop ax;Load saved al
	;===============================
	;=================================
	in al,70h
	and al,7Fh;	  Разрешаем прерывания
	out 70h,al
	sti
	;=================================
	;hlt

	int 05h;Test   Work!!!

	;mov [0xb8000],dword 0x07690748; Protected mode test
Cicle:
	hlt;- после приёма символа печатает и падает.
	jmp Cicle

;Add error handlers - TODO
;========================IDTR==============================
;use16
IDT:
	dd 0,0;0
	dd 0,0;1
	dd 0,0;2
	dd 0,0;3
	dd 0,0;4

	;dd 0,0;5
	dw ((int_test shl 0x30) shr 0x30);low part of function address
	dw 0x8;selector
	db 0
	db 010001110b;type
	dw (int_test shr 0x10);high part of address

	dd 0,0;6
	dd 0,0;7
	dd 0,0;8
	dd 0,0;9
	dd 0,0;10
	dd 0,0;11
	dd 0,0;12
	dd 0,0;13
	dd 0,0;14
	dd 0,0;15
	dd 0,0;16
	dd 0,0;17
	dd 0,0;18
	dd 0,0;19
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
	dd 0,0;dw irq0_h, 08h, 1000111000000000b;irq0 - таймер

	dw ((irq1_h shl 0x30) shr 0x30)
	dw 08h
	db 0
	db 010001110b
	dw (irq1_h shr 0x10);irq1 - клавиатура
IDTR:
	dw IDTR-IDT-1
	dd IDT
;use32
;=========================================================
int_EOI:
	push ax
	mov al, 20h
	out 020h, al
	out 0a0h, al
	pop ax
	iretd

irq0_h:
	inc byte [0xB8000]
	;jmp int_EOI

irq1_h:
	in eax, 60h;eax = scan code
	push eax
	in eax, 61h
	xor eax, 1
	out 61h, eax
	pop eax;eax = scan code
	mov [0xB8000],dword eax
	iret
	;jmp int_EOI

int_test:
	 mov [0xb8000],dword 0x07690748
	 iret
;=========================================================

use16
align 16
;============================================================
gdt:			;Таблица Сегментов
	dq 0;Нулевой сегмент

	dw 0FFFFh,0,9A00h,0CFh;CODE
	dw 0FFFFh,0,9200h,08Fh;DATA
	;dw 0xffff
	;dw 0x0
	;db 0x0
	;db 10011010b
	;db 11001111b
	;db 0x0

	;dw 0xffff
	;dw 0x0
	;db 0x0
	;db 10010010b
	;db 11001111b
	;db 0x0

	;dw 0xFFFF
	;db 0,0,0,9Ah,0CFh,0;Code - 8

	;dw 0xFFFF
	;db 0,0,0,9Ah,0CFh,0;Data - 16
;	 db 0FFh, 0FFh,0,80h,0Bh,92h,40h,0 ;видеосегмент - 24
gdt_a:
	dw 3*8 - 1
	dq gdt
;=============================================================

;=============================================================
;		       Таблица прерываний
;idtr_a:
;	 dd 0,0; 0
;	 dd 0,0; 1
;	 dd 0,0; 2
;	 dd 0,0; 3
;idtr:
;	 dw $ - idtr_a - 1
;	 dd idtr_a

;REAL_IDTR:   ; IDTR for REAL mode
;	 dw 3FFh
;	 dd 0
;=============================================================
on_ld db 'Jadro!!!',0h
;tst_s db 'H',0h
times (512-($-$$)) db 0