/* $Id: sleep.c,v 1.1 2004/03/13 23:21:45 chris Exp $ */

#include <sys/types.h>
#include <time.h>
#include <sys/time.h>
#include <sys/times.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

/* in _gettimeofday.c */
extern int _gettimeofday (struct timeval *tv, struct timezone *tz);

unsigned int sleep(unsigned int seconds)
{
    struct pcostime cur_time;
    int start_ticks;
    struct timeval tv;
    long end;

    if (! seconds) return 0;

    _get_pcostime(&cur_time);
    start_ticks = cur_time.ticks;

    _gettimeofday(&tv, NULL);
    end = tv.tv_sec + seconds;

    while (tv.tv_sec < end)
        _gettimeofday(&tv, NULL);

    if (start_ticks > 2 && start_ticks < CLK_TCK - 3) {
        _get_pcostime(&cur_time);
        while (cur_time.ticks < start_ticks)
            _get_pcostime(&cur_time);
    }

    return 0;
}


/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
