/* $Id: freer.c,v 1.4 2002/08/23 21:36:03 chris Exp $ */

#include <malloc.h>
#include <sys/types.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

void _free_r(struct _reent *reen, _PTR block)
{
    free(block);   /* our reent pointer is unused */
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
