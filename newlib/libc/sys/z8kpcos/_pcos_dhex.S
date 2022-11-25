/* $Id: _pcos_dhex.S,v 1.1 2004/03/16 22:23:06 chris Exp $
 * DHex PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dhex(unsigned int word); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dhex.S"
	segm

	.text
	even

global	__pcos_dhex
__pcos_dhex:

/*
 * do a DHex (92) call
 * in  r12 - word
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r12,rr14(#16)
#else
	ld	r12,r7
#endif
	sc	#92		! DHex

	ld	RET_REG,r5
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
