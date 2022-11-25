/* $Id: _pcos_getstatusbyte.S,v 1.2 2003/08/18 00:18:12 chris Exp $
 * GetStatusByte PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_getstatusbyte(int did, unsigned int word_number, unsigned int *word); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_getstatusbyte.S"
	segm

	.text
	even
global	__pcos_getstatusbyte

__pcos_getstatusbyte:

/*
 * do a GetStatusByte (21) call
 * in  r8  - did
 *     r9  - word number
 * out r5  - status
 *     r10 - word
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
	ld	r9,rr14(#18)	! r9 contains word number
#else
	ld	r8,r7		! did
	ld	r9,r6		! r9 contains word number
	ldl	rr12,rr4
#endif
	sc	#21		! GetStatusByte

#ifdef __STD_CALL__
	ldl	rr12,rr14(#20)	! pointer to return value
#endif
	ld	@rr12,r10

	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
