
sectors = 18

.global begtext, begdata, begbss, endtext, enddata, endbss
.text
begtext:
.data
begdata:
.bss
begbss:
.text

BOOTSEG = 0x07c0
INITSEG = 0x9000
SYSSEG  = 0x1000
SYSLEN  = 17

entry start
start:
	mov ax, #BOOTSEG
	mov ds, ax
	mov ax, #INITSEG
	mov es, ax
	mov cx, #256
	sub si,	si
	sub di, di
	rep
	movw
	jmpi go, INITSEG

go:
	mov ax, cs
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, #0x400
	
	mov ah, #0x03
	xor bh, bh
	int 0x10

	mov cx, #24
	mov bx, #0x7
	mov bp, #load_msg
	mov ax, #0x1301
	int 0x10

load_system:
	mov	dx, #0x0000
	mov	cx, #0x0002
	mov	ax, #SYSSEG
	mov	es, ax
	mov	bx, #0x0000
	mov	ax, #0x200+SYSLEN
	int 0x13
	jnc	ok_load
	mov	dx, #0x0000
	mov	ax, #0x0000
	int	0x13
	jmp	load_system

ok_load:
	call kill_motor

	mov	ah,#0x03
	xor	bh,bh
	int	0x10 
	mov	[510],dx
	
	cli

	mov	ax, #0x0000
	cld

do_move:
	mov es, ax
	add ax, #0x1000
	cmp ax, #0x9000
	jz end_move
	mov ds, ax
	sub di, di
	sub si, si
	mov cx, #0x200
	rep
	movsw
	jmp do_move

end_move:
	mov ax, cs
	mov ds, ax
	lidt idt_48
	lgdt gdt_48

	call empty_8042
	mov	al, #0xD1
	out	#0x64, al
	call empty_8042
	mov	al, #0xDF
	out	#0x60, al
	call empty_8042


	mov	al,#0x11
	out	#0x20,al
	.word	0x00eb,0x00eb
	out	#0xA0,al
	.word	0x00eb,0x00eb
	mov	al,#0x20
	out	#0x21,al
	.word	0x00eb,0x00eb
	mov	al,#0x28
	out	#0xA1,al
	.word	0x00eb,0x00eb
	mov	al,#0x04
	out	#0x21,al
	.word	0x00eb,0x00eb
	mov	al,#0x02
	out	#0xA1,al
	.word	0x00eb,0x00eb
	mov	al,#0x01
	out	#0x21,al
	.word	0x00eb,0x00eb
	out	#0xA1,al
	.word	0x00eb,0x00eb
	mov	al,#0xFF
	out	#0x21,al
	.word	0x00eb,0x00eb
	out	#0xA1,al

	mov	ax,#0x0001
	lmsw ax
	jmpi 0, 8

empty_8042:
	.word 0x00eb,0x00eb
	in	 al,#0x64
	test al,#2
	jnz	 empty_8042
	ret

kill_motor:
	push dx
	mov  dx, #0x3f2
	mov  al, #0
	outb
	pop  dx
	ret

gdt:
	.word	0,0,0,0		; dummy

	.word	0xFFFF		; 4G
	.word	0x0000		; base address=0
	.word	0x9A00		; code read/exec
	.word	0x00C0		; granularity=4096, 386

	.word	0xFFFF		; 4G
	.word	0x0000		; base address=0
	.word	0x9200		; data read/write
	.word	0x00C0		; granularity=4096, 386

idt_48:
	.word	0			; idt limit=0
	.word	0,0			; idt base=0L

gdt_48:
	.word	0x800		; gdt limit=2048, 256 GDT entries
	.word   gdt,0x9		; gdt base = 0X9xxxx

load_msg:
	.byte 13,10
	.ascii "Load MOS in REAL ..."
	.byte 13,10,13,10

.text
endtext:
.data
enddata:
.bss
endbss:
