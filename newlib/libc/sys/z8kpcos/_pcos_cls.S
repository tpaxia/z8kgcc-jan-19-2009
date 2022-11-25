/* $Id: _pcos_cls.S,v 1.1 2003/04/05 01:07:13 chris Exp $
 * Cls PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* void _pcos_cls(void) */

	name	"_pcos_cls.S"
	segm

	.text
	even
global	__pcos_cls

__pcos_cls:

/*
 * do a Cls (35) call
 */

/* I don't know the register usage of PCOS, so trying to be on the
 * save side, I save all important (for C) registers....
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
	sc	#35		! Cls
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
