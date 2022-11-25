/* $Id: _pcos_dhexlong.S,v 1.1 2004/03/16 22:23:06 chris Exp $
 * DHexLong PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dhexlong(unsigned long byte); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dhexlong.S"
	segm

	.text
	even

global	__pcos_dhexlong
__pcos_dhexlong:

/*
 * do a DHexLong (93) call
 * in  r12 - word
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ldl	rr12,rr14(#16)
#else
	ldl	rr12,rr6
#endif
	sc	#93		! DHexLong

	ld	RET_REG,r5
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
