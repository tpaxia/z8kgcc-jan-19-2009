/* $Id: calloc.c,v 1.1 2003/04/10 10:09:53 chris Exp $ */

#include <errno.h>
#include <malloc.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

/*
 * std version
 */
_PTR calloc(size_t number, size_t size)
{
    _PTR p;

    p = malloc(number * size);
    if (! p) return p;
    memset(p, 0, number * size);
    return p;
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
