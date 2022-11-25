/* $Id: _pcos_dispose.S,v 1.2 2002/12/23 20:35:52 chris Exp $
 * Dispose PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dispose(int length, void **memory); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dispose.S"
	segm

	.text
	even
global	__pcos_dispose

__pcos_dispose:

/*
 * do a Dispose (34) call
 * in  rr8  - ptr to address to free
 *     r10  - length
 * out r5   - status
 *     @rr8 - updated with 0xffffffff
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
	sc	#34		! Dispose
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
