#include <reent.h>

/* Note that there is a copy of this in sys/reent.h.  */
#ifndef __ATTRIBUTE_IMPURE_PTR__
#define __ATTRIBUTE_IMPURE_PTR__
#endif

#ifndef __ATTRIBUTE_IMPURE_DATA__
#define __ATTRIBUTE_IMPURE_DATA__
#endif

#ifndef __Z8000__
static struct _reent __ATTRIBUTE_IMPURE_DATA__ impure_data = _REENT_INIT (impure_data);
#else
static struct _reent __ATTRIBUTE_IMPURE_DATA__ impure_data;
static struct _reent __ATTRIBUTE_IMPURE_DATA__ my_impure_data = _REENT_INIT (impure_data);

#if 0
static unsigned char inited;
#endif

void _impure_init(void)
{
#if 0
    if (! inited) {
#endif
        impure_data = my_impure_data;
#if 0
        inited = 1;
    }
#endif
}
#endif
struct _reent *__ATTRIBUTE_IMPURE_PTR__ _impure_ptr = &impure_data;
