;eax = num
print_dec:
	push ebx
	push ecx

	mov ecx, 8
	mov ebx, numStr_buf
	call dec_to_str

	mov eax, numStr_buf
	call print

	pop ecx
	pop ebx
	ret

;eax = hex num
print_hex:
	push ebx
	push ecx

	mov bl, '0'
	call putc
	mov bl, 'x'
	call putc

	mov ecx, 8
	mov ebx, numStr_buf
	call hex_to_str

	mov eax, numStr_buf
	call print

	pop ecx
	pop ebx
	ret

;eax = text_pointer
print:
	push ebx

.cicle:
	mov bl, byte [eax]
	;if zero char in end of line - stop
	test bl, bl
	jz .exit

	call putc
	inc eax ;next char
	jmp .cicle

.exit:
	pop ebx
	ret
	

;bl = char
putc:
	push ecx

	mov ecx, 0xb8000
	add cx, [console_pointer]
	mov byte [ecx], bl
	inc ecx
	mov byte [ecx], 0x07
	;if points in end of videomemory - set it zero
	cmp [console_pointer], 2000
	jz .clear_counter
	add [console_pointer], 2
	jmp .end

.clear_counter:
	mov [console_pointer], 0x0

.end:
	pop ecx
	ret