AS=as
LD=ld

.s.o:
	${AS} -a $< -o $*.o >$*.map

all: floppy.img

floppy.img: bootsect
	mv bootsect floppy.img

bootsect: bootsect.o
	${LD} --oformat binary -N -e start -Ttext 0x7c00 -o bootsect $<
