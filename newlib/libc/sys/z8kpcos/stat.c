/* $Id: stat.c,v 1.2 2002/07/07 00:10:00 chris Exp $ */

#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/fcntl.h>
#include "pcosdebug.h"

int
_stat (const char *path, struct stat *buf)
{
    int fd, retval;
    int oerrno;

    DEB_PRINT("_stat called\r");

    fd = _open(path, O_RDONLY, 0);
    if (fd == -1) {
        return(fd);
    }
    retval = _fstat(fd, buf);
    oerrno = errno;
    _close(fd);
    if (! retval) return(0);
    errno = oerrno;
    return(-1);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
