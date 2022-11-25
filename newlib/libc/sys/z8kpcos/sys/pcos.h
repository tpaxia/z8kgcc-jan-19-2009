/* $Id: pcos.h,v 1.21 2004/05/23 00:27:15 chris Exp $
 *
 * Olivetti M20 PCOS definitions
 */

#ifndef __PCOS_H__
#define __PCOS_H__

/*
 * PCOS error codes
 */
#define PCOS_ERR_OK       0
#define PCOS_ERR_XXX      3   /* "invalid termination of input byte stream */
#define PCOS_ERR_MEM      7   /* "out of memory" */
#define PCOS_ERR_INVADR   9   /* "invalid listener or talker address" */
#define PCOS_ERR_NOIEEE   10  /* "no IEEE board" */
#define PCOS_ERR_TO       11  /* "time out error" */
#define PCOS_ERR_DATATYPE 13  /* "bad data type" */
#define PCOS_ERR_NOWIN    35  /* "window does not exist" */
#define PCOS_ERR_WINCREAT 36  /* "window create error" */
#define PCOS_ERR_NOENT    53  /* "file not found" */
#define PCOS_ERR_MODE     54  /* "bad file open mode" */
#define PCOS_ERR_ALOPN    55  /* "file already open" */
#define PCOS_ERR_EIO      57  /* "disk i/o" */
#define PCOS_ERR_EEXIST   58  /* "file aready exists" */
#define PCOS_ERR_NOTINIT  60  /* "disk not initialized" */
#define PCOS_ERR_NOSPC    61  /* "disk filled" */
#define PCOS_ERR_EOF      62  /* "end of file" */
#define PCOS_ERR_REC      63  /* "bad record number" */
#define PCOS_ERR_NAME     64  /* "bad file name" */
#define PCOS_ERR_VNOENT   71  /* "volume name not found" */
#define PCOS_ERR_INVVOL   73  /* "invalid volume number" */
#define PCOS_ERR_VOLNOTEN 75  /* "volume not enabled" */
#define PCOS_ERR_PASSWD   76  /* "password not valid" */
#define PCOS_ERR_DCHG     77  /* "illegal disk change" */
#define PCOS_ERR_WRPROT   78  /* "write protected file" */
#define PCOS_ERR_CPPROT   79  /* "copy protected file" */
#define PCOS_ERR_PARM     90  /* "error in parameter" */
#define PCOS_ERR_TOOMPARM 91  /* "too many parameters" */
#define PCOS_ERR_NOTFND   92  /* "command not found" */
#define PCOS_ERR_NOTOPM   96  /* "file not open" */
#define PCOS_ERR_BADLOAD  99  /* "bad load file" */
#define PCOS_ERR_TIMDAT  101  /* "time or date" */
#define PCOS_ERR_EXFN    106  /* "function key already exists" */
#define PCOS_ERR_CALLUSR 108  /* "call-user" */
#define PCOS_ERR_TO2     110  /* "time-out" */
#define PCOS_ERR_INVDEV  111  /* "invalid device" */


/*
 * PCOS open modes
 */
#define PCOS_OPEN_READ    0
#define PCOS_OPEN_WRITE   1
#define PCOS_OPEN_RDWRITE 2
#define PCOS_OPEN_APPEND  3

#define DEFAULT_EXTENT_LEN 4

/*
 * PCOS DID defines
 *
 * valid DID numbers:
 * 1-15 BASIC files
 * 17 console
 * 18 printer
 * 20-24 PCOS files
 * 19,25,26 Com, Com1, Com2
 */
#define DID_CONSOLE 17
#define DID_PRINTER 18
#define DID_COM     19
#define DID_COM1    25
#define DID_COM2    26

#define is_file_did(did) ((did) != DID_CONSOLE && \
                          (did) != DID_PRINTER && \
                          (did) != DID_COM     && \
                          (did) != DID_COM1    && \
                          (did) != DID_COM2)

#define is_file_or_com_did(did) ((did) != DID_CONSOLE && \
                                 (did) != DID_PRINTER)

#ifndef ERRNO_VALS_ONLY

extern unsigned short _pcos_extent_length;

/* internal functions */
extern int errno_from_pcos_err(int pcos_err);

extern void __inline__ _pcos_print(char *str)
{
    /* BUGBUG: this doesn't work! the clobber is ignored!!!!
    asm("pushl   @rr14,rr10 \n\t"
        "ldl     rr12,%S0 \n\t"
        "sc      #89      \n\t"
        "popl    rr10,@rr14 \n\t" : : "r" (str) : "12", "13" );
    */
    asm("pushl   @rr14,rr12 \n\t"
        "ldl     rr12,%S0   \n\t"
        "push    @rr14,r5   \n\t"  /* probably destroyed by sc call */
        "sc      #89        \n\t"
        "pop     r5,@rr14   \n\t"
        "popl    rr12,@rr14 \n\t" : : "r" (str) /*: "5"*/);
}

/* used by _get_pcostime */
struct pcostime {
    int ticks;  /* 20th of a second */
    int seconds;
    int minutes;
    int hours;
    int day;
    int month;
    int year;
};

