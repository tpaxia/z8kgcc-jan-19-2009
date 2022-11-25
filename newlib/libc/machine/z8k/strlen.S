/*
 * strlen routine for Z8000
 * Copyright (C) 2007 Christian Groessler <chris@groessler.org>
 *
 * Permission to use, copy, modify, and distribute this file
 * for any purpose is hereby granted without fee, provided that
 * the above copyright notice and this notice appears in all
 * copies.
 *
 * This file is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

/* size_t strlen(const char *string);
 */

	name	"strlen.S"

	.text
	even
global	_strlen

_strlen:

#ifdef __Z8001__
	segm

#ifdef __STD_CALL__
#define RET_REG_HIGH r6
#define RET_REG_LOW r7
#else
#define RET_REG_HIGH r2
#define RET_REG_LOW r3
#endif

#ifdef __STD_CALL__

	ldl	rr6,rr14(#4)

/* rr6 - string
 */

	ld	r2,r7		/* remember start offset */
	clr	r0		/* counter */
	ld	r1,r0		/* compare value (0) */
	cpirb	rl1,@rr6,r0,eq
	sub	r7,r2
	dec	r7,#1

	ld	RET_REG_HIGH,r1
     /*	ld	RET_REG_LOW,r7 */
	ret

#else		/* above __STD_CALL__, below not */

/* rr6 - string
 */

	ldl	rr2,rr6		/* remember start offset */
	clr	r0		/* counter */
	ld	r1,r0		/* compare value (0) */
	cpirb	rl1,@rr2,r0,eq
	sub	r3,r7
	dec	r3,#1
	ld	RET_REG_HIGH,r1
	ret

#endif


#else		/* above Z8001, below Z8002 */


	unsegm

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

#ifdef __STD_CALL__

	ld	r7,r15(#2)

/* r7 - string
 */

	ld	r2,r7		/* remember start offset */
	clr	r0		/* counter */
	ldb	rl1,rl0		/* compare value (0) */
	cpirb	rl1,@r7,r0,eq
	sub	r7,r2
	dec	r7,#1
	ret

#else		/* above __STD_CALL__, below not */

/* r7 - string
 */

	ld	r2,r7		/* remember start offset */
	clr	r0		/* counter */
	ldb	rl1,rl0		/* compare value (0) */
	cpirb	rl1,@r2,r0,eq
	sub	r2,r7
	dec	r2,#1
	ret

#endif

#endif	/* Z8002 */

	ret
	.end
