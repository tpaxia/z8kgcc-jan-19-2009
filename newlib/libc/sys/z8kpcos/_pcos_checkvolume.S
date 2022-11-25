/* $Id: _pcos_checkvolume.S,v 1.1 2004/03/16 22:23:06 chris Exp $
 * CheckVolume PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_checkvolume(void); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_checkvolume.S"
	segm

	.text
	even
global	__pcos_checkvolume

__pcos_checkvolume:

/*
 * do a CheckVolume (97) call
 * out r5  - status
 */

/* I don't know the register usage of PCOS, so trying to be on the
 * save side, I save all important (for C) registers....
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
	sc	#97		! CheckVolume
	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
