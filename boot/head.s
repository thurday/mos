.text
.globl startup_32
.org 0

startup_32:
	movl $0x10,%eax
	movw %ax,  %ds
	movw %ax,  %es
	movw %ax,  %fs
	movw %ax,  %gs
	movw %ax,  %ss

	
	
ok_msg:	
	jmp  ok_msg

msg:
	.string "MOS into PM ...\x0"


	
