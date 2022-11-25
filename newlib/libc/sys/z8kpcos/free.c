/* $Id: free.c,v 1.2 2002/08/23 21:36:03 chris Exp $ */

#include <errno.h>
#include <malloc.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

/*
 * we need the allocated length (saved at <address to free> - 2)
 */
void free(_PTR block)
{
    unsigned char *ptr = block;
    unsigned short size;
    unsigned short status;

    DEB_PRINT("free called\r");

    if ((unsigned long)ptr < 4 || *(ptr - 4) != 'T' || *(ptr - 3) != 'D') {
        _pcos_print("free: memory corrupted!\r");
        return;
    }

    ptr -= 4;
    size = *((unsigned short *)ptr + 1);
    *ptr = 0; /* destroy signature */

    status = _pcos_dispose(size, &ptr);
    if (status != PCOS_ERR_OK) {
        _pcos_print("free: memory free failed!\r");
    }
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
