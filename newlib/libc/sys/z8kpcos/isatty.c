/* $Id: isatty.c,v 1.2 2002/07/07 01:17:29 chris Exp $ */

#include <sys/pcos.h>
#include "glue.h"
#include "pcosdebug.h"

int
isatty(int fd)
{
    NUM_PRINT("_isatty called: fd: ", (unsigned long)fd);

    if (fdtable[fd] == DID_CONSOLE
        || fdtable[fd] == DID_COM
        || fdtable[fd] == DID_COM1
        || fdtable[fd] == DID_COM2
        ) return(1);
    return(0);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
