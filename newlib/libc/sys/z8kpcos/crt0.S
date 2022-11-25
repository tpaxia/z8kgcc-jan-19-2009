! $Id: crt0.S,v 1.6 2009/01/09 20:58:31 chris Exp $
!
! startup code for M20 PCOS C compiler
! (c) Copyright 2001,2002,2004,2009 by Christian Groessler, chris@groessler.org
!

! configuration
/*#define SANITY_CHECKS*/
/*#define DEBUG_STACK*/
/*#define MONITOR_STACK_USAGE*/
#define CLEAR_BSS

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	.z8001

	.data

#ifdef DEBUG
nummsg:	.asciz	"(debug) Number of command line arguments: "
retmsg:	.asciz	"(debug) return value from main: "
dumpmsg:.asciz	"value: "
#endif /* #ifdef DEBUG */
#ifdef SANITY_CHECKS
invmsg:	.asciz	"PCOS/CRT internal error: cmd line arg type 0x"
#endif
#if defined(SANITY_CHECKS) || defined(DEBUG) || defined(MONITOR_STACK_USAGE)
nl:	.asciz	"\r"
#endif
#ifdef MONITOR_STACK_USAGE
sizemsg:.asciz	"STACK USED: 0x"
#endif

argv0:	.asciz	"(progname)"
tdez16:		.ASCIZ	"XXXXX$"		!Zwischenpuffer für MOVDEZ

	.bss
	.globl	__retsp

num_intargs	=	20		! max. number of integer arguments (we must provide buffer space)

		even

__retsp:	.ds.l	1
argc:		.ds.w	1
cur_argc:	.ds.w	1
argvptr:	.ds.l	21		! room for 20 cmdline args + end marker
intargsnum:	.ds.w	1
numargvarea:	.ds.b	(num_intargs * 6)	! space for command line arguments contents
#if defined(MONITOR_STACK_USAGE)
inisp:		.ds.l	1
#define STACK_SIZE (0x1000 - 0x80)	/* use -Wl,-stack,0x1000 to have a big enough stack */
 #endif
zerop:		.ds.b	1
#if defined(SANITY_CHECKS) || defined(DEBUG) || defined(MONITOR_STACK_USAGE) || defined(DEBUG_STACK)
hexbuf:		.ds.b	12
#endif


	.text

! entry point, called from PCOS
!
! The stack contains on TOS the # of command line
! arguments.
! Then there are the command line arguments on the
! stack (2 words each).
! Finally, the there is the return address to PCOS.

	.globl	_start
_start:	

#ifdef CLEAR_BSS
	calr	clrbss		! clear bss area
#endif
#ifdef DEBUG_STACK
	calr	dispstack
#endif
#ifdef MONITOR_STACK_USAGE
	ldl	inisp,rr14	! save original stack pointer
	calr	fillstack	! fill stack with 0xfa
#endif

	pop	r0,@sp
	ld	argc,r0		! save # of command line args

#ifdef DEBUG
	calr	dispnumcmldargs	! display # of command line args
#endif

	ld	cur_argc,#1
	lda	rr2,argv0
	ldl	argvptr,rr2

	cp	r0,#0
	jr	eq,cmdldone	! no command line arguments

! get all command line parameters and save them in the argv array
! this is only to save the pointers, we will later parse each of
! them to calculate the need memory for the command line args and
! then emnumerate them once more to build the real argv data

popfirst:
	popl	rr6,@sp		! get pointer to arg & type of arg
	ld	r4,cur_argc	! current index into argv table
	sll	r4,#2		! one argv entry is 4 bytes
	lda	rr2,argvptr
	add	r3,r4		! add to rr2 ptr

	ldl	@rr2,rr6	! save pointer
	inc	cur_argc,#1	! cur_argc contains # of parameters

	djnz	r0,popfirst	! get all command line parameters

	calr	setup_argv	! create the real argv

cmdldone:
	ldl	__retsp,sp	! save sp value to return to PCOS via _exit

	call	___init_fdtable	! initialize fdtable stuff

	call	__impure_init

#ifdef __STD_CALL__

! argc, argv, envp setup for -mstd
	ldl	rr0,#0		! envp
	pushl	@sp,rr0
	lda	rr0,argvptr	! argv
	pushl	@sp,rr0
	ld	r0,cur_argc	! argc
	push	@sp,r0
