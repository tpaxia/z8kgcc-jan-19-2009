/* $Id: _pcos_readcur1.S,v 1.2 2003/04/08 23:11:01 chris Exp $
 * ReadCur1 PCOS system call
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_readcur1(cursor_shape *shape, unsigned int *blinkrate,
                      insigned int *x_pos, unsigned int *y_pos); */

#define ERRNO_VALS_ONLY
#include <sys/pcos.h>

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_readcur1.S"
	segm

	.text
	even

global	__pcos_readcur1
__pcos_readcur1:

/*
 * do a ReadCur1 (43) call
 * in  rr10 - ptr to cursor shape buffer
 * out r5   - status
 *     r7   - blinkrate
 *     r8   - x position
 *     r9   - y position
 */

	sub	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs

#ifdef __STD_CALL__
        ldl     rr10,rr14(#16)  ! get pointer to cursor shape buffer
#else
        ldl     rr10,rr6
	push	@sp,r5
#endif

	sc	#43		! ReadCur1
	cp	r5,#PCOS_ERR_OK

#ifdef __STD_CALL__
	jr	ne,ret		! error occurred
	ldl	rr10,rr14(#20)
	ld	@rr10,r7	! blink rate
	ldl	rr10,rr14(#24)
	ld	@rr10,r8	! x pos
	ldl	rr10,rr14(#28)
	ld	@rr10,r9	! y pos
#else
	jr	ne,ret1		! error occurred
	ld	r1,r5		! save return status
	pop	r5,@sp
	ld	@rr4,r7		! blink rate
	ld	@rr2,r8		! x pos
	ldl	rr2,rr14(#16)
	ld	@rr2,r9		! y pos
	ld	RET_REG,r1	! status
	jr	t,ret2
#endif

ret:	ld	RET_REG,r5	! status
	
ret2:	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

#ifndef __STD_CALL__
ret1:	inc	r14,#2
	jr	t,ret
#endif

	.end
