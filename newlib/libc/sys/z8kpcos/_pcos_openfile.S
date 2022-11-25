/* $Id: _pcos_openfile.S,v 1.2 2002/12/19 23:48:36 chris Exp $
 * OpenFile PCOS system call
 * Copyright (c) 2002 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_openfile(int did, const char *name, int namelen, int mode, int extent_len) */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_openfile.S"
	segm

	.text
	even
global	__pcos_openfile

__pcos_openfile:

/*
 * do a OpenFile (22) call
 * in  r6   - extent length
 *     r7   - mode
 *     r8   - did
 *     r9   - name length
 *     rr10 - ptr to name
 * out r5   - status
 */

	sub	r15,#16		! make space on the stack to
	ldm	@rr14,r6,#8	! save regs

#ifdef __STD_CALL__
	ld	r8,rr14(#20)	! did
	ldl	rr10,rr14(#22)	! ptr to name
	ld	r9,rr14(#26)	! namelen
	ld	r7,rr14(#28)	! mode
	ld	r6,rr14(#30)	! extent length
#else
	ld	r8,r7		! did
	ldl	rr10,rr4	! ptr to name
	ld	r9,r3		! namelen
	ld	r7,r2		! mode
	ld	r6,rr14(#20)	! extent length
#endif

	sc	#22		! OpenFile
	ldm	r6,@rr14,#6	! restore regs
	inc	r15,#16
	ld	RET_REG,r5	! status
	ret

	.end
