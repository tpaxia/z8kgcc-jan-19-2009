/* $Id: realloc.c,v 1.3 2002/08/23 21:36:05 chris Exp $ */

#include <_ansi.h>
#include <reent.h>
#include <stdlib.h>
#include <malloc.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

_PTR
_DEFUN (realloc, (ap, nbytes),
        _PTR ap _AND
        size_t nbytes)
{
    unsigned char *ptr = ap;
    unsigned char *newptr;
    unsigned short status;
    size_t oldsize;

    DEB_PRINT("realloc called\r");

    if (ptr == NULL) return(malloc(nbytes));

    if ((unsigned int)ptr < 4 || *(ptr - 4) != 'T' || *(ptr - 3) != 'D') {
        _pcos_print("realloc: memory corrupted!\r");
        return(NULL);
    }

    newptr = malloc(nbytes);
    if (newptr == NULL) return(NULL);  /* new size could not be allocated */

    /* new buffer successfully allocated
     * copy data from old to new buffer
     * new buffer's size can be smaller or larger than the old one!
     */
    oldsize = *((unsigned short *)ptr - 1) - 4;
    memcpy(newptr, ptr, oldsize > nbytes ? nbytes : oldsize);

    free(ap);   /* free old buffer */
    return(newptr);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
