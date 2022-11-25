/* $Id: _sbrk.c,v 1.1 2002/08/23 21:32:38 chris Exp $ */

#include <errno.h>
#include <sys/types.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

/* #define MORE_DEBUG */

static void new_largest_block(caddr_t *addr, unsigned short *length)
{
    unsigned short status, l;

#if 0  /* 121 always returns 7!? */
    asm("ldl   rr8,%0           \n\t"
        "ld    r10,#0           \n\t"
        "ld    r11,r10          \n\t"
        "ldl   @rr8,rr10        \n\t"
        "sc    #121             \n\t" : : "g" (addr) :
                       "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13" );
#endif

    status = _pcos_maxsize(&l);
    if (status) {
        *length = 0;
        return;
    }

    status = _pcos_new(l, &addr);
    *length = l;
}

/*
 * sbrk -- changes heap size. Get nbytes more
 *         RAM. We just increment a pointer in what's
 *         left of memory on the board.
 */
void *
_sbrk (size_t nbytes)
{
    static caddr_t end, heap_ptr = NULL;
    caddr_t base;
    unsigned short len;

    DEB_PRINT("_sbrk called\r");

    if (! heap_ptr) {
#ifdef MORE_DEBUG
        NUM_PRINT("_sbrk: calling:  ", (unsigned long)new_largest_block);
#endif
        new_largest_block(&heap_ptr, &len);
#ifdef MORE_DEBUG
        NUM_PRINT("_sbrk: #bytes ", nbytes);
        NUM_PRINT("_sbrk: addr:  ", (unsigned long)heap_ptr);
        NUM_PRINT("_sbrk: len:   ", len);
#endif
        if (! len) {
            heap_ptr = NULL;
            errno = ENOMEM;
            return((caddr_t)-1);
        }
        end = heap_ptr + len;
#ifdef MORE_DEBUG
        NUM_PRINT("_sbrk: end:   ", end);
#endif
    }

    if (heap_ptr + nbytes < end) {
        base = heap_ptr;
        heap_ptr += nbytes;
#ifdef MORE_DEBUG
        NUM_PRINT("_sbrk: returning:   ", base);
#endif
        return(base);
    } else {
        errno = ENOMEM;
        return((caddr_t)-1);
    }
}
/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
