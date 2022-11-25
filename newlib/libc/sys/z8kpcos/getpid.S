/* $Id: getpid.S,v 1.3 2003/12/28 20:47:10 chris Exp $
 * simple getpid() function
 * Copyright (c) 2002,2003 Christian Groessler <chris@groessler.org>
 */

#ifdef __STD_CALL__
#define RET_REG r7
#define RET_REG_L rl7
#define RET_REG_H rh7
#else
#define RET_REG r2
#define RET_REG_L rl2
#define RET_REG_H rh2
#endif

	name	"getpid.S"
	segm

	.bss

mypid:	.ds.w	1

	.text
	even

global	__getpid
__getpid:

	ld	RET_REG,mypid
	test	RET_REG
	ret	nz

	ldb	RET_REG_L,0x8200002b  ! get clock ticks from BIOS data area
	ldb	RET_REG_H,0x82000026  ! get seconds

	ld	mypid,RET_REG
	ret

	.end
