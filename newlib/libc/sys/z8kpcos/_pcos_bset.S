/* $Id: _pcos_bset.S,v 1.1 2004/03/13 00:52:54 chris Exp $
 * BSet PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_bset(void *dest, unsigned char val, unsigned int len); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_bset.S"
	segm

	.text
	even
global	__pcos_bset

__pcos_bset:

/*
 * do a BSet (29) call
 *
 * in  rl7  - value
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
	ldb	rl7,rl5		! value
	ld	r10,r4		! length
#endif
	sc	#29		! BSet

	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
