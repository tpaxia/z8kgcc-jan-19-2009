/* $Id: read.c,v 1.19 2004/05/22 22:07:46 chris Exp $ */

#include <sys/types.h>
#include <sys/param.h>
#include <sys/pcos.h>
#include <errno.h>
#include "glue.h"

#define LB_LEN 82
static unsigned char linebuffer[LB_LEN];
static int lblen = 0, lbix = 0;

static int _getbyte_linebuffered(int did, unsigned char *byte)
{
    unsigned char c;

    if (! lblen || lbix >= lblen) {  /* line buffer empty, get data */
        int retval;
        for (lbix = 0; lbix < LB_LEN; lbix++) {
          again:
            retval = _pcos_getbyte(did, &c);
            if (retval) {
                return(retval);
            }
            if (c == 8) {            /* ^H */
                if (lbix) {
                    lbix--;
                    _pcos_putbyte(did, c);
                    _pcos_putbyte(did, ' ');
                    _pcos_putbyte(did, c);
                }
                goto again;
            }

            if (c == 3) {            /* ^C */
                lbix = 0;
                *byte = 3;
                return(PCOS_ERR_OK);
            }

            linebuffer[lbix] = c;
            if (c == 4 || c == 26) { /* ^D or ^Z (EOF) */
                break;
            }
            _pcos_putbyte(did, c);   /* echo typed char */
            if (c == '\r') {
                linebuffer[lbix] = '\n';
                _pcos_putbyte(did, '\n');
                break;
            }
        }
        lblen = lbix + 1;
        lbix = 0;
    }

    *byte = linebuffer[lbix];
    lbix++;

    return(PCOS_ERR_OK);
}

int _read (int fd, void *buf, size_t nbytes)
{
    int retval, did;
    unsigned int i, nbytesi = nbytes;   /* nbytes: nbytes as int */

    if (! nbytes) return(nbytes);
    if ((unsigned int)fd >= NOFILE) {
        goto not_open;
    }
    did = fdtable[fd];
    if (did == -1) {
      not_open:
        errno = EBADF;
        return(-1);
    }

    /* on console use GetByte */
    if (did == DID_CONSOLE) {
        unsigned char *cbuf = buf;

        _pcos_selectcur(2);  /* turn on cursor */
        for (i=0; i<nbytes; i++) {
            unsigned char c;

            retval = _getbyte_linebuffered(did, &c);
            if (retval) {
                _pcos_selectcur(0);   /* turn off cursor */
                errno = errno_from_pcos_err(retval);
                return(-1);
            }

            if (c == 3) {    /* ^C */
                _pcos_putbyte(did, '^');
                _pcos_putbyte(did, 'C');
                _pcos_putbyte(did, '\r');
                _pcos_putbyte(did, '\n');
                _pcos_selectcur(0);
                exit(130);
            }

            *(cbuf + i) = c;
            if (c == '\n') {
                i++;
                goto lineend;
            }
            if (c == 4 || c == 26) {  /* ^D or ^Z (EOF) */
              lineend:
                _pcos_selectcur(0);   /* turn off cursor */
                return(i);
            }
        }
        _pcos_selectcur(0);   /* turn off cursor */
    }
    else {
        retval = _pcos_readbytes(did, buf, nbytes, &nbytesi);
        if (retval && retval != PCOS_ERR_EOF) {
            errno = errno_from_pcos_err(retval);
            return(-1);
        }
    }
    retval = nbytesi;
    return(retval);
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
