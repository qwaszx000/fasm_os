format binary
org 7c00h
use16

_start:
    ; init registers with 0
    push dx
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov fs, ax
    mov gs, ax
    sti

    ;Reset disk driver
    pop dx
    push dx;DL - disk drive
    xor ah, ah; 0 - command
    int 0x13

    ;clear video memory
    mov ax, 0x0003;command
    int 0x10

    ;Read kernel.asm sectors(2 sectors)
    mov ah, 0x02;Read sector from drive
    pop dx;DH - head, DL - drive
    xor ch, ch;0 Cylinder
    mov cl, 0x02;Sector(count from 1)
    mov al, 0x02;Sectors to read we read 2 sectors because our kernel has size = 2 sectors
    xor bx, bx
    mov es,bx    ;ES:BX memory address
    mov bx, 0x0500
    int 0x13;Read sector from drive

    ;mov ch, 00h
    ;mov cl, 03h
    ;mov al, 01h
    ;mov bx, 0000h
    ;mov es,bx
    ;mov bx, 0x700
    ;int 13h

    ;Prepare to jmp to protected mode
    cli
    lgdt [gdt] ;load gdt

    in al, 0x70		;
    or al, 0x80		; A20
    out 0x70, al	;

    mov eax, cr0
    or al, 1
    mov cr0, eax
    
    jmp 0x08:0x0500


include "inc/kernel_setup/tables/gdt.asm"

times 510-($-$$) db 0
db 0x055,0x0aa;magic symbols to show, that it is a bootloader