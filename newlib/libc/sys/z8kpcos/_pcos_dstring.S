/* $Id: _pcos_dstring.S,v 1.1 2003/04/10 10:09:53 chris Exp $
 * DString PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dstring(char *string); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dstring.S"
	segm

	.text
	even
global	__pcos_dstring

__pcos_dstring:

/*
 * do a DString (89) call
 * in  rr12 - string address
 * out r5   - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr12,rr14(#16)	! string address
#else
	ldl	rr12,rr6	! string address
#endif
	sc	#89		! DString
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
