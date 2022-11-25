/* $Id: fstat.c,v 1.7 2002/08/23 21:36:03 chris Exp $ */

#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <sys/pcos.h>
#include "glue.h"
#include "pcosdebug.h"

int
_fstat (int fd, struct stat *buf)
{
    int ret;

    DEB_PRINT("_fstat called\r");

    if ((unsigned int)fd >= NOFILE || didfree[fdtable[fd]]) {
        errno = EBADF;
        return(-1);
    }

    /* initialize return struct */
    memset(buf, 0, sizeof(struct stat));

    /* maybe 0 is harmful -- give some nice numbers */
    buf->st_dev = 1;
    buf->st_ino = 1;
    buf->st_nlink = 1;

    /* the known devices */
    if (fdtable[fd] == DID_CONSOLE
        || fdtable[fd] == DID_PRINTER
        || fdtable[fd] == DID_COM
        || fdtable[fd] == DID_COM1
        || fdtable[fd] == DID_COM2) {
        buf->st_mode = S_IFCHR;
        return(0);
    }

    ret = _pcos_dgetlen(fdtable[fd], &buf->st_size);
    if (ret != PCOS_ERR_OK) {
        DEB_PRINT("_fstat: pcos error\n");
        errno = errno_from_pcos_err(ret);
        return(-1);
    }

    buf->st_blocks = (buf->st_size + 255) / 256 + 1;
    buf->st_blksize = 256;
    return(0);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
