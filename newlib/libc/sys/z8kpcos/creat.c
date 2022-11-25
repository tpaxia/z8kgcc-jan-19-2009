/* $Id: creat.c,v 1.1 2001/11/15 21:22:26 chris Exp $ */
/* creat() "system call" */
/* This is needed by f2c and therefore the SPEC benchmarks.  */
/* copied from sparc64 version */

#include <fcntl.h>

int
creat (const char *path, mode_t mode)
{
  return open (path, O_WRONLY | O_CREAT | O_TRUNC, mode);
}
