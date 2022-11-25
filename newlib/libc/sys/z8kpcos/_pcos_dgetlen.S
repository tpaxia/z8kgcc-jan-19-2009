/* $Id: _pcos_dgetlen.S,v 1.2 2002/12/23 20:35:51 chris Exp $
 * DGetLen PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_dgetlen(int did, unsigned long *length); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_dgetlen.S"
	segm

	.text
	even
global	__pcos_dgetlen

__pcos_dgetlen:

/*
 * do a PCOS DGetLen (24) call
 * in  r8   - did
 * out rr10 - lenght
 *     r5   - status
 * return PCOS error/status value
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
#else
	ld	r8,r7		! did
	ldl	rr12,rr4
#endif
	sc	#24		! DGetLen
	ld	RET_REG,r5	! status
#ifdef __STD_CALL__
	ldl	rr12,rr14(#18)	! get pointer to return value
#endif
	ldl	@rr12,rr10

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
