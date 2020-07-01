use16
align 16

gdt_table:;global description table
	dq 0
	;limit 2 bytes + base 3 bytes + access 1 byte + limit 4 bits + flag 4 bits + base 1 byte

	;dw 0xFFFF, 0, 0x9A00, 0x0CF;Code - 8
	dw 0xffff;limit
	db 0, 0, 0 ;base
	db 10011010b ;0x9A ;access
	db 11001111b ;0xCF	;limit + flag
	db 0	;base

	dw 0xFFFF, 0, 0x9200, 0x08F;Data - 16 = 0x10
gdt:
	dw gdt-gdt_table
	dq gdt_table