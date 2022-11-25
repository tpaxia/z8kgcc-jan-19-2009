/* $Id: _pcos_dseek.S,v 1.3 2003/04/21 20:12:15 chris Exp $
 * DSeek PCOS system call
 * Copyright (c) 2002,2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dseek(int did, unsigned long offset); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dseek.S"
	segm

	.text
	even
global	__pcos_dseek

__pcos_dseek:

/*
 * do a PCOS DSeek (23) call
 * in  r8   - did
 *     rr10 - position
 * out r5   - status
 * return PCOS error/status value
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
	ldl	rr10,rr14(#18)	! get position to seek to
#else
	ld	r8,r7		! did
	ldl	rr10,rr4	! get position to seek to
#endif
	sc	#23		! DSeek
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
