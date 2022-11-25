/* $Id: _pcos_setcontrolbyte.S,v 1.1 2003/04/08 23:11:55 chris Exp $
 * SetControlByte PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_setcontrolbyte(int did, unsigned int word_number, unsigned int word); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_setcontrolbyte.S"
	segm

	.text
	even
global	__pcos_setcontrolbyte

__pcos_setcontrolbyte:

/*
 * do a SetControlByte (20) call
 * in  r8  - did
 *     r9  - word number
 *     r10 - word
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
	ld	r9,rr14(#18)	! r9 contains word number
	ld	r10,rr14(#20)	! r10 contains new value
#else
	ld	r8,r7		! did
	ld	r9,r6		! r9 contains word number
	ld	r10,r5		! r10 contains new value
#endif
	sc	#20		! SetControlByte
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
