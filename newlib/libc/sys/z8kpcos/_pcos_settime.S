/* $Id: _pcos_settime.S,v 1.1 2004/03/16 22:23:06 chris Exp $
 * SetTime PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_settime(char *buf, unsigned int buflen); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_settime.S"
	segm

	.text
	even
global	__pcos_settime

__pcos_settime:

/*
 * do a SetTime (73) call
 * in  rr8 - buffer address
 *     r10 - buffer length   (8 bytes at least)
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr8,rr14(#16)	! buffer address
	ld	r10,rr14(#20)	! buffer length
#else
	ldl	rr8,rr6		! buffer address
	ld	r10,r5		! buffer length
#endif
	sc	#73		! SetTime
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
