/* $Id: _pcos_bclear.S,v 1.1 2004/03/13 00:52:54 chris Exp $
 * BClear PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_bclear(void *dest, unsigned int len); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_bclear.S"
	segm

	.text
	even
global	__pcos_bclear

__pcos_bclear:

/*
 * do a BClear (31) call
 *
 * in  rr8  - dest
 *     r10  - length
 * out r5   - status
 */

	dec	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr8,rr14(#16)	! dest
	ld	r10,rr14(#20)	! length
#else
	ldl	rr8,rr6		! dest
	ld	r10,r5		! length
#endif
	sc	#31		! BClear

	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
