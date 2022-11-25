/* $Id: _pcos_chgcur0.S,v 1.1 2003/04/05 01:07:13 chris Exp $
 * ChgCur0 PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_chgcur0(unsigned int column, unsigned int row); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_chgcur0.S"
	segm

	.text
	even

global	__pcos_chgcur0
__pcos_chgcur0:

/*
 * do a ChgCur0 (36) call
 * in  r8 - column
 *     r9 - row
 * out r5 - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r8,rr14(#16)	! column
	ld	r9,rr14(#18)	! row
#else
	ld	r8,r7
	ld	r9,r6
#endif

	sc	#36		! ChgCur0
	ld	RET_REG,r5	! status
	
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
