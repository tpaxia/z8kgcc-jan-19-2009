#ifndef	_MACHTIME_H_
#define	_MACHTIME_H_

#if defined(__rtems__)
#define _CLOCKS_PER_SEC_  sysconf(_SC_CLK_TCK)
#else  /* !__rtems__ */
#if defined(__arm__) || defined(__thumb__)
#define _CLOCKS_PER_SEC_ 100
#else
#if defined(__Z8001__)  /* @@@ CPG todo: only for PCOS... */
#define _CLOCKS_PER_SEC_ 20
#endif
#endif
#endif /* !__rtems__ */

#endif	/* _MACHTIME_H_ */


