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

	;lidt fword [idtr]

	;cli;Запрет прерываний
	;in al, 70h;=====================================
	;or al, 80h;		Запрет NMI
	;out 70h,al;=====================================
	cli

	lgdt [gdt_a]

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
	;=================================
	;in al,70h
	;and al,7Fh
	;out 70h,al
	;sti
	;=================================
	;hlt
	mov [0xb8000],dword 0x07690748; Protected mode test
	hlt
	;jmp $
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