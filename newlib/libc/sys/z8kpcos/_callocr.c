/* $Id: _callocr.c,v 1.1 2003/04/10 10:09:52 chris Exp $ */

#include <malloc.h>
#include <sys/types.h>

/*
 * ignore reen
 */
_PTR _calloc_r(struct _reent *reen, size_t number, size_t size)
{
    return(calloc(number, size));   /* our reent pointer is unused */
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
