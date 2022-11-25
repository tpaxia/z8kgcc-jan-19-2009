/* $Id: glue.h,v 1.1 2001/11/15 20:47:17 chris Exp $ */

#ifndef __GLUE_H__
#define __GLUE_H__

extern signed char fdtable[];
extern signed char didfree[];

extern signed char __newfd(void);
extern signed char __findfreedid(void);

#endif /* #ifndef __GLUE_H__ */
