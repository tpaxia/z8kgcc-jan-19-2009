/* $Id: _pcos_resetbyte.S,v 1.1 2003/04/10 10:10:38 chris Exp $
 * ResetByte PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_resetbyte(int did); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_resetbyte.S"
	segm

	.text
	even
global	__pcos_resetbyte

__pcos_resetbyte:

/*
 * do a ResetByte (18) call
 * in  r8 - did
 * out r5 - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
#else
	ld	r8,r7		! did
#endif
	sc	#18		! ResetByte
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
