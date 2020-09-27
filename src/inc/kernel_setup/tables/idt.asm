use32
align 16
idt:;interrupts description table
;TODO: keyboard, timer and exceptions
; https://wiki.osdev.org/Interrupt_Vector_Table
	dw ((zero_div_exception_handler shl 0x30) shr 0x30);0 - Division By Zero
	dw 0x8
	db 0
	db 010001110b
	dw (zero_div_exception_handler shr 0x10)

	dd 0,0;1 - reserved

	dw ((nmi_handler shl 0x30) shr 0x30);2 - NMI interrupt
	dw 0x8
	db 0
	db 010001110b
	dw (nmi_handler shr 0x10)

	dd 0,0;3 - breakpoint

	dw ((overflow_exception_handler shl 0x30) shr 0x30);4 - Overflow
	dw 0x8
	db 0
	db 010001110b
	dw (overflow_exception_handler shr 0x10)

	dw ((bound_exception_handler shl 0x30) shr 0x30);5 - BOUND
	dw 0x8
	db 0
	db 010001110b
	dw (bound_exception_handler shr 0x10)

	dw ((opcode_exception_handler shl 0x30) shr 0x30);6 - Invalid opcode
	dw 0x8
	db 0
	db 010001110b
	dw (opcode_exception_handler shr 0x10)

	dw ((device_unavailable_exception_handler shl 0x30) shr 0x30);7 - Device not available
	dw 0x8
	db 0
	db 010001110b
	dw (device_unavailable_exception_handler shr 0x10)

	dw ((df_exception_handler shl 0x30) shr 0x30);8 - Double fault
	dw 0x8
	db 0
	db 010001110b
	dw (df_exception_handler shr 0x10)

	dw ((coproc_segment_exception_handler shl 0x30) shr 0x30);9 - coprocessor segment overrun
	dw 0x8
	db 0
	db 010001110b
	dw (coproc_segment_exception_handler shr 0x10)

	dw ((tts_exception_handler shl 0x30) shr 0x30);10 - invalid TSS
	dw 0x8
	db 0
	db 010001110b
	dw (tts_exception_handler shr 0x10)

	dw ((segment_not_present_exception_handler shl 0x30) shr 0x30);11 - segment not present
	dw 0x8
	db 0
	db 010001110b
	dw (segment_not_present_exception_handler shr 0x10)

	dw ((ss_exception_handler shl 0x30) shr 0x30);12 - stack segment fault
	dw 0x8
	db 0
	db 010001110b
	dw (ss_exception_handler shr 0x10)

	dw ((gpf_exception_handler shl 0x30) shr 0x30);13 - general protection fault
	dw 0x8
	db 0
	db 010001110b
	dw (gpf_exception_handler shr 0x10)

	dw ((page_fault_exception_handler shl 0x30) shr 0x30);14 - page fault
	dw 0x8
	db 0
	db 010001110b
	dw (page_fault_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);15
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((fpu_exception_handler shl 0x30) shr 0x30);16 - x87 FPU error
	dw 0x8
	db 0
	db 010001110b
	dw (fpu_exception_handler shr 0x10)

	dw ((aligment_exception_handler shl 0x30) shr 0x30);17 - Alignment check
	dw 0x8
	db 0
	db 010001110b
	dw (aligment_exception_handler shr 0x10)

	dw ((machine_check_exception_handler shl 0x30) shr 0x30);18 - machine check
	dw 0x8
	db 0
	db 010001110b
	dw (machine_check_exception_handler shr 0x10)

	dw ((floating_point_exception_handler shl 0x30) shr 0x30);19 - SIMD floating point exception
	dw 0x8
	db 0
	db 010001110b
	dw (floating_point_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);20
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);21
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);22
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);23
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);24
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);25
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);26
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);27
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);28
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);29
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);30
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);31
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((timer_handler shl 0x30) shr 0x30);32 - 0x20 - irq0 timer - begin of pic master
	dw 0x8
	db 0
	db 010001110b
	dw (timer_handler shr 0x10)

	dw ((keyboard_handler shl 0x30) shr 0x30);33 irq1 - keyboard
	dw 0x8
	db 0
	db 010001110b
	dw (keyboard_handler shr 0x10)

	dw ((timer_handler shl 0x30) shr 0x30);34 - irq2 - cascade
	dw 0x8
	db 0
	db 010001110b
	dw (timer_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);35 - irq3 - com2
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);36 - irq4 - com1
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);37 - irq5 - lpt
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);38 - irq6 - floppy disk
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);39 - irq 7 - lpt1
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);40 - begin of pic slave - irq8 - cmos real time clock
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);41
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);42
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);43
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);44 - ps2 mouse
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);45 - fpu
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

	dw ((primary_ata_handler shl 0x30) shr 0x30);46 - primary ata
	dw 0x8
	db 0
	db 010001110b
	dw (primary_ata_handler shr 0x10)

	dw ((unknown_exception_handler shl 0x30) shr 0x30);47 - secondary ata
	dw 0x8
	db 0
	db 010001110b
	dw (unknown_exception_handler shr 0x10)

IDTR:
	dw IDTR-idt-1;size
	dd idt;address

include "int_handlers.asm"