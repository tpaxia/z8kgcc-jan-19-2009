/* $Id: _pcos_lookbyte.S,v 1.2 2003/08/18 00:18:12 chris Exp $
 * LookByte PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_lookbyte(int did, unsigned char *byte, unsigned char *buffer_status); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_lookbyte.S"
	segm

	.text
	even
global	__pcos_lookbyte

__pcos_lookbyte:

/*
 * do a LookByte (9) call
 * in  r8  - did
 * out r5  - status
 *     rl7 - byte
 *     rh7 - buffer status (0 - empty/0xff - not empty)
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
#else
	ld	r8,r7		! did
	ldl	rr12,rr4	! save rr4, b/c r5 gets destroyed by sc
#endif
	sc	#9		! LookByte

#ifdef __STD_CALL__
	ldl	rr12,rr14(#18)	! get pointer to return value
#endif
	ldb	@rr12,rl7
#ifdef __STD_CALL__
	ldl	rr12,rr14(#22)	! get pointer to buffer status
	ldb	@rr12,rh7
#else
	ldb	@rr2,rh7
#endif
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
