/* $Id: _pcos_chgcur1.S,v 1.1 2003/04/05 01:07:13 chris Exp $
 * ChgCur1 PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_chgcur1(unsigned int x_pos, unsigned int y_pos); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_chgcur1.S"
	segm

	.text
	even

global	__pcos_chgcur1
__pcos_chgcur1:

/*
 * do a ChgCur1 (37) call
 * in  r8 - x
 *     r9 - y
 * out r5 - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r8,rr14(#16)	! x
	ld	r9,rr14(#18)	! y
#else
	ld	r8,r7
	ld	r9,r6
#endif

	sc	#37		! ChgCur1
	ld	RET_REG,r5	! status
	
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
