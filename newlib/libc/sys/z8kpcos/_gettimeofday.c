/* $Id: _gettimeofday.c,v 1.2 2003/08/17 23:58:53 chris Exp $ */

#include <sys/types.h>
#include <time.h>
#include <sys/time.h>
#include <sys/times.h>
#include <sys/pcos.h>
#include "pcosdebug.h"

static int date_factor(int day, int month, int year);

int _gettimeofday (struct timeval *tv, struct timezone *tz)
{
    struct pcostime cur_time;
    int factor;

    if (tz) memset(tz, 0, sizeof(*tz));
    if (tv) {
        _get_pcostime(&cur_time);
        factor = date_factor(cur_time.day, cur_time.month,
                             cur_time.year < 1982 ? cur_time.year + 100 : cur_time.year);

        tv->tv_sec = (long)factor * (24L * 60L * 60L)
            + (cur_time.hours * 60L + cur_time.minutes) * 60L + cur_time.seconds;
        tv->tv_usec = -(cur_time.ticks - 20) * 50000L;
    }
    return 0;
}


/*
 * date_factor
 * calculates days since 01-01-1970
 * input - date: day, month, year
 * output - number of days for date
 * (thx to chg and horg)
 */

static int date_factor(int day, int month, int year)
{
#define MAGIC_DATE 719528  /* factor for 01-01-1970 */

    long factor;

    factor = 365 * (long)year + 31 * ((long)month - 1) + (long)day;
    if ((2 >= month) && (month >= 1))  {
        factor += (long)((year - 1) / 4) - (long)(3 * (long)(((year - 1) / 100) + 1))/4;
    }
    else if ((12 >= month) && (month >= 3))  {
        factor += (long)(year / 4) - (long)(4 * month + 23)/10
            - (long)(3 * ((long)(year / 100) + 1))/4;
    }
    else
        return -1;

    return factor - MAGIC_DATE;
}

/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
