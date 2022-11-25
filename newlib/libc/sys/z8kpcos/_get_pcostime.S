/* $Id: _get_pcostime.S,v 1.5 2004/03/13 23:19:04 chris Exp $
 * get current time from BIOS variables
 * Copyright (c) 2003,2004 Christian Groessler <chris@groessler.org>
 */

/* void _get_pcostime(struct pcostime *cur_time); */

/*
 * see pcos.h for struct pcostime definition
 */

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"_get_pcostime.S"
	segm

	.text
	even
global	__get_pcostime

__get_pcostime:

	pushl	@sp,rr12
#ifdef __STD_CALL__
	ldl	rr12,rr14(#8)	! cur_time address
#else
	ldl	rr12,rr6	! cur_time address
#endif

	di	vi,nvi		! disable interrupts

	clrb	rh0
	ldb	rl0,0x8200002b	! get clock ticks
	ld	@rr12,r0
	ldb	rl0,0x82000026	! get seconds
	ld	rr12(#2),r0
	ldb	rl0,0x82000027	! get minutes
	ld	rr12(#4),r0
	ldb	rl0,0x82000028	! get hours
	ld	rr12(#6),r0

	ldb	rl0,0x82000029	! get day
	ld	rr12(#8),r0
	ldb	rl0,0x8200002c	! get month
	ld	rr12(#10),r0
	ld	r0,0x8200002e	! get year
	ld	rr12(#12),r0

	ei	vi,nvi

	popl	rr12,@sp
	ret

	.end
