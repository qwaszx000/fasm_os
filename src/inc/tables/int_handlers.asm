int_test:
	nop;skips 1 command
	push ax
	mov [0xb8000], dword 0x07690748
	;mov al, 20h
	;out 20h, al
	pop ax
	iretd

empty_exception_handler:
	nop;skips 1 command
	push ax
	;mov al, 20h
	;out 0x20, al
	;out 0xA0, al
	mov [0xB8000], dword 0x7600740
	pop ax
	iretd

keyboard_handler:
	nop;skips 1 command
	push eax
	push ebx
	push ecx
.read_buffer:
	in al, 0x61
	xor al, 1 ;Set readed status bit
	out 0x61, al

	in al, 0x60;read data
.convertToAscii:;Al always 0
	mov ebx, chars_codes

	dec al;AL - 1 because array elem count starts from 0
	mov cl, al
	sub cl, 0x80;if char code ! in chars_codes - it released
	jns .release_char_convert
	mov ah, 0x0;need to add ax to bx
	add bx, ax
	jmp .write

.release_char_convert:
	mov ch, 0x0
	add bx, cx
	jmp .end;Dont need to write key 2 times(when pressed and when released)
.write:
	mov al, [ebx]
	mov ebx, 0xB8001
	add bx, word [i];Style pos
	mov [ebx], byte 0x07

	mov ebx, 0xB8000
	add bx, word [i];symbol pos
	mov [ebx], al
	cmp [i], 2000
	jz .zero_counter
	add [i], 2
	jmp .end
.zero_counter:
	mov [i], 0x00
.end:
	mov al, 0x20
	out 0x20, al
	pop ecx
	pop ebx
	pop eax
	iretd

timer_handler:
	nop;skips 1 command
	push ax
	;inc dword [0xb8000]
	mov al, 0x20
	out 0x20, al
	pop ax
	iretd


chars_codes db 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8, \;backspace
	       0, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', \
	       0, 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\', \
	       'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' ', 0, 0, \
	       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7', '8', '9', '-', '4', '5', '6', '+', '1', \
	       '2', '3', '0', '.', 0, 0, 0, 0, 0