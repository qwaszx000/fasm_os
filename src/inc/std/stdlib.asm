;eax = num
;ebx = buffer pointer
;ecx = buffer length
dec_to_str:
    push edx
    push ebx
    push ecx

    test ecx, ecx;if len == 0 - buffer len is ended
    jz .end

    test eax, eax;if eax is 0 in start - return '0'
    jz .zero

    .decToStr:
        push ebx

        mov ebx, 10
        div ebx;cant use edx 
        ;edx = rest
        ;eax = result

        pop ebx

        test edx, edx;if edx is 0 - zero
        jz .zero_rest

        ;1 num to char
        add edx, '0'
        mov [ebx], edx;write to buffer - may be need to use dl
        xor edx, edx

    .next:
        inc ebx;next buffer char
        dec ecx;dec len. So we write only len chars

        jmp .decToStr

    .zero_rest:
        test eax, eax ;if num/10 == 0 and num%10 == 0 - end of program
        jz .end
        ;else - draw zero and continue
        mov [ebx], byte '0'
        jmp .next 

    .zero:
        mov [ebx], byte '0'
        jmp .end

    .end:
        mov ebx, ecx;ebx = rest of boffer len
        pop ecx;ecx = buffer len
        sub ecx, ebx;ecx - ebx = int len

        pop ebx;ebx = buffer pointer
        mov eax, ebx
        call reverse_array;our nums is reversed so reverse it

        pop edx
        ret

;eax = hex num
;ebx = buffer pointer
;ecx = buffer length
hex_to_str:
    push edx
    push ebx
    push ecx

    test ecx, ecx;if len == 0 - buffer len is ended
    jz .end

    test eax, eax;if eax is 0 in start - return '0'
    jz .zero

    .decToStr:
        push ebx

        mov ebx, 16;hex = 16
        div ebx;cant use edx 
        ;edx = rest
        ;eax = result

        pop ebx

        test edx, edx;if edx is 0 - zero
        jz .zero_rest

        cmp edx, 0xA
        jge .print_hex_num ;if rest >= 10

    .print_dec_num:
        ;1 num to char
        add edx, '0'
        mov [ebx], edx;write to buffer - may be need to use dl
        xor edx, edx
        jmp .next

    .print_hex_num:
        sub edx, 0xA
        add edx, 'A'
        mov [ebx], edx;write to buffer - may be need to use dl
        xor edx, edx

    .next:
        inc ebx;next buffer char
        dec ecx;dec len. So we write only len chars

        jmp .decToStr

    .zero_rest:
        test eax, eax ;if num/10 == 0 and num%10 == 0 - end of program
        jz .end
        ;else - draw zero and continue
        mov [ebx], byte '0'
        jmp .next 

    .zero:
        mov [ebx], byte '0'
        jmp .end

    .end:
        mov ebx, ecx;ebx = rest of boffer len
        pop ecx;ecx = buffer len
        sub ecx, ebx;ecx - ebx = int len

        pop ebx;ebx = buffer pointer
        mov eax, ebx
        call reverse_array;our nums is reversed so reverse it

        pop edx
        ret

;eax = buffer pointer
;ecx = buffer len
reverse_array:
    push ebx
    push edx

    cmp ecx, 1;if ecx == 1 or 0 - dont need reverse
    jbe .end

    mov ebx, ecx
    dec ebx;ebx - end of buffer pointer offset
    xor ecx, ecx
    ;ecx = begin buffer pointer offset
    .iteration:
        ;xor swap
        ;https://en.wikipedia.org/wiki/XOR_swap_algorithm
        push eax
        push ebx
        push ecx

        mov edx, eax
        add eax, ecx;eax = pointer to begin symbol
        add edx, ebx;edx = pointer to end symbol

        mov cl, [eax];ecx = symbol from begin
        mov bl, [edx];ebx = symbol from end
        mov [eax], bl
        mov [edx], cl

        pop ecx
        pop ebx
        pop eax

        inc ecx;ecx goes to center from begining

        cmp ecx, ebx;ecx + 1 == ebx - they in center. Stop program
        jz .end

        dec ebx;ebx goes to center from end
        cmp ecx, ebx ;if ecx == ebx - they in one center symbol. Stop program
        jz .end
        jmp .iteration
    .end:
        pop edx
        pop ebx
        ret