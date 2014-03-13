AS86	= as86 -0 -a
LD86	= ld86 -0

AS		= as
LD		= ld
LDFLAGS	= --oformat binary -N -e startup_32 -Ttext 0x0000

.s.o:
	$(AS) -o $*.o $<

all: floppy.img

floppy.img: Image
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=Image of=floppy.img bs=2048 count=1 conv=notrunc
	sync

Image: boot/boot tools/system  tools/build
	tools/build boot/boot tools/system  > Image
	sync

boot/head.o: boot/head.s

tools/build: tools/build.c
	$(CC) $(CFLAGS) -o tools/build tools/build.c

tools/system: boot/head.o
	$(LD) $(LDFLAGS) boot/head.o -o tools/system > System.map

boot/boot: boot/boot.s
	$(AS86) -o boot/boot.o boot/boot.s
	$(LD86) -s -o boot/boot boot/boot.o

clean:
	rm -f boot/*.o
	rm -f boot/boot
	rm -f tools/build
	rm -f tools/system
	rm -f boot/head.o
	rm -f boot/head
	rm -f System.map
	rm -f floppy.img
	rm -f Image
