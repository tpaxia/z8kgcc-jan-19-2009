/* $Id: mallocr.c,v 1.3 2002/08/23 21:36:04 chris Exp $ */

#include <malloc.h>
#include <sys/types.h>

/*
 * ignore reen
 */
_PTR _malloc_r(struct _reent *reen, size_t size)
{
    return(malloc(size));   /* our reent pointer is unused */
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
