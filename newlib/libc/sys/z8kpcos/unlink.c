/* $Id: unlink.c,v 1.4 2002/08/23 21:36:05 chris Exp $ */

#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

int _unlink(const char *__path)
{
    short retval;

    DEB_PRINT("_unlink called\r");

    retval = _pcos_dremove(__path, strlen(__path));
    if (retval) {
#ifdef MORE_DEBUG
      NUM_PRINT("_pcos_dremove returned: ", retval);
#endif
      errno_from_pcos_err(retval);
      return(-1);
    }
    return(retval);
}
/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
