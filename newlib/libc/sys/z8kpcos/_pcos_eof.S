/* $Id: _pcos_eof.S,v 1.1 2004/03/13 00:52:54 chris Exp $
 * Eof PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_eof(int did, unsigned int *status); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_eof.S"
	segm

	.text
	even
global	__pcos_eof

__pcos_eof:

/*
 * do a Eof (16) call
 * in  r8  - did
 * out r5  - status
 *     r9  - line status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
#else
	ld	r8,r7		! did
	ldl	rr12,rr4	! save rr4, b/c r5 gets destroyed by sc
#endif
	sc	#16		! Eof

#ifdef __STD_CALL__
	ldl	rr12,rr14(#18)	! get pointer to return value
#endif
	ld	@rr12,r9

	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
