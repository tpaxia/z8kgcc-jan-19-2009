/* $Id: _rename.c,v 1.4 2002/08/23 21:36:02 chris Exp $ */

#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

#define MORE_DEBUG

int _rename(const char *from, const char *to)
{
    int retval;

    DEB_PRINT("_rename called\r");

    retval = _pcos_drename(from, strlen(from), to, strlen(to));
    if (retval) {
#ifdef MORE_DEBUG
      NUM_PRINT("_pcos_drename: ", retval);
#endif
      errno = errno_from_pcos_err(retval);
      return(-1);
    }
    return(retval);
}
/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
