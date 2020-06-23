;push size
;push text_pointer
print:
	pop eax;addr to ret
	pop ebx;text_pointer
	pop ecx;size
	push eax

	mov eax, 0x0
	mov edx, ecx
	dec edx;size - 1 = iterator
.write:
	mov al, [ebx]
	push ax
	call putc
	inc ebx

	dec edx;iterator
	cmp edx, 0xFFFFFFFF;if edx == -1
	jnz .write
	ret;ret gets address to return from stack and jumps there

;push 'char'
putc:
	pop ecx;ret addr
	pop ax
	push ecx;ret addr

	push ecx
	push ebx
	push eax


	mov ecx, 0xb8000
	add cx, [i]
	mov byte [ecx], al
	inc ecx
	mov byte [ecx], 0x07
	cmp [i], 2000
	jz .clear_counter
	add [i], 2
	jmp .end
.clear_counter:
	mov [i], 0x0
.end:
	pop eax
	pop ebx
	pop ecx
	ret

i dw 0