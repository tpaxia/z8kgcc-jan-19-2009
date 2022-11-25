/* $Id: _pcos_chgwindow.S,v 1.1 2003/04/07 22:16:33 chris Exp $
 * ChgWindow PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_chgwindow(unsigned int fgcolor, unsigned int bgcolor); */

	name	"_pcos_chgwindow.S"
	segm

	.text
	even

global	__pcos_chgwindow
__pcos_chgwindow:

/*
 * do a ChgWindow (50) call
 * in  r8 - foreground color
 *     r9 - background color
 * out r5 - status
 */
	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r8,rr14(#16)
        ld	r9,rr14(#18)
#else
	ld	r8,r7
	ld	r9,r6
#endif
	sc	#50		! ChgWindow
	
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
