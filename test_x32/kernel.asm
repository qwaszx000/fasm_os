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
;                                                         ;
;                                                         ;
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
        int 05h
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
        dw 3*8-1
        dq gdt_a
use32
idt:;interrupts description table
        dd 0,0;0
        dd 0,0;1
        dd 0,0;2
        dd 0,0;3
        dd 0,0;4

        dw ((int_test shl 0x30) shr 0x30);5
        dw 0x8
        db 0
        db 010001110b
        dw (int_test shr 0x10)

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
        dd 0,0;32
        dd 0,0;irq 0 - timer
        dd 0,0;irq 1 - keyboard
IDTR:
        dw IDTR-idt-1;size
        dd idt;address

;================INT HANDLERS================
int_test:
        mov [0xb8000], dword 0x07690748
        ;mov al, 20h
        ;out 20h, al
        iret

times 512-($-$$) db 0