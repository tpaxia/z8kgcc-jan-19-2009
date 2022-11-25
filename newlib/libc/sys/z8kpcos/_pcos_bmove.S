/* $Id: _pcos_bmove.S,v 1.1 2004/03/13 00:52:54 chris Exp $
 * BMove PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_bmove(void *dest, const void *src, unsigned int len); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_bmove.S"
	segm

	.text
	even
global	__pcos_bmove

__pcos_bmove:

/*
 * do a BMove (32) call
 *
 * in  r7   - length
 *     rr8  - src
 *     rr10 - dest
 * out r5   - status
 */

	dec	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr10,rr14(#16)	! dest
	ldl	rr8,rr14(#20)	! src
	ld	r7,rr14(#24)	! length
#else
	ldl	rr10,rr6	! dest
	ldl	rr8,rr4		! src
	ld	r7,r3		! length
#endif
	sc	#32		! BMove

	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
