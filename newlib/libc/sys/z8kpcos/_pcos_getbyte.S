/* $Id: _pcos_getbyte.S,v 1.3 2002/12/19 01:36:14 chris Exp $
 * GetByte PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_getbyte(int did, unsigned char *byte); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_getbyte.S"
	segm

	.text
	even
global	__pcos_getbyte

__pcos_getbyte:

/*
 * do a GetByte (10) call
 * in  r8  - did
 * out r5  - status
 *     r7  - byte
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
#else
	ld	r8,r7		! did
	ldl	rr12,rr4	! save rr4, b/c r5 gets destroyed by sc
#endif
	sc	#10		! GetByte

#ifdef __STD_CALL__
	ldl	rr12,rr14(#18)	! get pointer to return value
#endif
	ldb	@rr12,rl7

	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
