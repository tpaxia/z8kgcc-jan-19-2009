/* Definitions of target machine for GNU compiler, for Zilog Z8000
   on Olivetti PCOS
   Copyright (C) 2001 Christian Groessler, chris@groessler.org
*/

#define __Z8KPCOS__

#include "z8k/z8k.h"

#undef TARGET_DEFAULT
#define TARGET_DEFAULT \
 (TARGET_REGPARMS_BIT|TARGET_STRUCT_BYTE_ALIGN_BIT|\
  TARGET_TYPE64_BIT|TARGET_TYPED64_BIT|TARGET_BIG_BIT)

#undef CPP_SPEC
#define CPP_SPEC \
  "%{mz8002:-D__Z8002__ -D__PTRDIFF_TYPE__=int}			\
   %{!mz8002:-D__Z8001__  -D__PTRDIFF_TYPE__=long\\ int} 	\
   %{mz8002:-D__SIZE_TYPE__=unsigned\\ int} 			\
   %{!mz8002:-D__SIZE_TYPE__=long\\ unsigned\\ int} 	       	\
   %{!mint32:-D__INT_MAX__=32767} %{mstd:-D__STD_CALL__} %{mint32:-D__INT_MAX__=2147483647}"

#undef LINK_SPEC
#define LINK_SPEC "%{!mz8002:-m z8001}"

