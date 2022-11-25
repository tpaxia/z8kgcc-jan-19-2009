/* $Id: _pcos_search.S,v 1.2 2004/01/03 00:38:56 chris Exp $
 * Search PCOS system call
 * Copyright (c) 2004 Christian Groessler <chris@groessler.org>
 */

/* int _pcos_search(int drive, int search_mode, int *length, char **file_pointer,
 *                  char *name_pointer);
 */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_pcos_search.S"
	segm

	.text
	even
global	__pcos_search

__pcos_search:

/*
 * do a Search (98) call
 *
 * in  r6   - drive
 *     r7   - search mode
 *     r9   - length
 *     rr10 - file pointer
 *     rr12 - name pointer
 * out r5   - status
 *     r9   - length of output filename
 *     rr10 - file pointer
 *     rr12 - modified
 */

	dec	r15,#12		! make space on the stack to
	ldm	@rr14,r8,#6	! save regs
#ifdef __STD_CALL__
	ld	r6,rr14(#16)	! drive
	ld	r7,rr14(#18)	! search_mode
	ldl	rr4,rr14(#20)	! *length
	ld	r9,@rr4		! length
	ldl	rr2,rr14(#24)	! **file_pointer
	ldl	rr10,@rr2	! *file_pointer
	ldl	rr12,rr14(#28)	! *name_pointer
#else
	ex	r6,r7		! drive and search_mode
	ld	r9,@rr4		! length
	ldl	rr10,@rr2	! *file_pointer
	ldl	rr12,rr14(#16)	! *name_pointer
#endif

	pushl	@sp,rr2
	pushl	@sp,rr4
	sc	#98		! Search
	popl	rr12,@sp
#ifdef __STD_CALL__
	popl	rr2,@sp
#else
	popl	rr6,@sp
#endif

	ld	@rr12,r9	! length of output filename
#ifdef __STD_CALL__
	ldl	@rr2,rr10	! file pointer
#else
	ldl	@rr6,rr10	! file pointer
#endif

	ld	RET_REG,r5	! status

	ldm	r8,@rr14,#6	! restore regs
	inc	r15,#12
	ret

	.end
