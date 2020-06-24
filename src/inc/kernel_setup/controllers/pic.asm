;Setup PIC
setup_pic:
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
    ret