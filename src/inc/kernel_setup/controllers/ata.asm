;https://wiki.osdev.org/ATA_read/write_sectors
;https://wiki.osdev.org/ATA_Command_Matrix
;https://wiki.osdev.org/ATA_PIO_Mode

;ebx - cylinder 16bits(up to 65535) + bh = head(0 to 15) + bl = sector(1 to 63)
;ch = count of sectors to read
;edi = address, where read data will be stored
ata_read_chs:
    push eax
    push ebx
    push ecx
    push edx
    push edi

    ;0x1f0 - base port

    ;set driver/head register
    mov dx, 0x1f6 ;Head Register 
    mov al, bh
    and al, 00001111b ;only 4 bits
    or al, 10100000b
    out dx, al

    ;set sector count register
    mov dx, 0x1f2 
    mov al, ch
    out dx, al

    ;set sector number register
    inc dx;0x1f3 = Sector Number Register
    mov al, bl
    out dx, al

    ;set Cylinder Low Register
    inc dx ;0x1f4
    mov eax, ebx;cylinder high + low + head + sector
    shr eax, 16 ; zeros 16bits + high + low
    out dx, al

    ;set Cylinder High Register
    inc dx ;0x1f5
    shr eax, 8 ; zeros 24bits + high
    out dx, al

    ;send command
    ;0x1f7 = command port to write
    ; or status port to read
    mov dx, 0x1f7
    mov al, 0x20 ;read with retry
    out dx, al

    .read_status:
        in al, dx
        ;test al, 00001000b;Overlapped Mode Service Request. 
        test al, 10000000b;BSY - preparing to send/read data
        jnz .read_status
        test al, 00000001b;ERR - error
        jnz .end
        test al, 00000100b;DF - drive fault, not sets ERR
        jnz .end
    .read_data:
        mov eax, 256;256 words = 512 bytes = 1 sector
        xor bx, bx
        mov bl, ch;count of sectors to read
        mul bx;256 words * count of sectors = count of words
        mov ecx, eax;ecx - counter for insw
        mov edx, 0x1f0;data port to read and write
        ;edi - pointer to buffer
        rep insw
    .end:
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret



;ebx - cylinder 16bits(up to 65535) + bh = head(0 to 15) + bl = sector(1 to 63)
;ch = sectors to write
;edi = buffer address, where data to write stored
ata_write_chs:
    push eax
    push ebx
    push ecx
    push edx
    push edi

    ;0x1f0 - base port

    ;set driver/head register
    mov dx, 0x1f6 ;Head Register 
    mov al, bh
    and al, 00001111b ;only 4 bits
    or al, 10100000b
    out dx, al

    ;set sector count register
    mov dx, 0x1f2 
    mov al, ch
    out dx, al

    ;set sector number register
    inc dx;0x1f3 = Sector Number Register
    mov al, bl
    out dx, al

    ;set Cylinder Low Register
    inc dx ;0x1f4
    mov eax, ebx;cylinder high + low + head + sector
    shr eax, 16 ; zeros 16bits + high + low
    out dx, al

    ;set Cylinder High Register
    inc dx ;0x1f5
    shr eax, 8 ; zeros 24bits + high
    out dx, al

    .begin:
        ;send command
        ;0x1f7 = command port to write
        ; or status port to read
        mov dx, 0x1f7
        mov al, 0x30 ;write with retry
        out dx, al
    .read_status:
        in al, dx
        ;test al, 00001000b;Overlapped Mode Service Request. 
        ;jnz .read_status
        test al, 10000000b;BSY - preparing to send/read data
        jnz .read_status
        test al, 00000001b;ERR - error
        jnz .end
        test al, 00000100b;DF - drive fault, not sets ERR
        jnz .end
    .prepare:
        ;count len
        mov al, ch
        mov bx, 256
        mul bx;count of sectors * 256 words to write per sector - result in dx ax

        xor ecx, ecx
        mov cx, dx
        shl ecx, 0x10
        mov cx, ax
        
        mov dx, 0x1f0;data port
    .write_data:
        ;cx - len
        ;edi - pointer to buffer
        ;rep outsw - dont use
        mov ax, word [edi]
        out dx, ax
        ;delay
        nop
        nop

        dec ecx;dec len

        inc edi;inc index(next word)
        inc edi
        test ecx, ecx;if ch = 0 then end
        jnz .write_data
    .flush:
        ;E7 - cache flush
        mov dx, 0x1f7 ;commands port
        mov al, 0xe7 ;cache flush - need after every write
        out dx, al
    .end:
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret