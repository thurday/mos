.text
.globl start
.code16

load_msg:
	.string "Load MOS ..."

start:
	jmp code

code:
	xor %ax, %ax
	mov %ax, %ds
	mov $0x03, %ah 
	int $0x10
	
	mov $12, %cx
	mov $0x7, %bx
	mov $load_msg, %bp
	mov $0x1301, %ax
	int $0x10
1:  
	jmp 1b
.org	  0x1fe,	0x90
.word	  0xaa55

