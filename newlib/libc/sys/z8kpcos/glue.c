/* $Id: glue.c,v 1.23 2002/08/23 21:33:19 chris Exp $ */
/*
 * PCOS runtime lib misc stuff
 * (c) 2001,2002 Christian Groessler <chris@groessler.org>
 */

#include "sys/syscall.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <unistd.h>
#include <_ansi.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/pcos.h>
#include "glue.h"
#include "pcosdebug.h"

/* make some sanity checks */
#ifndef __Z8001__
#error PCOS lib only works with Z8001 mode!
#endif
#if NOFILE != 16
#error wrong sys/param.h included
#endif


#if 1 /*def DEBUG*/

static unsigned char numb[16];
static unsigned char nl[] = "\r";

void __pcos_num_print(char *str, unsigned long val)
{
    unsigned char *oefi;
    unsigned char x;

    _pcos_print(str);

    oefi = numb + 15;
    *oefi-- = 0;
    if (val) {
        while (val) {
            x = (val & 0xf) + '0';
            if (x > '9') x += 'A' - ('9' + 1);
            *oefi-- = x ;
            val >>= 4;
        }
    }
    else {
        *oefi-- = '0';
    }
    oefi++;
    _pcos_print(oefi);
    _pcos_print(nl);
}

#endif /* DEBUG */

time_t
_time(time_t *timer)
{
    DEB_PRINT("_time called\r");
}

int _kill(int pid, int val)
{
    DEB_PRINT("_kill called\r");
    _exit(val);
}

/* -------------------------------- */

/*
 * fd <-> DID conversion routines and their relatives
 */

#define NUM_DIDS 27

/* mapping fd -> DID; fd is index into this table */
signed char fdtable[NOFILE] = { [0 ... NOFILE - 1] = -1 };   /* -1 for not open */

/* currently available DIDs @@@TODO: make bitfield to save space */
signed char didfree[NUM_DIDS] = { [0 ... 26] = 1 };

/* called by startup code to initialize */
void __init_fdtable(void)
{
    fdtable[0] = fdtable[1] = fdtable[2] = DID_CONSOLE;    /* setup in, out, err channels */
    didfree[0] = didfree[DID_CONSOLE] = didfree[DID_PRINTER]
        = didfree[DID_COM] = didfree[DID_COM1]
        = didfree[DID_COM2] = 0;   /* tag them as being used */
}

/* get a free fd, return -1 if none is available */
signed char __newfd(void)
{
    int i;

    for (i=0; i<NOFILE; i++) {
        if (fdtable[i] == -1) return(i);
    }
    return(-1);
}

/* get an available DID */
signed char __findfreedid(void)
{
    int i;

    for (i=0; i<NUM_DIDS; i++) {
        if (didfree[i]) return(i);
    }
    return(-1); /* not found */
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
