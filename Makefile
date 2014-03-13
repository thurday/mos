AS86	= as86 -0 -a
LD86	= ld86 -0

AS		= as
LD		= ld
LDFLAG	= -s -x -M


all: floppy.img

floppy.img: Image
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=Image of=floppy.img bs=512 count=1 conv=notrunc
	sync

Image: boot/boot tools/build
	tools/build boot/boot > Image
	sync

tools/build: tools/build.c
	$(CC) $(CFLAGS) -o tools/build tools/build.c


boot/boot: boot/boot.s
	$(AS86) -o boot/boot.o boot/boot.s
	$(LD86) -s -o boot/boot boot/boot.o

clean:
	rm -f boot/*.o
	rm -f boot/boot
	rm -f tools/build
	rm -f Image
