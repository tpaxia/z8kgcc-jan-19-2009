/* $Id: _pcos_grfinit.S,v 1.1 2004/03/13 23:21:45 chris Exp $
 * GrfInit PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* void _pcos_grfinit(int *color, void **pointer); */

	name	"_pcos_grfinit.S"
	segm

	.text
	even
global	__pcos_grfinit

__pcos_grfinit:

/*
 * do a GrfInit (45) call
 * out r8   - color flag
 *     rr10 - pointer
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifndef __STD_CALL__
	ldl	rr12,rr4	! save rr4, since r5 is destroyed by GrfInit
#endif
	sc	#45		! GrfInit

#ifdef __STD_CALL__
	ldl	rr12,rr14(#16)	! pointer to color
	ld	@rr12,r8
	ldl	rr12,rr14(#20)	! pointer to pointer
	ldl	@rr12,rr10
#else
	ld	@rr6,r8		! color
	ldl	@rr12,rr10	! pointer
#endif

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
