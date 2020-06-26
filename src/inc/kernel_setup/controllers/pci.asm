;=============PCI==================
;https://wiki.osdev.org/PCI

;input:
;eax = bus
;ebx = device
;ecx = func
;edx = offset
;return: eax - result
pciReadConfigDWord:
    push ebx
    push ecx
    push edx
    
    ;0xcf8 - config_address
    ;0xcfc - data_address
    ;prepare data
    shl eax, 0x10
    shl ebx, 0xb
    shl ecx, 0x8
    and edx, 11111100b ;last 2 bits need to be 0
    ;compile it to 1 packet
    or eax, ebx
    or eax, ecx
    or eax, edx
    or eax, 10000000000000000000000000000000b ;set enable bit to 1
    ;now eax contains our packet to read pci config
    ;send packet
    mov dx, 0xcf8
    out dx, eax

    ;read response
    mov dx, 0xcfc
    in eax, dx

    pop edx
    pop ecx
    pop ebx
    ret

bruteCheckPCI:
    push eax
    push ebx
	push ecx
	push edx

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    .iter:
        push eax
        call pciReadConfigDWord
        ;0xffff means invalid bus or device
        cmp ax, 0xffff
        jz .next_device

        ;run bus up to 255
        ;run device in each bus to 32
        ;jz .iter
        call print_hex
        ;print pci device info

    .next_device:
        pop eax;eax = bus
        cmp ebx, 32
        jz .next_bus

        ;next device
        inc ebx

        jmp .iter
    .next_bus:
        cmp eax, 0xff;last bus checked
        jz .end

        xor ebx, ebx   ;first device of new bus
        inc eax        ;next bus
        jmp .iter
    .end:
        pop edx
        pop ecx
        pop ebx
        pop eax
        ret