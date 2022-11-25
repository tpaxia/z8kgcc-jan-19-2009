## Process this file with automake to generate Makefile.in

AUTOMAKE_OPTIONS = cygnus

INCLUDES = $(NEWLIB_CFLAGS) $(CROSS_CFLAGS) $(TARGET_CFLAGS)

AM_CCASFLAGS = $(INCLUDES)

noinst_LIBRARIES = lib.a

lib_a_SOURCES = glue.c read.c write.c open.c close.c creat.c unlink.c _rename.c error.S malloc.c \
	        mallocr.c free.c freer.c realloc.c reallocr.c getpid.S stat.c fstat.c isatty.c \
		errno.s _exit.S lseek.c _pcos_dgetlen.S _pcos_putbyte.S _pcos_writebytes.S \
		_pcos_new.S _pcos_close.S _pcos_dispose.S _pcos_drename.S _pcos_openfile.S \
		_pcos_dremove.S _sbrk.c _pcos_selectcur.S _pcos_getbyte.S _pcos_readbytes.S \
		_pcos_dseek.S _pcos_dgetposition.S _pcos_maxsize.S _pcos_cls.S _pcos_readcur0.S \
		_pcos_readcur1.S _pcos_chgcur0.S _pcos_chgcur1.S _pcos_chgcur2.S _pcos_chgcur3.S \
		_pcos_chgwindow.S _pcos_lookbyte.S _pcos_setcontrolbyte.S _pcos_getstatusbyte.S \
		_pcos_resetbyte.S _pcos_getdate.S _pcos_gettime.S _times.c _callocr.c calloc.c \
		_gettimeofday.c _pcos_dstring.S _get_pcostime.S _pcos_extent_len.S _pcos_search.S \
		_pcos_eof.S _pcos_ddirectory.S _pcos_bset.S _pcos_bwset.S _pcos_bclear.S \
		_pcos_bmove.S _pcos_newsamesegment.S _pcos_chgcur4.S _pcos_chgcur5.S sleep.c \
		_pcos_grfinit.S _pcos_crlf.S _pcos_settime.S _pcos_setdate.S _pcos_checkvolume.S \
		_pcos_dhex.S _pcos_dhexbyte.S _pcos_dhexlong.S _pcos_dlong.S _pcos_dnumw.S \
		_pcos_readline.S _pcos_cleartext.S _pcos_scrolltext.S
lib_a_CCASFLAGS = $(AM_CCASFLAGS)
lib_a_CFLAGS = $(AM_CFLAGS)

all: crt0.o

ACLOCAL_AMFLAGS = -I ../../.. -I ../../../..
CONFIG_STATUS_DEPENDENCIES = $(newlib_basedir)/configure.host
