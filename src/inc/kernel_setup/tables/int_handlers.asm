;exceptions

zero_div_exception_handler:
	push ax

	mov eax, zero_div_str
	call print

	pop ax
	iretd

nmi_handler:
	push ax

	mov eax, nmi_str
	call print

	pop ax
	iretd

overflow_exception_handler:
	push ax

	mov eax, overflow_str
	call print

	pop ax
	iretd

bound_exception_handler:
	push ax

	mov eax, bound_str
	call print

	pop ax
	iretd

opcode_exception_handler:
	push ax
	
	mov eax, opcode_str
	call print

	pop ax
	iretd

df_exception_handler:
	mov eax, df_str
	call print
	
	pop eax
	call print_hex

	hlt
	iretd

coproc_segment_exception_handler:
	push ax

	mov eax, coproc_segment_str
	call print

	pop ax
	iretd

tts_exception_handler:

	mov eax, tts_inv_str
	call print

	pop eax
	call print_hex

	iretd

segment_not_present_exception_handler:
	mov eax, seg_not_present_str
	call print

	pop eax
	call print_hex

	iretd

device_unavailable_exception_handler:
	push ax

	mov eax, device_unavailable_str
	call print

	pop ax
	iretd

ss_exception_handler:
	mov eax, ss_fault_str
	call print

	pop eax
	call print_hex

	iretd

gpf_exception_handler:
	;print general protection fault
	mov eax, gpf_str
	call print
	;print Selector Error Code 
	;handled because handler is trap
	pop eax;tbl, selector index and reserved 2 bytes 
	call print_hex;print it

	;return addr left
	iretd

page_fault_exception_handler:	
	mov eax, page_fault_str
	call print

	pop eax
	call print_hex

	iretd

fpu_exception_handler:
	push ax

	mov eax, fpu_error_str
	call print

	pop ax
	iretd

aligment_exception_handler:
	mov eax, aligm_check_str
	call print

	pop eax
	call print_hex

	iretd

machine_check_exception_handler:
	push ax

	mov eax, mach_check_str
	call print

	pop ax

	;abort exception type
	hlt
	iretd

floating_point_exception_handler:
	push ax

	mov eax, floating_point_except_str
	call print

	pop ax
	iretd

unknown_exception_handler:
	push ax

	mov eax, unknown_str
	call print

	pop ax
	iretd

;devices
keyboard_handler:
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
	add bx, word [console_pointer];Style pos
	mov [ebx], byte 0x07

	mov ebx, 0xB8000
	add bx, word [console_pointer];symbol pos
	mov [ebx], al
	cmp [console_pointer], 2000
	jz .zero_counter
	add [console_pointer], 2
	jmp .end
.zero_counter:
	mov [console_pointer], 0x00
.end:
	mov al, 0x20
	out 0x20, al
	pop ecx
	pop ebx
	pop eax
	iretd

timer_handler:
	push ax
	mov al, 0x20
	out 0x20, al
	pop ax
	iretd


primary_ata_handler:
	push ax
	mov al, 0x20
	out 0x20, al
	out 0xA0, al
	pop ax
	iretd

pic_master_empty_irq:
	push ax
	mov al, 0x20
	out 0x20, al
	pop ax
	iretd

pic_slave_empty_irq:
	push ax
	mov al, 0x20
	out 0x20, al
	out 0xA0, al
	pop ax
	iretd

chars_codes db 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8, \;backspace
	       0, 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', \
	       0, 0, 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', "'", '`', 0, '\', \
	       'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' ', 0, 0, \
	       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '7', '8', '9', '-', '4', '5', '6', '+', '1', \
	       '2', '3', '0', '.', 0, 0, 0, 0, 0


zero_div_str db 'Divide by 0', 0
nmi_str db 'NMI interrupt', 0
overflow_str db 'Overflow', 0
bound_str db 'BOUND', 0
opcode_str db 'Invalid opcode', 0
device_unavailable_str db 'Device not available', 0
df_str db 'Double fault', 0
coproc_segment_str db 'Coprocessor segment overrun', 0
tts_inv_str db 'Invalid TSS', 0
seg_not_present_str db 'Segment not present',0
ss_fault_str db 'Stack segment fault', 0
gpf_str db 'General protection fault', 0
page_fault_str db 'Page fault', 0
fpu_error_str db 'x87 FPU error', 0
aligm_check_str db 'Alignment check', 0
mach_check_str db 'Machine check', 0
floating_point_except_str db 'SIMD floating point exception', 0

unknown_str db 'Unknown exception!', 0