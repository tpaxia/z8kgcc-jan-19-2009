/* $Id: open.c,v 1.12 2003/12/31 00:29:41 chris Exp $ */

#include <errno.h>
#include <string.h>
#define _open ___open /* TODO: fix open parameters! */
#include <fcntl.h>
#undef _open
#include <sys/pcos.h>
#include "glue.h"
#include "pcosdebug.h"

int _open (const char *name, int flags, ...)
{
    signed char fd, did;
    int status, pcos_mode;
    int aflags = flags & O_ACCMODE;
    int namelen = strlen(name);

    DEB_PRINT("_open called\r");

    /* get a free fd */
    fd = __newfd();
    if (fd == -1) {
      emfilerr:
        errno = EMFILE;
        return(-1);  /* too many open files */
    }

    /* get a free DID */
    did = __findfreedid();
    if (did == -1) goto emfilerr;

    /* read-only case */
    if (aflags == O_RDONLY) {
        status = _pcos_openfile(did, name, namelen, PCOS_OPEN_READ, 0 /*DEFAULT_EXTENT_LEN*/);
        goto cont;
    }

    /* open for writing: */

    /* open for writing, but don't create:
     * first try a read-only open to detect whether the file exists
     */
    if (! (flags & O_CREAT)) {
        status = _pcos_openfile(did, name, namelen, PCOS_OPEN_READ, 0);
        if (status != PCOS_ERR_OK) {
          generic_err:
            NUM_PRINT("open: generic_err: pcos status: ", (unsigned long)status);
            errno = errno_from_pcos_err(status);
            return(-1);
        }

        /* file already exists - close it again, because it was opened for read-only */
        status = _pcos_close(did);
        if (status != PCOS_ERR_OK) goto generic_err;
    }
    else if (flags & O_EXCL) {
        status = _pcos_openfile(did, name, namelen, PCOS_OPEN_READ, 0);
        if (status == PCOS_ERR_OK) { /* file exists */
            status = _pcos_close(did);
            if (status != PCOS_ERR_OK) goto generic_err;
            errno = EEXIST;
            return(-1);
        }
        if (status != PCOS_ERR_OK && status != PCOS_ERR_NOENT && status == PCOS_ERR_VNOENT)
            goto generic_err;
    }

    /* open file for writing */
    if (flags & O_APPEND) pcos_mode = PCOS_OPEN_APPEND;
    else pcos_mode = aflags == O_RDWR ? PCOS_OPEN_RDWRITE : PCOS_OPEN_WRITE;

    status = _pcos_openfile(did, name, namelen, pcos_mode, _pcos_extent_length);
  cont:
    if (status != PCOS_ERR_OK) {
        NUM_PRINT("pcos_open returned: ", (unsigned long)status);
        goto generic_err;
    }

    /* open OK, update tables */
    didfree[did] = 0;
    fdtable[fd] = did;
    return(fd);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
