/* $Id: close.c,v 1.8 2002/08/23 21:36:03 chris Exp $ */

#include <sys/param.h>
#include <sys/pcos.h>
#include <errno.h>
#include "glue.h"
#include "pcosdebug.h"

int _close (int fd)
{
    int status;
    int did;

    NUM_PRINT("_close called: fd ", fd);

    if ((unsigned int)fd >= NOFILE) goto badferr;
    did = fdtable[fd];
    if (did == -1) {
      badferr:
        errno = EBADF;
        return(-1);
    }

    NUM_PRINT("_close DID: ", did);
    if (! is_file_or_com_did(did)) goto badferr;

    status = _pcos_close(did);
    if (status) {
        NUM_PRINT("PCOS close returned: ", status);
        errno = errno_from_pcos_err(status);
        return(-1);
    }

    /* update tables */
    didfree[did] = 1;
    fdtable[fd] = -1;
    return(status);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
