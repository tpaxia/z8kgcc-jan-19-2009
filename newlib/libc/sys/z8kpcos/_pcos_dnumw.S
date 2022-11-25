/* $Id: _pcos_dnumw.S,v 1.1 2004/03/16 22:23:06 chris Exp $
 * DNumW PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dnumw(unsigned int word, unsigned int field_width); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dnumw.S"
	segm

	.text
	even

global	__pcos_dnumw
__pcos_dnumw:

/*
 * do a DNumW (94) call
 * in  r12 - word
 *     r13 - field width
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r12,rr14(#16)
        ld	r13,rr14(#18)
#else
	ld	r12,r7
	ld	r13,r6
#endif
	sc	#94		! DNumW

	ld	RET_REG,r5
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
