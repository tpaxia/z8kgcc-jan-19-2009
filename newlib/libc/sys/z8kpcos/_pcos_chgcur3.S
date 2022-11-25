/* $Id: _pcos_chgcur3.S,v 1.1 2003/04/05 01:07:13 chris Exp $
 * ChgCur3 PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* void _pcos_chgcur3(unsigned int blinkrate); */

	name	"_pcos_chgcur3.S"
	segm

	.text
	even

global	__pcos_chgcur3
__pcos_chgcur3:

/*
 * do a ChgCur3 (39) call
 * in  r8 - blinkrate
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r8,rr14(#16)
#else
	ld	r8,r7
#endif
	sc	#39		! ChgCur3
	
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
