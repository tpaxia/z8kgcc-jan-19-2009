/* $Id: _pcos_drename.S,v 1.3 2003/08/18 00:18:12 chris Exp $
 * DRename PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_drename(const char *from, int fromlen, const char *to, int tolen) */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_drename.S"
	segm

	.text
	even
global	__pcos_drename

__pcos_drename:


/*
 * do a DRename (27) call
 * in  rr6  - pointer to old name
 *     r8   - length of old name
 *     rr10 - pointer to new name
 *     r9   - length of new name
 * out r5   - status
 */

	sub	r15,#16		! make space on the stack to
	ldm	@rr14,r6,#8	! save regs
#ifdef __STD_CALL__
	ldl	rr6,rr14(#20)	! ptr to old name
	ld	r8,rr14(#24)	! lenght of old name
	ldl	rr10,rr14(#26)	! ptr to new name
	ld	r9,rr14(#30)	! lenght of new name
#else
				! rr6 already matches
	ld	r8,r5		! lenght of old name
	ldl	rr10,rr2	! ptr to new name
	ld	r9,rr14(#20)	! lenght of new name
#endif
	sc	#27		! DREname
	ldm	r6,@rr14,#6	! restore regs
	inc	r15,#16
	ld	RET_REG,r5	! status
	ret

	.end
