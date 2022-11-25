/* $Id: write.c,v 1.18 2002/12/27 13:18:44 chris Exp $ */

#include <sys/types.h>
#include <sys/param.h>
#include <sys/pcos.h>
#include <errno.h>
#include "glue.h"
#include "pcosdebug.h"

/*#define MORE_DEBUG*/

int _write (int fd, const void *buf, size_t nbytes)
{
    int retval, did;
    unsigned int i;
    unsigned int nbytesi = (unsigned int)nbytes; /* nbytes as int (16bit) value */

    NUM_PRINT("_write called: fd ", fd);

    if (! nbytes) return(nbytes);
    if (nbytes > 0xffff) {
        /* @@@TODO, split it up or return error? */
        errno = 999;
        return(-1);
    }
    if ((unsigned int)fd >= NOFILE) {
      not_open:
        errno = EBADF;
        return(-1);
    }
    did = fdtable[fd];
    if (did == -1) {
        goto not_open;
    }

    /* apparently writebytes is only supported on files and RS232, */
    /* so on the console at least, we have to issue a \n too.. */
    if (did == DID_PRINTER || did == DID_CONSOLE) {
        const char *cbuf = buf;

        DEB_PRINT("write.c: PutByte on console\r");
        /* do it with PutByte */
        for (i=0; i<nbytesi; i++) {
            char c = *(cbuf + i);
            if (c == '\n') {
                retval = _pcos_putbyte(did, 13);
                if (retval) goto err;
            }
            retval = _pcos_putbyte(did, c);
            if (retval) {
                DEB_PRINT("write.c: PutByte error\r");
                goto err;
            }
            if (c == '\r') {
                retval = _pcos_putbyte(did, 10);
            }
            if (retval) {
              err:
                errno = errno_from_pcos_err(retval);
                DEB_PRINT("write.c: leaving with error\r");
                return(i);
            }
        }
    }
    else {
#ifdef MORE_DEBUG
        NUM_PRINT("in write: write to file: ", nbytes);
        NUM_PRINT("in write: did: ", did);
#endif
        retval = _pcos_writebytes(did, buf, nbytesi, &nbytesi);
        if (retval) {
            errno = errno_from_pcos_err(retval);
            DEB_PRINT("write.c: leaving with error\r");
            return(-1);
        }
        nbytes = nbytesi;
    }
    retval = nbytes;
    DEB_PRINT("write.c: leaving OK\r");
    return(retval);  /* # of bytes written */
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
