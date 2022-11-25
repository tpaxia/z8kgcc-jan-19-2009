/* $Id: pcosdebug.h,v 1.4 2002/12/14 01:21:48 chris Exp $
 *
 * PCOS runtime lib debug defines
 * (c) Christian Groessler 2001
 */

#ifndef __PCOSDEBUG_H__
#define __PCOSDEBUG_H__

/*#define DEBUG*/
#ifdef DEBUG
#define DEB_PRINT(str) _pcos_print(str)
#define NUM_PRINT(str, long) __pcos_num_print(str, long)
extern void __pcos_num_print(char *str, unsigned long val);
extern void _pcos_print(char *str);
#else
#define DEB_PRINT(str)
#define NUM_PRINT(str, long)
#endif

#endif /* #ifndef __PCOSDEBUG_H__ */
