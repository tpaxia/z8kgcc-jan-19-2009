/* $Id: lseek.c,v 1.3 2002/08/23 21:36:03 chris Exp $ */

#include <sys/types.h>
#include <sys/pcos.h>
#include <sys/param.h>
#include <errno.h>
#include <unistd.h>
#include "glue.h"
#include "pcosdebug.h"

off_t
_lseek (int fd,  off_t offset, int whence)
{
    int stat, did;
    off_t newoff;

    DEB_PRINT("_lseek called\r");

    if ((unsigned int)fd >= NOFILE) {
      badferr:
        errno = EBADF;
        return(-1L);
    }
    did = fdtable[fd];
    if (did == -1) {
        goto badferr;
    }

    if (! is_file_did(did)) {
        errno = ESPIPE;
        return(-1L);
    }

    if (whence == SEEK_SET) {
      set:
        stat = _pcos_dseek(did, offset);
        if (stat != PCOS_ERR_OK) {
          err_ret:
            errno = errno_from_pcos_err(stat);
            return(-1);
        }
    }
    else if (whence == SEEK_CUR) {
        stat = _pcos_dgetposition(did, &newoff);
      cur_work:
        if (stat != PCOS_ERR_OK) goto err_ret;
        if (newoff + offset < 0) goto inverr;
        offset = newoff + offset;
        goto set;
    }
    else if (whence == SEEK_END) {
        stat = _pcos_dgetlen(did, &newoff);
        goto cur_work;
    }
    else {
      inverr:
        errno = EINVAL;
        return(-1L);
    }

    /* return current fp */
    stat = _pcos_dgetposition(did, &newoff);
    if (stat != PCOS_ERR_OK) goto err_ret;

    NUM_PRINT("_lseek: fp = ", (unsigned long)newoff);
    return(newoff);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
