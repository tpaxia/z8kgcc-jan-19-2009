/* $Id: _pcos_close.S,v 1.3 2003/08/18 00:18:12 chris Exp $
 * Close PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_close(int did) */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_close.S"
	segm

	.text
	even
global	__pcos_close

__pcos_close:


/*
 * do a Close (19) call
 * in  r8   - did
 * out r5   - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
#else
	ld	r8,r7		! did
#endif
	sc	#19		! Close
	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
