/* $Id: _pcos_newsamesegment.S,v 1.1 2004/03/13 23:21:45 chris Exp $
 * NewSameSegment PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_newsamesegment(unsigned short length, void **memory); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_newsamesegment.S"
	segm

	.text
	even
global	__pcos_newsamesegment

__pcos_newsamesegment:

/*
 * do a NewSameSegment (33) call
 * in  rr8  - ptr to new address
 *     r10  - length
 * out r5   - status
 *     @rr8 - updated with address
 */


	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r10,rr14(#16)	! length
	ldl	rr8,rr14(#18)
#else
	ld	r10,r7		! length
	ldl	rr8,rr4
#endif
	sc	#33		! NewSameSegment
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
