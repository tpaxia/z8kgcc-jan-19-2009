/* $Id: _pcos_putbyte.S,v 1.3 2002/12/19 00:29:11 chris Exp $
 * PutByte PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_putbyte(int did, unsigned char byte); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_putbyte.S"
	segm

	.text
	even
global	__pcos_putbyte

__pcos_putbyte:

/*
 * do a PutByte (11) call
 * in  r8  - did
 *     rl7 - byte
 * out r5  - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
	ld	r7,rr14(#18)	! rl7 contains data byte
#else
	ld	r8,r7		! did
	ldb	rl7,rl6		! data byte
#endif
	sc	#11		! PutByte
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
