/* $Id: _pcos_dhexbyte.S,v 1.1 2004/03/16 22:23:06 chris Exp $
 * DHexByte PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dhexbyte(unsigned char byte); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dhexbyte.S"
	segm

	.text
	even

global	__pcos_dhexbyte
__pcos_dhexbyte:

/*
 * do a DHexByte (91) call
 * in  r12 - byte
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ld	r12,rr14(#16)
#else
	ld	r12,r7
#endif
	sc	#91		! DHexByte

	ld	RET_REG,r5	
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
