;eax = text_pointer
print:
	;if zero char in end of line - stop
	push ebx

.cicle:
	mov bl, byte [eax]
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
	cmp [console_pointer], 2000
	jz .clear_counter
	add [console_pointer], 2
	jmp .end

.clear_counter:
	mov [console_pointer], 0x0

.end:
	pop ecx
	ret