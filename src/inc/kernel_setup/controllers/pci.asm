;=============PCI==================
;https://wiki.osdev.org/PCI

;input:
;eax = bus
;ebx = device
;ecx = func
;edx = offset
;return: eax - result
pciReadConfigDWord:
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
    ;we need only last 16 bits
    mov dx, 0xcfc
    in eax, dx

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
        call pciReadConfigDWord
        ;0xffff means invalid bus or device
        cmp ax, 0xffff
        ;next device
        inc ebx
        ;run bus up to 256
        ;run device in each bus to 32
        jz .iter
        ;print pci device info

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret