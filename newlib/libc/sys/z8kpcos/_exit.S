! $Id: _exit.S,v 1.1 2002/06/16 00:27:45 chris Exp $
! the _exit function
! void _exit(int val)

	.z8001

	.text
	.globl	__exit
	even

__exit:
#ifdef __STD_CALL__
	ld	r5,rr14(#4)
#else
	ld	r5,r7
#endif
	ldl	sp,__retsp
	ret			! return to system

	.bss
	.globl	___dtors, ___dtors_end
	even

___dtors:
___dtors_end:

	.end
