.text
.globl startup_32

startup_32:
	movl $0x10,%eax
	movw %ax,  %ds
	movw %ax,  %es
	movw %ax,  %fs
	movw %ax,  %gs
	movw %ax,  %ss
	movl $0x7c00,%esp

	movl $msg, %esi
	movl $0xb8000, %edi
	movl %edi,   %eax
	addl $160,   %eax
	movl %eax,   %edi
	cld
	movb $0x07,  %ah

print_c:
	cmp $0, (%esi)
	je die
	lodsb
	stosw
	jmp print_c
	
die:	
	jmp  die

msg:
	.string "MOS into PM ....\x0\x0\x0\x0"


	
