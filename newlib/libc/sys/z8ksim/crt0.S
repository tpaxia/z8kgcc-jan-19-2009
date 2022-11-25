

#ifdef __STD_CALL__
#define RET_REG r7
#else
#define RET_REG r2
#endif

	.globl	_start

#if defined(__Z8001__)
	.z8001

	.text
_start:
	ldl	rr14,#__stack_top
	ldl	rr10,rr14

	calr	clrbss		! clear bss area
	call	__impure_init

#ifdef __STD_CALL__

! argc, argv, envp setup for -mstd
	ldl	rr0,#0
	pushl	@sp,rr0		! envp
	pushl	@sp,rr0		! argv
	push	@sp,r0		! argc
#else

! argc, argv, envp setup default
	ldl	rr2,#0		! envp
	ldl	rr4,rr2		! argv
	ld	r7,r2		! argc

#endif /* not __STD_CALL__ */

	call	_main		! call the C program

#ifdef __STD_CALL__
	inc	r15,#10		! -mstd
	push	@sp,RET_REG
	call	_exit
#else
	ld	r7,RET_REG
	call	_exit
#endif
	!... not reached


! *****
! clear bss segment (Z8001 version)
! *****
clrbss:	lda	rr2,__start_bss
	lda	rr4,__end_bss
clrloo:	ldb	@rr2,#0
	inc	r3,#1
	cp	r3,r5
	jr	ult,clrloo
	ret	t

#endif /* #if defined(__Z8001__) */

#if defined(__Z8002__)
	.z8002

	.text
_start:
	ld	r15,#__stack_top
	ld	r10,r15

	calr	clrbss		! clear bss area
	call	__impure_init
	calr	___main

#ifdef __STD_CALL__

! argc, argv, envp setup for -mstd
	ldk	r0,#0
	push	@sp,r0		! envp
	push	@sp,r0		! argv
	push	@sp,r0		! argc
#else

! argc, argv, envp setup default
	ldk	r5,#0		! envp
	ld	r6,r5		! argv
	ld	r7,r5		! argc

#endif /* not __STD_CALL__ */

	call	_main		! call the C program

#ifdef __STD_CALL__
	inc	r15,#10		! -mstd
	push	@sp,RET_REG
	call	_exit
#else
	ld	r7,RET_REG
	call	_exit
#endif
	!... not reached


! *****
! clear bss segment (Z8002 version)
! *****
clrbss:	lda	r2,__start_bss
	lda	r4,__end_bss
clrloo:	ldb	@r2,#0
	inc	r2,#1
	cp	r2,r4
	jr	ult,clrloo
	ret	t


___main:
	ldb	rl0,initialized
	cpb	rl0,#0
	jr	ne,return
	incb	rl0,#1
	ldb	initialized,rl0
	calr	___do_global_ctors
return:	ret	t

___do_global_ctors:
	ld	r1,#___ctors_end
do_loop:cp	r1,#___ctors
	jr	ugt,do_cont
	ret	t
do_cont:dec	r1,#2
	push	@sp,r1
	ld	r1,@r1
	call	@r1
	pop	r1,@sp
	jr	t,do_loop

	.bss

initialized:	.ds.b	1

#endif /* #if defined(__Z8002__) */

