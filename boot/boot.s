
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
ROOT_DEV= 0x301

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

loop_label:
	jmp loop_label

load_msg:
	.byte 13,10
	.ascii "Load MOS ..."
	.byte 13,10,13,10
	.org 508

root_dev:
	.word ROOT_DEV

boot_flag:
	.word 0xaa55

.text
endtext:
.data
enddata:
.bss
endbss:
