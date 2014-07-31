
#include "types.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"

#define BACKSPACE 0x100
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

void* memset(void *dst, int c, uint n)
{
	if ((int)dst%4 == 0 && n%4 == 0){
		c &= 0xFF;
		stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
	} else
		stosb(dst, c, n);
	return dst;
}

void* memmove(void *dst, const void *src, uint n)
{ 
	const char *s;
	char *d;

	s = src;
	d = dst;
	if(s < d && s + n > d){
		s += n;
		d += n;
		while(n-- > 0)
			*--d = *--s;
	} else {
		while(n-- > 0){
			*d++ = *s++;
		}
	}

	return dst;
}

static void cgaputc(int c)
{
	int pos;

	// Cursor position: col + 80*row.
	outb(CRTPORT, 14);
	pos = inb(CRTPORT+1) << 8;
	outb(CRTPORT, 15);
	pos |= inb(CRTPORT+1);

	if(c == '\n')
		pos += 80 - pos%80;
	else if(c == BACKSPACE){
		if(pos > 0) --pos;
	} else
		crt[pos++] = (c&0xff) | 0x0700;  // black on white

	if((pos/80) >= 24){  // Scroll up.
		memmove(crt, crt+80, sizeof(crt[0])*23*80);
		pos -= 80;
		memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
	}

	outb(CRTPORT, 14);
	outb(CRTPORT+1, pos>>8);
	outb(CRTPORT, 15);
	outb(CRTPORT+1, pos);
	crt[pos] = ' ' | 0x0700;
}

int main(void)
{
	char* buf = "starting mos ...";
	char* s = buf;
	for(; *s; s++)
	    cgaputc((*s) & 0xff);
	return 0;
}

// Boot page table used in entry.S and entryother.S.
// Page directories (and page tables), must start on a page boundary,
// hence the "__aligned__" attribute.  
// Use PTE_PS in page directory entry to enable 4Mbyte pages.
__attribute__((__aligned__(PGSIZE)))
pde_t entrypgdir[NPDENTRIES] = {
  // Map VA's [0, 4MB) to PA's [0, 4MB)
  [0] = (0) | PTE_P | PTE_W | PTE_PS,
  // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
  [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
};
