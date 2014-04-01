
AS	 = as
LD	 = ld
LDFLAGS0 = -s -e start -Ttext 0x0000 --oformat binary
LDFLAGS1 = -Ttext 0x0000 -e startup_32 --oformat binary

disk: floppy.img

floppy.img: Image
	dd if=/dev/zero of=bochs/floppy.img bs=1024 count=1440
	dd if=Image of=bochs/floppy.img bs=2048 count=1 conv=notrunc
	sync

all: Image

Image: tools/boot tools/head
	cat tools/boot boot/head > Image
	sync

tools/boot: boot/boot.s
	$(AS) -o boot/boot.o boot/boot.s
	$(LD) $(LDFLAGS0) -o tools/boot boot/boot.o

tools/head: boot/head.s
	$(AS) -o boot/head.o boot/head.s
	$(LD) $(LDFLAGS1) boot/head.o -o tools/head > tools/System.map

clean:
	rm -f boot/*.o
	rm -f tools/System.map
	rm -f tools/boot
	rm -f tools/head
	rm -f Image
