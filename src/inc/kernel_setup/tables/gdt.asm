use16
align 16

gdt_table:;global description table
	dq 0
	dw 0x0FFFF, 0, 0x9A00, 0x0CF;Code - 8
	dw 0x0FFFF, 0, 0x9200, 0x08F;Data - 16 = 0x10
gdt:
	dw gdt-gdt_table
	dq gdt_table