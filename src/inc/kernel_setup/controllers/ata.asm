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
        in al, dx;drops here
        cmp al, 00001000b;Overlapped Mode Service Request. 
        jz .read_status
    .read_data:
        mov eax, 256;256 words = 512 bytes = 1 sector
        xor bx, bx
        mov bl, ch;count of sectors to read
        mul bx;256 words * count of sectors = count of words
        mov ecx, eax;ecx - counter for insw
        mov edx, 0x1f7;data port to read and write
        ;edi - pointer to buffer
        rep insw
    .end:
        pop edi
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret