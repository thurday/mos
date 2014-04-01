
BOOTSEG = 0x07c0
SYSSEG  = 0x1000
SYSLEN  = 17

.code16
.text

.global start
start:
	ljmp $BOOTSEG, $go
go:
	movw %cs, %ax
	movw %ax, %ds
	movw %ax, %ss
	movw $0x400, %sp

load_system:
	movw $0x0000, %dx
	movw $0x0002, %cx
	movw $SYSSEG, %ax
	movw %ax, %es
	xor  %bx, %bx
	movw $0x211,  %ax
	int  $0x13
	jnc  ok_load
die:
	jmp die

ok_load:
	cli
	movw $SYSSEG, %ax
	movw %ax, %ds
	xor  %ax, %ax
	movw %ax, %es
	movw $0x2000, %cx
	sub  %si, %si
	sub  %di, %di
	rep  movsw
	movw $BOOTSEG, %ax
	movw %ax, %ds
	lidt idt_48
	lgdt gdt_48
	
	movw $0x0001, %ax
	lmsw %ax
	ljmp $8,  $0

gdt:
	.word 0, 0, 0, 0 
	
	.word 0x07FF
	.word 0x0000
	.word 0x9A00
	.word 0x00c0
	
	.word 0x07FF
	.word 0x0000
	.word 0x9200
	.word 0x00c0

idt_48:
	.word 0
	.word 0, 0

gdt_48:
	.word 0x7ff
	.word 0x7c00+gdt, 0

.org 510
	.word 0xAA55
