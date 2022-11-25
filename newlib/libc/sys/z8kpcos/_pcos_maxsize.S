/* $Id: _pcos_maxsize.S,v 1.4 2003/08/18 00:18:12 chris Exp $
 * MaxSize PCOS system call
 * Copyright (c) 2002,2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_maxsize(unsigned short *maxsize); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_maxsize.S"
	segm

	.text
	even
global	__pcos_maxsize

__pcos_maxsize:

/*
 * do a PCOS MaxSize (99) call
 * out r8 - maxsize
 *     r5 - status
 * return PCOS error/status value
 */

	dec	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifndef __STD_CALL__
	ldl	rr12,rr6
#endif
	sc	#99		! MaxSize
	ld	RET_REG,r5	! status
#ifdef __STD_CALL__
	ldl	rr12,rr14(#16)	! get pointer to return value
#endif
	ld	@rr12,r8

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
