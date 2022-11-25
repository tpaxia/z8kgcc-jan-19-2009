! $Id: errno.s,v 1.2 2007/06/16 16:34:21 chris Exp $
! definition for the errno variable

	.bss
	.globl	_errno_weg	! @@@ disabled, it's already defined in reent.c

	even
_errno_weg:	.ds.l	1

	.end
