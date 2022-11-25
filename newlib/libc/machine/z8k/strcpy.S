/*
 * strcpy routine for Z8000
 * Copyright (C) 2008 Christian Groessler <chris@groessler.org>
 *
 * Permission to use, copy, modify, and distribute this file
 * for any purpose is hereby granted without fee, provided that
 * the above copyright notice and this notice appears in all
 * copies.
 *
 * This file is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

/* char *strcpy(char *dest, const char *src);
 */

	name	"strcpy.S"

	.text
	even
global	_strcpy

_strcpy:

#ifdef __Z8001__
	segm

#ifdef __STD_CALL__
	ldl	rr6,rr14(#4)
	ldl	rr4,rr14(#8)
#else
	pushl	@rr14,rr6
#endif

/* rr4  - src
 * rr6  - dest
 */

loop:	ldb	rl0,@rr4
	ldb	@rr6,rl0
	inc	r5,#1
	inc	r7,#1
	testb	rl0
	jr	nz,loop

finish:
#ifdef __STD_CALL__
	ldl	rr6,rr14(#4)
#else
	popl	rr2,@rr14
#endif


#else		/* above Z8001, below Z8002 */


	unsegm

#ifdef __STD_CALL__
	ld	r7,r15(#2)
	ld	r6,r15(#4)
#else
	ld	r2,r7		/* buffer pointer return value */
#endif

/* r6  - src
 * r7  - dest
 */

loop:	ldb	rl0,@r6
	ldb	@r7,rl0
	inc	r6,#1
	inc	r7,#1
	testb	rl0
	jr	nz,loop

finish:
#ifdef __STD_CALL__
	ld	r7,r15(#2)
#endif

#endif	/* Z8002 */

	ret
	.end
