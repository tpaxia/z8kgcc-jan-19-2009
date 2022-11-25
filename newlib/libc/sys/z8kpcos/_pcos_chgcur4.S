/* $Id: _pcos_chgcur4.S,v 1.1 2004/03/13 23:21:45 chris Exp $
 * ChgCur4 PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* void _pcos_chgcur4(cursor_shape new_shape); */

	name	"_pcos_chgcur4.S"
	segm

	.text
	even

global	__pcos_chgcur4
__pcos_chgcur4:

/*
 * do a ChgCur4 (40) call
 * in  rr8 - pointer to new cursor data
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ldl	rr8,rr14(#16)
#else
	ldl	rr8,rr6
#endif
	sc	#40		! ChgCur4
	
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
