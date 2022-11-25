/* $Id: malloc.c,v 1.2 2002/08/23 21:36:04 chris Exp $ */

#include <errno.h>
#include <malloc.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

/*
 * std version
 */
_PTR malloc(size_t size)
{
    unsigned char *addr;
    unsigned short status;

    DEB_PRINT("_malloc called\r");

    if (size >= 65536-4) { /* too much */
        errno = ENOMEM;
        return(NULL);
    }

    size += 4;  /* reserve space for marker + len */

    /* allocate the memory */
    status = _pcos_new(size, &addr);
    if (status != PCOS_ERR_OK) {
        errno = errno_from_pcos_err(status);
        return(NULL);
    }

    /* create ID marker and remember the allocated size */
    *addr = 'T';
    *(addr + 1) = 'D';
    *((unsigned short *)addr + 1) = size;

    return(addr + 4);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
