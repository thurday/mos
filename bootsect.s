.text
.globl start
.code16
start:
	jmp code
msg:
	.string "Hello fandunqiu..."
code:
	xor %ax, %ax
	mov %ax, %ds
	mov $0x03, %ah 
	int $0x10
	
	mov $18, %cx
	mov $0x7, %bx
	mov $msg, %bp
	mov $0x1301, %ax
	int $0x10
1:  
	jmp 1b
.org	  0x1fe,	0x90
.word	  0xaa55
