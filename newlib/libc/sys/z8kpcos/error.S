/* $Id: error.S,v 1.6 2004/07/11 20:58:52 chris Exp $
 * translates PCOS error codes to errno codes
 * Copyright (c) 2002-2004 Christian Groessler <chris@groessler.org>
 */

/* int errno_from_pcos_err(int pcos_err) */

#define ERRNO_VALS_ONLY
#define __error_t_defined 1   /* for errno.h */
#include <errno.h>
#include <sys/pcos.h>

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	name	"error.S"
	segm

	sect	.rdata
	even
errtab:
	.word	PCOS_ERR_OK,		0		/* no error */
	.word	PCOS_ERR_XXX,		ECONNABORTED	/* "invalid termination of input byte stream */
	.word	PCOS_ERR_MEM,		ENOMEM		/* "out of memory" */
	.word	PCOS_ERR_INVADR,	ENOTBLK
	.word	PCOS_ERR_NOIEEE,	ENOTBLK
	.word	PCOS_ERR_TO,		ETIMEDOUT	/* "time out error" */
	.word	PCOS_ERR_DATATYPE,	EINVAL		/* "bad data type" */
	.word	PCOS_ERR_NOENT,		ENOENT		/* "file not found" */
	.word	PCOS_ERR_MODE,		EPERM		/* "bad file open mode" */
	.word	PCOS_ERR_ALOPN,		EBADF		/* "file already open" */
	.word	PCOS_ERR_EIO,		EIO		/* "disk i/o" */
	.word	PCOS_ERR_EEXIST,	EEXIST		/* "file aready exists" */
	.word	PCOS_ERR_NOTINIT,	EIO		/* "disk not initialized" */
	.word	PCOS_ERR_NOSPC,		ENOSPC		/* "disk filled" */
	.word	PCOS_ERR_EOF,		0		/* "end of file" */
	.word	PCOS_ERR_REC,		ESTALE		/* "bad record number" */
	.word	PCOS_ERR_NAME,		ENAMETOOLONG	/* "bad file name" */
	.word	PCOS_ERR_VNOENT,	ENODEV		/* "volume name not found" */
	.word	PCOS_ERR_INVVOL,	ENODEV		/* "invalid volume number" */
	.word	PCOS_ERR_VOLNOTEN,	EIO		/* "volume not enabled" */
	.word	PCOS_ERR_PASSWD,	EACCES		/* "password not valid" */
	.word	PCOS_ERR_DCHG,		EBADE		/* "illegal disk change" */
	.word	PCOS_ERR_WRPROT,	EPERM		/* "write protected file" */
	.word	PCOS_ERR_CPPROT,	EPERM		/* "copy protected file" */
	.word	PCOS_ERR_PARM,		EINVAL		/* "error in parameter" */
	.word	PCOS_ERR_TOOMPARM,	EINVAL		/* "too many parameters" */
	.word	PCOS_ERR_NOTFND,	ENOENT		/* "command not found" */
	.word	PCOS_ERR_NOTOPM,	EPERM		/* "file not open" */
	.word	PCOS_ERR_BADLOAD,	ENOEXEC		/* "bad load file" */
	.word	PCOS_ERR_TIMDAT,	ETIMEDOUT	/* "time or date" */  /* cpg: what is this? */
	.word	PCOS_ERR_TO2,		ETIMEDOUT	/* "time-out" */
	.word	PCOS_ERR_INVDEV,	ENXIO		/* "invalid device" */

	.word	0xffff,			0		/* end marker */

!	case PCOS_ERR_NOWIN:	/* "window does not exist" */
!	case PCOS_ERR_WINCREAT:	/* "window create error" */
!	case PCOS_ERR_EXFN:	/* "function key already exists" */
!	case PCOS_ERR_CALLUSR:	/* "call-user" */


	.text
	even
global	_errno_from_pcos_err

_errno_from_pcos_err:
	pushl	@sp,rr10
#ifdef __STD_CALL__
	ld	r7,rr14(#8)
#endif
	lda	rr10,errtab
	ldk	r1,#0
loop:	ld	r2,rr10(r1)
	cp	r2,#0xffff	! end of table?
	jr	eq,notfnd
	cp	r2,r7		! pcos error code match?
	jr	eq,found	! yes
	inc	r1,#4		! point to next entry
	jr	loop

notfnd:	ld	RET_REG,#666	! default code
	jr	t,leave

found:	inc	r1,#2
	ld	RET_REG,rr10(r1)! get matching error code
leave:	popl	rr10,@sp
	ret

	.end
