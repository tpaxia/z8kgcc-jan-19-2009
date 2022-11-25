/* $Id: _pcos_ddirectory.S,v 1.1 2004/03/13 00:52:54 chris Exp $
 * DDirectory PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_ddirectory(const char *name, int namelen) */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_ddirectory.S"
	segm

	.text
	even
global	__pcos_ddirectory

__pcos_ddirectory:

/*
 * do a DDirectory (28) call
 * in  rr10 - pointer to name
 *     r9   - length of name
 * out r5   - status
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ldl	rr10,rr14(#16)	! ptr to name
	ld	r9,rr14(#20)	! namelen
#else
	ldl	rr10,rr6	! ptr to name
	ld	r9,r5		! namelen
#endif
	sc	#28		! DDirectory
	ld	RET_REG,r5	! status
	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
