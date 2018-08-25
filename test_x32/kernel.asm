format binary
org 500h
use16

cli
lgdt [gdt]

mov eax, cr0
or al, 1
mov cr0, eax

jmp 08h:protected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;							  ;
;							  ;
use32
protected:
	mov eax,16
	mov ds,ax
	mov ss,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov edi,0xB8000
	mov esp,90000h
	mov ebp,90000h

	mov [0xB8000], dword 0x7690748
	;hlt
	jmp $

use16
align 16

gdt_a:
	dq 0
	dw 0FFFFh, 0, 9A00h, 0CFh;Code - 8
	dw 0FFFFh, 0, 9200h, 08Fh;Data - 16
gdt:
	dw 3*8-1
	dq gdt_a

times 512-($-$$) db 0