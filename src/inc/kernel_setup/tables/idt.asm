use32
align 16
idt:;interrupts description table
;TODO: keyboard, timer and exceptions
; https://wiki.osdev.org/Interrupt_Vector_Table
	dw ((empty_exception_handler shl 0x30) shr 0x30);0 - Division By Zero
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dd 0,0;1 - reserved

	dw ((empty_exception_handler shl 0x30) shr 0x30);2 - NMI interrupt
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dd 0,0;3 - breakpoint

	dw ((empty_exception_handler shl 0x30) shr 0x30);4 - Overflow
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dw ((empty_exception_handler shl 0x30) shr 0x30);5 - BOUND
	dw 0x8
	db 0
	db 010001110b
	dw (empty_exception_handler shr 0x10)

	dw ((opcode_exception_handler shl 0x30) shr 0x30);6 - Invalid opcode
	dw 0x8
	db 0
	db 010001110b
	dw (opcode_exception_handler shr 0x10)

	dw ((device_not_awable_exception_handler shl 0x30) shr 0x30);7 - Device not awable
	dw 0x8
	db 0
	db 010001110b
	dw (device_not_awable_exception_handler shr 0x10)

	dw ((df_exception_handler shl 0x30) shr 0x30);8 - Double fault
	dw 0x8
	db 0
	db 010001110b
	dw (df_exception_handler shr 0x10)

	dd 0,0;9 - coprocessor segment overrun
	dd 0,0;10 - invalid TSS
	dd 0,0;11 - segment not present
	dd 0,0;12 - stack segment fault

	dw ((gpf_exception_handler shl 0x30) shr 0x30);13 - general protection fault
	dw 0x8
	db 0
	db 010001110b
	dw (gpf_exception_handler shr 0x10)
	dd 0,0;14 - page fault

	dw ((int_test shl 0x30) shr 0x30);15
	dw 0x8
	db 0
	db 010001110b
	dw (int_test shr 0x10)

	dd 0,0;16 - x87 FPU error
	dd 0,0;17 - Alignment check
	dd 0,0;18 - machine check
	dd 0,0;19 - SIMD floating point exception
	dd 0,0;20
	dd 0,0;21
	dd 0,0;22
	dd 0,0;23
	dd 0,0;24
	dd 0,0;25
	dd 0,0;26
	dd 0,0;27
	dd 0,0;28
	dd 0,0;29
	dd 0,0;30
	dd 0,0;31

	dw ((timer_handler shl 0x30) shr 0x30);32 - 0x20 - irq0 timer  -  calls correct
	dw 0x8
	db 0
	db 010001110b
	dw (timer_handler shr 0x10)

	dw ((keyboard_handler shl 0x30) shr 0x30); irq1 - keyboard  - calls correct
	dw 0x8
	db 0
	db 010001110b
	dw (keyboard_handler shr 0x10);jumps to pop ax iretd

	;dw ((timer_handler shl 0x30) shr 0x30);irq2
	;dw 0x8
	;db 0
	;db 010001110b
	;dw (timer_handler shr 0x10)
IDTR:
	dw IDTR-idt-1;size
	dd idt;address

include "int_handlers.asm"