/* $Id: _pcos_new.S,v 1.2 2002/12/23 20:35:53 chris Exp $
 * New PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_new(unsigned short length, void **memory); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_new.S"
	segm

	.text
	even
global	__pcos_new

__pcos_new:

/*
 * do a New (120) call
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
	sc	#120		! New
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
