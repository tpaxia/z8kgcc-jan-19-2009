/* $Id: _pcos_cleartext.S,v 1.1 2004/05/22 23:11:07 chris Exp $
 * ClearText PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_cleartext(unsigned int column, unsigned int row, unsigned int xlen, unsigned int ylen); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_cleartext.S"
	segm

	.text
	even
global	__pcos_cleartext

__pcos_cleartext:

/*
 * do a ClearText (115) call
 * in  r10 - x         (1based)
 *     r11 - y         (1based)
 *     r12 - xlen
 *     r13 - ylen
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr10,rr14(#16)
	ldl	rr12,rr14(#20)
#else
	ld	r10,r7
	ld	r11,r6
	ld	r12,r5
	ld	r13,r4
#endif
	sc	#115		! ClearText
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
