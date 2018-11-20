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
;                                                         ;
;                                                         ;
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

        ;mov [0xB8000], dword 0x7690748
        int 0Fh;15
        ;hlt
        jmp $
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

        dd 0,0;32

        dd 0,0;irq 0 - timer
        dd 0,0;irq 1 - keyboard
IDTR:
        dw IDTR-idt-1;size
        dd idt;address

;================INT HANDLERS================
int_test:
        mov [0xb8000], dword 0x07690748
        mov al, 20h
        out 20h, al
        iret

empty_exception_handler:
        mov al, 20h
        out 0x20, al
        ;out 0xA0, al
        iret

times 512-($-$$) db 0