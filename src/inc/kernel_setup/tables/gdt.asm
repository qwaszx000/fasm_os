use16
align 16

gdt_table:;global description table
	dq 0; zero
	;limit 2 bytes + base 3 bytes + access 1 byte + limit 4 bits + flag 4 bits + base 1 byte

	;dw 0xFFFF, 0, 0x9A00, 0x0CF
	;Code - 8
	dw 0xffff;limit
	db 0, 0, 0 ;base
	db 10011010b ;0x9A ;access
	db 11001111b ;0xCF	;flag + limit
	db 0	;base

	;Data - 16 = 0x10
	dw 0xFFFF;limit
	db 0, 0, 0  ;base
	db 10010010b ;0x92 - access
	db 10001111b ;0x8F - flag + limit
	db 0 ;base

gdt:
	dw gdt-gdt_table
	dq gdt_table