/* $Id: _pcos_crlf.S,v 1.1 2004/03/13 23:21:45 chris Exp $
 * CrLf PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_crlf(void); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_crlf.S"
	segm

	.text
	even
global	__pcos_crlf

__pcos_crlf:

/*
 * do a Cls (90) call
 * out r5  - status
 */

/* I don't know the register usage of PCOS, so trying to be on the
 * save side, I save all important (for C) registers....
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
	sc	#90		! CrLf
	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