typedef unsigned char cursor_shape[12];

/* PCOS + BIOS character codes */
#define PCOS_CH_CURS_DOWN    154     /* shft - keypad */
#define PCOS_CH_CURS_UP      158
#define PCOS_CH_CURS_LEFT    155
#define PCOS_CH_CURS_RIGHT   157
#define PCOS_CH_DEL          8       /* ^H */
#define PCOS_CH_TAB          9       /* ^I */
#define PCOS_CH_DELCHR       4       /* ^D */
#define PCOS_CH_ESC          221
#define PCOS_CH_STOP         3       /* ^C */
#define PCOS_CH_EOL          13
#define PCOS_CH_ENTER        13

/* PCOS system calls */
extern int _pcos_dgetlen(int did, unsigned long *length);
extern int _pcos_dgetposition(int did, unsigned long *length);
extern int _pcos_dseek(int did, unsigned long offset);
extern int _pcos_resetbyte(int did);
extern int _pcos_eof(int did, unsigned int *status);
extern int _pcos_putbyte(int did, unsigned char byte);
extern int _pcos_getbyte(int did, unsigned char *byte);
extern int _pcos_writebytes(int did, const void *buffer,
                            unsigned int nbytes, unsigned int *retbytes);
extern int _pcos_readbytes(int did, const void *buffer,
                           unsigned int nbytes, unsigned int *retbytes);
extern int _pcos_readline(int did, const void *buffer,
                          unsigned int nbytes, unsigned int *retbytes);
extern int _pcos_new(unsigned short length, void **memory);
extern int _pcos_newsamesegment(unsigned short length, void **memory);
extern int _pcos_dispose(int length, void **memory);
extern int _pcos_drename(const char *from, int fromlen, const char *to, int tolen);
extern int _pcos_dremove(const char *name, int namelen);
extern int _pcos_openfile(int did, const char *name, int namelen, int mode,
                          int extent_len);
extern int _pcos_close(int did);
extern int _pcos_ddirectory(const char *name, int namelen);
extern int _pcos_maxsize(unsigned short *maxsize);
extern int _pcos_search(int drive, int search_mode, int *length, char **file_pointer,
                        char *name_pointer);
extern void _pcos_selectcur(int mode);
extern void _pcos_cls(void);
extern int _pcos_crlf(void);
extern void _pcos_grfinit(int *color, void **pointer);
extern int _pcos_cleartext(unsigned int column, unsigned int row,
                           unsigned int xlen, unsigned int ylen);
extern int _pcos_scrolltext(unsigned int plane_mask, unsigned int function,
                            unsigned int src_x, unsigned int src_y,
                            unsigned int dst_x, unsigned int dst_y,
                            unsigned int xlen, unsigned int ylen);
extern int _pcos_bset(void *dest, unsigned char val, unsigned int len);
extern int _pcos_bwset(void *dest, unsigned short val, unsigned int len);
extern int _pcos_bclear(void *dest, unsigned int len);
extern int _pcos_bmove(void *dest, const void *src, unsigned int len);
extern int _pcos_dstring(char *string);
extern int _pcos_dhex(unsigned int word);
extern int _pcos_dhexbyte(unsigned char byte);
extern int _pcos_dhexlong(unsigned long byte);
extern int _pcos_dlong(unsigned long byte);
extern int _pcos_dnumw(unsigned int word, unsigned int field_width);
extern int _pcos_gettime(char *buf, unsigned int buflen);
extern int _pcos_getdate(char *buf, unsigned int buflen);
extern int _pcos_settime(char *buf, unsigned int buflen);
extern int _pcos_setdate(char *buf, unsigned int buflen);
extern int _pcos_lookbyte(int did, unsigned char *byte, unsigned char *buffer_status);
extern int _pcos_chgwindow(unsigned int fgcolor, unsigned int bgcolor);
extern int _pcos_readcur0(cursor_shape *shape, unsigned int *blinkrate,
                          unsigned int *column, unsigned int *row);
extern int _pcos_readcur1(cursor_shape *shape, unsigned int *blinkrate,
                          unsigned int *x_pos, unsigned int *y_pos);
extern int _pcos_chgcur0(unsigned int column, unsigned int row);
extern int _pcos_chgcur1(unsigned int x_pos, unsigned int y_pos);
extern void _pcos_chgcur2(unsigned int blinkrate);
extern void _pcos_chgcur3(unsigned int blinkrate);
extern void _pcos_chgcur4(cursor_shape new_shape);
extern void _pcos_chgcur5(cursor_shape new_shape);
extern int _pcos_setcontrolbyte(int did, unsigned int word_number, unsigned int word);
extern int _pcos_getstatusbyte(int did, unsigned int word_number, unsigned int *word);
extern int _pcos_checkvolume(void);

/* utility routines */
extern void _get_pcostime(struct pcostime *cur_time);

#endif /* #ifndef ERRNO_VALS_ONLY */
#endif /* #ifndef __PCOS_H__ */
/* Local Variables: */
/* c-file-style: "cpg" */
/* c-basic-offset: 4 */
/* End: */