#else

! argc, argv, envp setup default
	ldl	rr2,#0		! envp
	lda	rr4,argvptr	! argv
	ld	r7,cur_argc	! argc

#endif /* not __STD_CALL__ */

	call	_main		! call the C program

#ifdef MONITOR_STACK_USAGE
	calr	print_stack_usage
#endif

#ifdef __STD_CALL__
	inc	r15,#10		! -mstd
	push	@sp,RET_REG	! return value
	call	_exit
!	... not reached ...

#else
	ld	r7,RET_REG	! return value
	jp	_exit

#endif


! *****
! command line parameter handling
! *****

! setup_argv: creates the argv array
! we do this:
!	- scan thru arguments and sum up size
!	- allocate needed memory
!	- create the data argv[] pointer point to in this memory
!
setup_argv:
	ld	r8,cur_argc		! # of command line args
	lda	rr2,argvptr + 4

plop:	dec	r8,#1
	jr	eq,stdone
	ldb	rl0,rr2(#1)
	cpb	rl0,#0			! empty parameter
	jr	eq,empty
	cpb	rl0,#2			! integer - work
	jr	eq,intparm
	cpb	rl0,#3			! string parameter
	jr	eq,strparm

! unknown parameter type!
! cannot happen?? -- ignore it!
! but not silently: display some message
#ifdef SANITY_CHECKS
	clrb	rh0
	calr	inv_argtype
#endif

nxtprm:	inc	r3,#4			! point to next parameter
	jr	t,plop

stdone: ret	t


! integer parameter
! get the integer
! since it might be unaligned, get each byte separately
! rr2 and rr8 preserved
intparm:pushl	@sp,rr2
	ldl	rr2,@rr2
 	ldb	rh0,@rr2
 	inc	r3,#1
 	ldb	rl0,@rr2	! integer value in r0
	ld	r1,intargsnum	! get integer parameter index
	cp	r1,#num_intargs
	jr	uge,tmip	! too many integer parms for this configuration

	sll	r1,#1		! index * 2
	ld	r2,r1
	sll	r1,#1		! index * 4
	add	r1,r2		! index * 6

	lda	rr2,numargvarea
	add	r3,r1		! rr2 points to entry
	ldl	rr4,rr2
	calr	movdez		! convert to ascii dezimal string
	ldb	@rr2,#0		! set string end
	popl	rr2,@sp
	ldl	@rr2,rr4	! set new pointer into argv
	inc	intargsnum,#1	
 	jr	t,nxtprm

tmip:	! ignore this parameter
	popl	rr2,@sp
 	jr	t,nxtprm
	

! string parameter
! We write a terminating 0 after the string. This feels broken,
! but the demo program in the Assembler Language User Guide does
! the same. I still have a bad feeling...
! rr2 and rr8 preserved
strparm:pushl	@sp,rr2
	ldl	rr2,@rr2
 	ldb	rl6,@rr2		! get length of string
 	clrb	rh6			! into r6
 	inc	r3,#1			! point to offset of ptr to string
 	ldb	rh1,@rr2		! get high byte of offset
 	inc	r3,#1
 	ldb	rl1,@rr2		! get low byte
 	ld	r3,r1			! get new offset into rr2 -> rr2 points to string
 	ldl	rr4,rr2			! copy of pointer
 	add	r5,r6			! rr4 points after string
 	ldb	@rr4,#0
 	ldl	rr4,rr2			! copy of pointer
	popl	rr2,@sp
	ldl	@rr2,rr4		! set new pointer into argv
 	jr	t,nxtprm


! empty parameter
! rr2 and rr8 preserved
empty:	ldl	rr4,#zerop
	ldl	@rr2,rr4
	jr	t,nxtprm

#ifdef DEBUG_STACK

! *****
! display stack values
! *****
dispstack:

	sub	r15,#28		! make space on the stack to
	ldm	@rr14,r0,#14	! save regs

	lda	rr2,hexbuf
	lda	rr0,__end_bss
	calr	hex32
	ldb	@rr2,#'\r'
	inc	r3,#1
	ldb	@rr2,#0
	lda	rr12,hexbuf
	sc	#89

	lda	rr2,hexbuf
	ldl	rr0,rr14
	calr	hex32
	ldb	@rr2,#'\r'
	inc	r3,#1
	ldb	@rr2,#0
	lda	rr12,hexbuf
	sc	#89

	ldm	r0,@rr14,#14	! restore regs
	add	r15,#28
	ret

#endif
#ifdef CLEAR_BSS

! *****
! clear bss segment
! *****
clrbss:	lda	rr2,__start_bss
	lda	rr4,__end_bss
clrloo:	ldb	@rr2,#0
	inc	r3,#1
	cp	r3,r5
	jr	ult,clrloo
	ret	t

#endif /* #ifdef CLEAR_BSS */
#ifdef SANITY_CHECKS

! inv_argtype
! found an invalid command line argument type
! should not happen, but if it does, tell the user

inv_argtype:
	pushl	@sp,rr2
	lda	rr2,hexbuf
	call	hex16
	ldb	@rr2,#0
	lda	rr12,invmsg
	sc	#89
	lda	rr12,hexbuf
	sc	#89
	lda	rr12,nl
	sc	#89
	popl	rr2,@sp
	ret	t

#endif /* #ifdef SANITY_CHECKS */
#ifdef DEBUG

! dispnumcmldargs
! display a text telling the # of command line args
! r0 - # to display

dispnumcmldargs:
	push	@sp,r0
	lda	rr2,hexbuf
	call	hex16
	ldb	@rr2,#0
	lda	rr12,nummsg
	sc	#89
	lda	rr12,hexbuf
	sc	#89
	lda	rr12,nl
	sc	#89
	pop	r0,@sp
	ret

#endif /* #ifdef DEBUG */
#if defined(SANITY_CHECKS) || defined(DEBUG) || defined(DEBUG_STACK)

!*****************************************************************************
!* Unterprogramm:	HEX32						     *
!* Aufgabe:		32-bit Binärzahl in String wandeln (hexadezimal)     *
!*			segmented mode					     *
!* Übergabe:		rr2 - Zeiger auf 8-byte Zielpuffer		     *
!*			rr0 - zu wandelnde Zahl				     *
!* Zurück:		rr2 - Zeiger hinter Hexstring			     *
!* Benutzt:		HEX16						     *
!*									     *
!* alle Register (außer rr0) erhalten					     *
!*****************************************************************************

hex32:
	calr	hex16
	ld	r0,r1
	!fall into hex16


!*****************************************************************************
!* Unterprogramm:	HEX16						     *
!* Aufgabe:		16-bit Binärzahl in String wandeln (hexadezimal)     *
!*			segmented mode					     *
!* Übergabe:		rr2 - Zeiger auf 4-byte Zielpuffer		     *
!*			r0  - zu wandelnde Zahl				     *
!* Zurück:		rr2 - Zeiger hinter Hexstring			     *
!* Benutzt:		HEX8						     *
!*									     *
!* alle Register (außer r0) erhalten					     *
!*****************************************************************************

hex16:
	push	@sp,r0
	ldb	rl0,rh0
	calr	hex8
	pop	r0,@sp
	!jr	t,hex8
	!calr	hex8
	!ret	t

	!fall into hex8


!*****************************************************************************
!* Unterprogramm:	HEX8						     *
!* Aufgabe:		8-bit Binärzahl in String wandeln (hexadezimal)	     *
!*			segmented mode					     *
!* Übergabe:		rr2 - Zeiger auf 2-byte Zielpuffer		     *
!*			rl0 - zu wandelnde Zahl				     *
!* Zurück:		rr2 - Zeiger hinter Hexstring			     *
!*									     *
!* alle Register (außer rl0) erhalten					     *
!*****************************************************************************

hex8:
	push	@sp,r0
	srlb	rl0,#4		! hi nibble
	cpb	rl0,#10
	jr	ult,hex8_1
	addb	rl0,#'A'-10
	jr	t,hex8_2

hex8_1:	addb	rl0,#'0'
hex8_2:	ldb	@rr2,rl0
	inc	r3,#1

	pop	r0,@sp
	andb	rl0,#15		! low nibble

	cpb	rl0,#10
	jr	ult,hex8_3
	addb	rl0,#'A'-10
	jr	t,hex8_4

hex8_3:	addb	rl0,#'0'
hex8_4:	ldb	@rr2,rl0
	inc	r3,#1
	ret	t

#endif /* #if defined(SANITY_CHECKS) || defined(DEBUG) || defined(DEBUG_STACK) */


!*****************************************************************************
!* Unterprogramm:	MOVDEZ						     *
!* Aufgabe:		R0 dezimal linksbündig nach @RR2 ablegen	     *
!*			segmented mode					     *
!* Nutzt:		DEZI16, TDEZ16					     *
!* Übergabe:		RR2 - Zieladresse des Dezimalstrings		     *
!*			R0  - zu wandelnde Zahl				     *
!* Zurück:		RR2 - Pointer hinter den String			     *
!*									     *
!* alle Register erhalten						     *
!*****************************************************************************

movdez:
	pushl	@sp,rr0
	pushl	@sp,rr4
	pushl	@sp,rr2
	lda	rr2,tdez16	! R0 in dez-String wandeln, RR2 zeigt dann auf Anfang
	calr	dezi16
	ldl	rr4,rr2
	popl	rr2,@sp

mdlop:	ldb	rl0,@rr4	! Dezimalziffer holen
	cpb	rl0,#'$'	! am Ende angekommen?
	jr	eq,mdend	! ja, Sprung
	ldb	@rr2,rl0	! kopieren
	inc	r3,#1
	inc	r5,#1
	jr	t,mdlop

mdend:	popl	rr4,@sp
	popl	rr0,@sp
	ret	t


!*****************************************************************************
!* Unterprogramm:	DEZI16						     *
!* Aufgabe:		R0 dezimal rechtsbündig (ohne führende 0) nach @RR2  *
!*			wandeln						     *
!*			segmented mode					     *
!* Übergabe:		RR2 - Pointer auf 5-Byte Zielpuffer		     *
!*			R0  - zu wandelnde Zahl				     *
!* Zurück:		RR2 - Pointer auf höchstwertige Ziffer		     *
!*									     *
!* alle Register erhalten						     *
!*****************************************************************************

dezi16:
	pushl	@sp,rr4
	pushl	@sp,rr0
	push	@sp,r0
	ld	r1,#5
	ldb	rh0,#' '
dlop:	ldb	@rr2,rh0
	inc	r3,#1
	djnz	r1,dlop
	dec	r3,#1		! rr4 zeigt auf Bufferende (niederwertigste Ziffer)
	pop	r0,@sp
!	ld	r1,r0
	ld	r1,r0

dezlop:	!ld	r0,r1
	clr	r0
	div	rr0,#10
	addb	rl0,#'0'	! RL0 = ASCII-Ziffer
	ldb	@rr2,rl0	! in Puffer kopieren
	dec	r3,#1		! Stelle erhöhen
	cp	r1,#0		! am Ende angekommen?
	jr	ne,dezlop	! nein, Loopenhausen
	inc	r3,#1		! rr2 auf höchstwertige Ziffer
	popl	rr0,@sp
	popl	rr4,@sp
	ret	t

#ifdef MONITOR_STACK_USAGE

fillstack:
	pushl	@sp,rr2
	push	@sp,r0
	ld	r0,#0xfafa
	ldl	rr2,inisp
	sub	r3,#STACK_SIZE
fsloop:	cpl	rr2,sp
	jr	uge,fsdone
	ld	@rr2,r0
	inc	r3,#2
	jr	fsloop
fsdone:	pop	r0,@sp
	popl	rr2,@sp
	ret	t

print_stack_usage:
	pushl	@sp,rr2
	push	@sp,r0

	ld	r0,#0xfafa
	ldl	rr2,inisp
	sub	r3,#STACK_SIZE
psuloop:cp	r0,@rr2
	jr	ne,psudone
	cpl	rr2,sp
	jr	uge,psudone
	inc	r3,#2
	jr	psuloop

psudone:ld	r0,inisp+2
	sub	r0,r3
	lda	rr2,hexbuf
	call	hex16
	ldb	@rr2,#0

	lda	rr12,sizemsg
	sc	#89
	lda	rr12,hexbuf
	sc	#89
	lda	rr12,nl
	sc	#89

	pop	r0,@sp
	popl	rr2,@sp
	ret	t

#endif /* #ifdef MONITOR_STACK_USAGE */


	.end

/* Local Variables: */
/* comment-start: "!" */
/* End: */
