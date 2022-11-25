/* $Id: _pcos_extent_len.S,v 1.1 2003/12/31 00:29:10 chris Exp $
 * provides _pcos_extent_length
 * Copyright (c) 2003 Christian Groessler <chris@groessler.org>
 */

/* extern unsigned short _pcos_extent_length; */

#define ERRNO_VALS_ONLY
#include <sys/pcos.h>

        name    "_pcos_extent_len.S"

	.z8001
        .data
        even

	global  __pcos_extent_length

__pcos_extent_length:
	.word	DEFAULT_EXTENT_LEN

	.end
