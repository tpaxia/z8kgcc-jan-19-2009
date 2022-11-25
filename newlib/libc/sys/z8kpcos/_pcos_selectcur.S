/* $Id: _pcos_selectcur.S,v 1.3 2002/12/19 23:47:35 chris Exp $
 * SelectCur PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* void _pcos_selectcur(int mode); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_selectcur.S"
	segm

	.text
	even
global	__pcos_selectcur

__pcos_selectcur:

/*
 * do a SelectCur (44) call
 * in  r8  - select mode (0 - off, 1 - gr. cursor on, 2 - text cursor on)
 */

	sub	r15,#28		! make space on the stack to
	ldm	@rr14,r0,#14	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#32)	! mode
#else
	ld	r8,r7		! mode
#endif
	sc	#44		! SelectCur

	ldm	r0,@rr14,#14	! restore regs
	add	r15,#28
	ret

	.end
