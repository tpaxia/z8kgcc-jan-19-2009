/* $Id: _pcos_scrolltext.S,v 1.1 2004/05/23 00:24:39 chris Exp $
 * ScrollText PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_scrolltext(unsigned int plane_mask,
			unsigned int function,
			unsigned int src_x,
			unsigned int src_y,
			unsigned int dst_x,
			unsigned int dst_y,
			unsigned int xlen,
			unsigned int ylen);
 */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_scrolltext.S"
	segm

	.text
	even
global	__pcos_scrolltext

__pcos_scrolltext:

/*
 * do a ScrollText (116) call
 * in  r6  - colour plane mask
 *     r7  - function
 *     r8  - src_x     (1based)
 *     r9  - src_y     (1based)
 *     r10 - dst_x     (1based)
 *     r11 - dst_y     (1based)
 *     r12 - xlen
 *     r13 - ylen
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr6,rr14(#16)
	ldl	rr8,rr14(#20)
	ldl	rr10,rr14(#24)
	ldl	rr12,rr14(#28)
#else
	ex	r6,r7
	ld	r8,r5
	ld	r9,r4
	ld	r10,r3
	ld	r11,r2
	ld	r12,rr14(#16)
	ld	r13,rr14(#18)
#endif
	sc	#116		! ScrollText
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
