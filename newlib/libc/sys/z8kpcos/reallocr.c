/* $Id: reallocr.c,v 1.3 2003/04/09 22:31:04 chris Exp $ */

#include <_ansi.h>
#include <reent.h>
#include <stdlib.h>
#include <malloc.h>

extern _PTR
_DEFUN (realloc, (ap, nbytes),
        _PTR ap _AND
        size_t nbytes);

_PTR
_DEFUN (_realloc_r, (reent, ap, nbytes),
        struct _reent *reent _AND
        _PTR ap _AND
        size_t nbytes)
{
    return realloc(ap, nbytes);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
