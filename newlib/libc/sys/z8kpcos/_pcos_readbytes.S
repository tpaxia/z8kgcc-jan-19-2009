/* $Id: _pcos_readbytes.S,v 1.3 2002/12/19 23:48:36 chris Exp $
 * ReadBytes PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_readbytes(int did, const void *buffer, unsigned int nbytes, unsigned int *retbytes); */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_readbytes.S"
	segm

	.text
	even
global	__pcos_readbytes

__pcos_readbytes:

/*
 * do a ReadBytes (12) call
 *
 * in  r8   - did
 *     r9   - count
 *     rr10 - buf
 * out r5   - status
 *     r7   - read count
 */

	dec	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r8,rr14(#16)	! did
	ldl	rr10,rr14(#18)	! buffer
	ld	r9,rr14(#22)	! nbytes
#else
	ld	r8,r7		! did
	ldl	rr10,rr4	! buffer
	ld	r9,r3		! nbytes
#endif
	sc	#12		! ReadBytes

#ifdef __STD_CALL__
	ldl	rr12,rr14(#24)	! ptr to retbytes
#else
	ldl	rr12,rr14(#16)	! ptr to retbytes
#endif
	ld	@rr12,r7
	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
