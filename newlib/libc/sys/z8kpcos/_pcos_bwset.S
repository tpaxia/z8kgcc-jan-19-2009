/* $Id: _pcos_bwset.S,v 1.1 2004/03/13 00:52:54 chris Exp $
 * BWSet PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_bwset(void *dest, unsigned short val, unsigned int len); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_bwset.S"
	segm

	.text
	even
global	__pcos_bwset

__pcos_bwset:

/*
 * do a BWSet (30) call
 *
 * in  r7   - value
 *     rr8  - dest
 *     r10  - length
 * out r5   - status
 */

	dec	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr8,rr14(#16)	! dest
	ld	r7,rr14(#20)	! value
	ld	r10,rr14(#22)	! length
#else
	ldl	rr8,rr6		! dest
	ld	r7,r5		! value
	ld	r10,r4		! length
#endif
	sc	#30		! BWSet

	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
