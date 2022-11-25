/* $Id: _times.c,v 1.1 2003/04/10 10:09:52 chris Exp $ */

#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/times.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

static unsigned char notfirstcall;

static clock_t oldtime;

clock_t _times(struct tms *tms)
{
    int status;
    char buffer[9];
    unsigned int h, m, s;
    clock_t newtime;

    if (! notfirstcall) {
        notfirstcall = 1;
        if (tms) memset(tms, 0, sizeof(*tms));
        memset(buffer, 0, sizeof(buffer));
        status = _pcos_gettime(buffer, 8);
        if (status != PCOS_ERR_OK) return 0;
        /*sscanf(buffer, "%02u:%02u:%02u", &h, &m, &s);   sscanf: too much bloat! */

        h = (buffer[0] - '0') * 10 + buffer[1] - '0';
        m = (buffer[3] - '0') * 10 + buffer[4] - '0';
        s = (buffer[6] - '0') * 10 + buffer[7] - '0';

        oldtime = (s + m * 60 + h * 3600) * CLK_TCK;
        return 0;
    }

    memset(buffer, 0, sizeof(buffer));
    status = _pcos_gettime(buffer, 8);
    if (status != PCOS_ERR_OK) return 0;

    h = (buffer[0] - '0') * 10 + buffer[1] - '0';
    m = (buffer[3] - '0') * 10 + buffer[4] - '0';
    s = (buffer[6] - '0') * 10 + buffer[7] - '0';

    newtime = (s + m * 60 + h * 3600) * CLK_TCK;

    if (tms) {
        memset(tms, 0, sizeof(*tms));
        tms->tms_utime = newtime - oldtime;
    }
    return newtime;
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
