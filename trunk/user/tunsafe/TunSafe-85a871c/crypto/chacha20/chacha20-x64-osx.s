.text	

.p2align	6
L$zero:
.long	0,0,0,0
L$one:
.long	1,0,0,0
L$inc:
.long	0,1,2,3
L$four:
.long	4,4,4,4
L$incy:
.long	0,2,4,6,1,3,5,7
L$eight:
.long	8,8,8,8,8,8,8,8
L$rot16:
.byte	0x2,0x3,0x0,0x1, 0x6,0x7,0x4,0x5, 0xa,0xb,0x8,0x9, 0xe,0xf,0xc,0xd
L$rot24:
.byte	0x3,0x0,0x1,0x2, 0x7,0x4,0x5,0x6, 0xb,0x8,0x9,0xa, 0xf,0xc,0xd,0xe
L$sigma:
.byte	101,120,112,97,110,100,32,51,50,45,98,121,116,101,32,107,0
.p2align	6
L$zeroz:
.long	0,0,0,0, 1,0,0,0, 2,0,0,0, 3,0,0,0
L$fourz:
.long	4,0,0,0, 4,0,0,0, 4,0,0,0, 4,0,0,0
L$incz:
.long	0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
L$sixteen:
.long	16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16
.p2align	6
L$twoy:
.long	2,0,0,0, 2,0,0,0

.global	_hchacha20_ssse3

.p2align	5
_hchacha20_ssse3:

L$hchacha20_ssse3:
	movdqa	L$sigma(%rip),%xmm0
	movdqu	(%rdx),%xmm1
	movdqu	16(%rdx),%xmm2
	movdqu	(%rsi),%xmm3
	movdqa	L$rot16(%rip),%xmm6
	movdqa	L$rot24(%rip),%xmm7
	movq	10,%r8
.p2align	5
L$oop_hssse3:
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm6,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	20,%xmm1
	pslld	12,%xmm4
	por	%xmm4,%xmm1
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm7,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	25,%xmm1
	pslld	7,%xmm4
	por	%xmm4,%xmm1
	pshufd	$78,%xmm2,%xmm2
	pshufd	$57,%xmm1,%xmm1
	pshufd	$147,%xmm3,%xmm3
	nop
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm6,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	20,%xmm1
	pslld	12,%xmm4
	por	%xmm4,%xmm1
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm7,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	25,%xmm1
	pslld	7,%xmm4
	por	%xmm4,%xmm1
	pshufd	$78,%xmm2,%xmm2
	pshufd	$147,%xmm1,%xmm1
	pshufd	$57,%xmm3,%xmm3
	decq	%r8
	jnz	L$oop_hssse3
	movdqu	%xmm0,0(%rdi)
	movdqu	%xmm3,16(%rdi)
	ret


.global	_chacha20_ssse3

.p2align	5
_chacha20_ssse3:

L$chacha20_ssse3:
	movq	%rsp,%r9

	cmpq	$128,%rdx
	ja	L$chacha20_4x

L$do_sse3_after_all:
	subq	$64+8,%rsp
	movdqa	L$sigma(%rip),%xmm0
	movdqu	(%rcx),%xmm1
	movdqu	16(%rcx),%xmm2
	movdqu	(%r8),%xmm3
	movdqa	L$rot16(%rip),%xmm6
	movdqa	L$rot24(%rip),%xmm7

	movdqa	%xmm0,0(%rsp)
	movdqa	%xmm1,16(%rsp)
	movdqa	%xmm2,32(%rsp)
	movdqa	%xmm3,48(%rsp)
	movq	$10,%r8
	jmp	L$oop_ssse3

.p2align	5
L$oop_outer_ssse3:
	movdqa	L$one(%rip),%xmm3
	movdqa	0(%rsp),%xmm0
	movdqa	16(%rsp),%xmm1
	movdqa	32(%rsp),%xmm2
	paddd	48(%rsp),%xmm3
	movq	$10,%r8
	movdqa	%xmm3,48(%rsp)
	jmp	L$oop_ssse3

.p2align	5
L$oop_ssse3:
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm6,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	$20,%xmm1
	pslld	$12,%xmm4
	por	%xmm4,%xmm1
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm7,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	$25,%xmm1
	pslld	$7,%xmm4
	por	%xmm4,%xmm1
	pshufd	$78,%xmm2,%xmm2
	pshufd	$57,%xmm1,%xmm1
	pshufd	$147,%xmm3,%xmm3
	nop
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm6,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	$20,%xmm1
	pslld	$12,%xmm4
	por	%xmm4,%xmm1
	paddd	%xmm1,%xmm0
	pxor	%xmm0,%xmm3
	pshufb	%xmm7,%xmm3
	paddd	%xmm3,%xmm2
	pxor	%xmm2,%xmm1
	movdqa	%xmm1,%xmm4
	psrld	$25,%xmm1
	pslld	$7,%xmm4
	por	%xmm4,%xmm1
	pshufd	$78,%xmm2,%xmm2
	pshufd	$147,%xmm1,%xmm1
	pshufd	$57,%xmm3,%xmm3
	decq	%r8
	jnz	L$oop_ssse3
	paddd	0(%rsp),%xmm0
	paddd	16(%rsp),%xmm1
	paddd	32(%rsp),%xmm2
	paddd	48(%rsp),%xmm3

	cmpq	$64,%rdx
	jb	L$tail_ssse3

	movdqu	0(%rsi),%xmm4
	movdqu	16(%rsi),%xmm5
	pxor	%xmm4,%xmm0
	movdqu	32(%rsi),%xmm4
	pxor	%xmm5,%xmm1
	movdqu	48(%rsi),%xmm5
	leaq	64(%rsi),%rsi
	pxor	%xmm4,%xmm2
	pxor	%xmm5,%xmm3

	movdqu	%xmm0,0(%rdi)
	movdqu	%xmm1,16(%rdi)
	movdqu	%xmm2,32(%rdi)
	movdqu	%xmm3,48(%rdi)
	leaq	64(%rdi),%rdi

	subq	$64,%rdx
	jnz	L$oop_outer_ssse3

	jmp	L$done_ssse3

.p2align	4
L$tail_ssse3:
	movdqa	%xmm0,0(%rsp)
	movdqa	%xmm1,16(%rsp)
	movdqa	%xmm2,32(%rsp)
	movdqa	%xmm3,48(%rsp)
	xorq	%r8,%r8

L$oop_tail_ssse3:
	movzbl	(%rsi,%r8,1),%eax
	movzbl	(%rsp,%r8,1),%ecx
	leaq	1(%r8),%r8
	xorl	%ecx,%eax
	movb	%al,-1(%rdi,%r8,1)
	decq	%rdx
	jnz	L$oop_tail_ssse3

L$done_ssse3:
	leaq	(%r9),%rsp

L$ssse3_epilogue:
	ret


.global	_chacha20_4x

.p2align	5
_chacha20_4x:

L$chacha20_4x:
	movq	%rsp,%r9












L$proceed4x:
	subq	$0x140+8,%rsp
	movdqa	L$sigma(%rip),%xmm11
	movdqu	(%rcx),%xmm15
	movdqu	16(%rcx),%xmm7
	movdqu	(%r8),%xmm3
	leaq	256(%rsp),%rcx
	leaq	L$rot16(%rip),%r10
	leaq	L$rot24(%rip),%r11

	pshufd	$0x00,%xmm11,%xmm8
	pshufd	$0x55,%xmm11,%xmm9
	movdqa	%xmm8,64(%rsp)
	pshufd	$0xaa,%xmm11,%xmm10
	movdqa	%xmm9,80(%rsp)
	pshufd	$0xff,%xmm11,%xmm11
	movdqa	%xmm10,96(%rsp)
	movdqa	%xmm11,112(%rsp)

	pshufd	$0x00,%xmm15,%xmm12
	pshufd	$0x55,%xmm15,%xmm13
	movdqa	%xmm12,128-256(%rcx)
	pshufd	$0xaa,%xmm15,%xmm14
	movdqa	%xmm13,144-256(%rcx)
	pshufd	$0xff,%xmm15,%xmm15
	movdqa	%xmm14,160-256(%rcx)
	movdqa	%xmm15,176-256(%rcx)

	pshufd	$0x00,%xmm7,%xmm4
	pshufd	$0x55,%xmm7,%xmm5
	movdqa	%xmm4,192-256(%rcx)
	pshufd	$0xaa,%xmm7,%xmm6
	movdqa	%xmm5,208-256(%rcx)
	pshufd	$0xff,%xmm7,%xmm7
	movdqa	%xmm6,224-256(%rcx)
	movdqa	%xmm7,240-256(%rcx)

	pshufd	$0x00,%xmm3,%xmm0
	pshufd	$0x55,%xmm3,%xmm1
	paddd	L$inc(%rip),%xmm0
	pshufd	$0xaa,%xmm3,%xmm2
	movdqa	%xmm1,272-256(%rcx)
	pshufd	$0xff,%xmm3,%xmm3
	movdqa	%xmm2,288-256(%rcx)
	movdqa	%xmm3,304-256(%rcx)

	jmp	L$oop_enter4x

.p2align	5
L$oop_outer4x:
	movdqa	64(%rsp),%xmm8
	movdqa	80(%rsp),%xmm9
	movdqa	96(%rsp),%xmm10
	movdqa	112(%rsp),%xmm11
	movdqa	128-256(%rcx),%xmm12
	movdqa	144-256(%rcx),%xmm13
	movdqa	160-256(%rcx),%xmm14
	movdqa	176-256(%rcx),%xmm15
	movdqa	192-256(%rcx),%xmm4
	movdqa	208-256(%rcx),%xmm5
	movdqa	224-256(%rcx),%xmm6
	movdqa	240-256(%rcx),%xmm7
	movdqa	256-256(%rcx),%xmm0
	movdqa	272-256(%rcx),%xmm1
	movdqa	288-256(%rcx),%xmm2
	movdqa	304-256(%rcx),%xmm3
	paddd	L$four(%rip),%xmm0

L$oop_enter4x:
	movdqa	%xmm6,32(%rsp)
	movdqa	%xmm7,48(%rsp)
	movdqa	(%r10),%xmm7
	movl	$10,%eax
	movdqa	%xmm0,256-256(%rcx)
	jmp	L$oop4x

.p2align	5
L$oop4x:
	paddd	%xmm12,%xmm8
	paddd	%xmm13,%xmm9
	pxor	%xmm8,%xmm0
	pxor	%xmm9,%xmm1
	pshufb	%xmm7,%xmm0
	pshufb	%xmm7,%xmm1
	paddd	%xmm0,%xmm4
	paddd	%xmm1,%xmm5
	pxor	%xmm4,%xmm12
	pxor	%xmm5,%xmm13
	movdqa	%xmm12,%xmm6
	pslld	$12,%xmm12
	psrld	$20,%xmm6
	movdqa	%xmm13,%xmm7
	pslld	$12,%xmm13
	por	%xmm6,%xmm12
	psrld	$20,%xmm7
	movdqa	(%r11),%xmm6
	por	%xmm7,%xmm13
	paddd	%xmm12,%xmm8
	paddd	%xmm13,%xmm9
	pxor	%xmm8,%xmm0
	pxor	%xmm9,%xmm1
	pshufb	%xmm6,%xmm0
	pshufb	%xmm6,%xmm1
	paddd	%xmm0,%xmm4
	paddd	%xmm1,%xmm5
	pxor	%xmm4,%xmm12
	pxor	%xmm5,%xmm13
	movdqa	%xmm12,%xmm7
	pslld	$7,%xmm12
	psrld	$25,%xmm7
	movdqa	%xmm13,%xmm6
	pslld	$7,%xmm13
	por	%xmm7,%xmm12
	psrld	$25,%xmm6
	movdqa	(%r10),%xmm7
	por	%xmm6,%xmm13
	movdqa	%xmm4,0(%rsp)
	movdqa	%xmm5,16(%rsp)
	movdqa	32(%rsp),%xmm4
	movdqa	48(%rsp),%xmm5
	paddd	%xmm14,%xmm10
	paddd	%xmm15,%xmm11
	pxor	%xmm10,%xmm2
	pxor	%xmm11,%xmm3
	pshufb	%xmm7,%xmm2
	pshufb	%xmm7,%xmm3
	paddd	%xmm2,%xmm4
	paddd	%xmm3,%xmm5
	pxor	%xmm4,%xmm14
	pxor	%xmm5,%xmm15
	movdqa	%xmm14,%xmm6
	pslld	$12,%xmm14
	psrld	$20,%xmm6
	movdqa	%xmm15,%xmm7
	pslld	$12,%xmm15
	por	%xmm6,%xmm14
	psrld	$20,%xmm7
	movdqa	(%r11),%xmm6
	por	%xmm7,%xmm15
	paddd	%xmm14,%xmm10
	paddd	%xmm15,%xmm11
	pxor	%xmm10,%xmm2
	pxor	%xmm11,%xmm3
	pshufb	%xmm6,%xmm2
	pshufb	%xmm6,%xmm3
	paddd	%xmm2,%xmm4
	paddd	%xmm3,%xmm5
	pxor	%xmm4,%xmm14
	pxor	%xmm5,%xmm15
	movdqa	%xmm14,%xmm7
	pslld	$7,%xmm14
	psrld	$25,%xmm7
	movdqa	%xmm15,%xmm6
	pslld	$7,%xmm15
	por	%xmm7,%xmm14
	psrld	$25,%xmm6
	movdqa	(%r10),%xmm7
	por	%xmm6,%xmm15
	paddd	%xmm13,%xmm8
	paddd	%xmm14,%xmm9
	pxor	%xmm8,%xmm3
	pxor	%xmm9,%xmm0
	pshufb	%xmm7,%xmm3
	pshufb	%xmm7,%xmm0
	paddd	%xmm3,%xmm4
	paddd	%xmm0,%xmm5
	pxor	%xmm4,%xmm13
	pxor	%xmm5,%xmm14
	movdqa	%xmm13,%xmm6
	pslld	$12,%xmm13
	psrld	$20,%xmm6
	movdqa	%xmm14,%xmm7
	pslld	$12,%xmm14
	por	%xmm6,%xmm13
	psrld	$20,%xmm7
	movdqa	(%r11),%xmm6
	por	%xmm7,%xmm14
	paddd	%xmm13,%xmm8
	paddd	%xmm14,%xmm9
	pxor	%xmm8,%xmm3
	pxor	%xmm9,%xmm0
	pshufb	%xmm6,%xmm3
	pshufb	%xmm6,%xmm0
	paddd	%xmm3,%xmm4
	paddd	%xmm0,%xmm5
	pxor	%xmm4,%xmm13
	pxor	%xmm5,%xmm14
	movdqa	%xmm13,%xmm7
	pslld	$7,%xmm13
	psrld	$25,%xmm7
	movdqa	%xmm14,%xmm6
	pslld	$7,%xmm14
	por	%xmm7,%xmm13
	psrld	$25,%xmm6
	movdqa	(%r10),%xmm7
	por	%xmm6,%xmm14
	movdqa	%xmm4,32(%rsp)
	movdqa	%xmm5,48(%rsp)
	movdqa	0(%rsp),%xmm4
	movdqa	16(%rsp),%xmm5
	paddd	%xmm15,%xmm10
	paddd	%xmm12,%xmm11
	pxor	%xmm10,%xmm1
	pxor	%xmm11,%xmm2
	pshufb	%xmm7,%xmm1
	pshufb	%xmm7,%xmm2
	paddd	%xmm1,%xmm4
	paddd	%xmm2,%xmm5
	pxor	%xmm4,%xmm15
	pxor	%xmm5,%xmm12
	movdqa	%xmm15,%xmm6
	pslld	$12,%xmm15
	psrld	$20,%xmm6
	movdqa	%xmm12,%xmm7
	pslld	$12,%xmm12
	por	%xmm6,%xmm15
	psrld	$20,%xmm7
	movdqa	(%r11),%xmm6
	por	%xmm7,%xmm12
	paddd	%xmm15,%xmm10
	paddd	%xmm12,%xmm11
	pxor	%xmm10,%xmm1
	pxor	%xmm11,%xmm2
	pshufb	%xmm6,%xmm1
	pshufb	%xmm6,%xmm2
	paddd	%xmm1,%xmm4
	paddd	%xmm2,%xmm5
	pxor	%xmm4,%xmm15
	pxor	%xmm5,%xmm12
	movdqa	%xmm15,%xmm7
	pslld	$7,%xmm15
	psrld	$25,%xmm7
	movdqa	%xmm12,%xmm6
	pslld	$7,%xmm12
	por	%xmm7,%xmm15
	psrld	$25,%xmm6
	movdqa	(%r10),%xmm7
	por	%xmm6,%xmm12
	decl	%eax
	jnz	L$oop4x

	paddd	64(%rsp),%xmm8
	paddd	80(%rsp),%xmm9
	paddd	96(%rsp),%xmm10
	paddd	112(%rsp),%xmm11

	movdqa	%xmm8,%xmm6
	punpckldq	%xmm9,%xmm8
	movdqa	%xmm10,%xmm7
	punpckldq	%xmm11,%xmm10
	punpckhdq	%xmm9,%xmm6
	punpckhdq	%xmm11,%xmm7
	movdqa	%xmm8,%xmm9
	punpcklqdq	%xmm10,%xmm8
	movdqa	%xmm6,%xmm11
	punpcklqdq	%xmm7,%xmm6
	punpckhqdq	%xmm10,%xmm9
	punpckhqdq	%xmm7,%xmm11
	paddd	128-256(%rcx),%xmm12
	paddd	144-256(%rcx),%xmm13
	paddd	160-256(%rcx),%xmm14
	paddd	176-256(%rcx),%xmm15

	movdqa	%xmm8,0(%rsp)
	movdqa	%xmm9,16(%rsp)
	movdqa	32(%rsp),%xmm8
	movdqa	48(%rsp),%xmm9

	movdqa	%xmm12,%xmm10
	punpckldq	%xmm13,%xmm12
	movdqa	%xmm14,%xmm7
	punpckldq	%xmm15,%xmm14
	punpckhdq	%xmm13,%xmm10
	punpckhdq	%xmm15,%xmm7
	movdqa	%xmm12,%xmm13
	punpcklqdq	%xmm14,%xmm12
	movdqa	%xmm10,%xmm15
	punpcklqdq	%xmm7,%xmm10
	punpckhqdq	%xmm14,%xmm13
	punpckhqdq	%xmm7,%xmm15
	paddd	192-256(%rcx),%xmm4
	paddd	208-256(%rcx),%xmm5
	paddd	224-256(%rcx),%xmm8
	paddd	240-256(%rcx),%xmm9

	movdqa	%xmm6,32(%rsp)
	movdqa	%xmm11,48(%rsp)

	movdqa	%xmm4,%xmm14
	punpckldq	%xmm5,%xmm4
	movdqa	%xmm8,%xmm7
	punpckldq	%xmm9,%xmm8
	punpckhdq	%xmm5,%xmm14
	punpckhdq	%xmm9,%xmm7
	movdqa	%xmm4,%xmm5
	punpcklqdq	%xmm8,%xmm4
	movdqa	%xmm14,%xmm9
	punpcklqdq	%xmm7,%xmm14
	punpckhqdq	%xmm8,%xmm5
	punpckhqdq	%xmm7,%xmm9
	paddd	256-256(%rcx),%xmm0
	paddd	272-256(%rcx),%xmm1
	paddd	288-256(%rcx),%xmm2
	paddd	304-256(%rcx),%xmm3

	movdqa	%xmm0,%xmm8
	punpckldq	%xmm1,%xmm0
	movdqa	%xmm2,%xmm7
	punpckldq	%xmm3,%xmm2
	punpckhdq	%xmm1,%xmm8
	punpckhdq	%xmm3,%xmm7
	movdqa	%xmm0,%xmm1
	punpcklqdq	%xmm2,%xmm0
	movdqa	%xmm8,%xmm3
	punpcklqdq	%xmm7,%xmm8
	punpckhqdq	%xmm2,%xmm1
	punpckhqdq	%xmm7,%xmm3
	cmpq	$256,%rdx
	jb	L$tail4x

	movdqu	0(%rsi),%xmm6
	movdqu	16(%rsi),%xmm11
	movdqu	32(%rsi),%xmm2
	movdqu	48(%rsi),%xmm7
	pxor	0(%rsp),%xmm6
	pxor	%xmm12,%xmm11
	pxor	%xmm4,%xmm2
	pxor	%xmm0,%xmm7

	movdqu	%xmm6,0(%rdi)
	movdqu	64(%rsi),%xmm6
	movdqu	%xmm11,16(%rdi)
	movdqu	80(%rsi),%xmm11
	movdqu	%xmm2,32(%rdi)
	movdqu	96(%rsi),%xmm2
	movdqu	%xmm7,48(%rdi)
	movdqu	112(%rsi),%xmm7
	leaq	128(%rsi),%rsi
	pxor	16(%rsp),%xmm6
	pxor	%xmm13,%xmm11
	pxor	%xmm5,%xmm2
	pxor	%xmm1,%xmm7

	movdqu	%xmm6,64(%rdi)
	movdqu	0(%rsi),%xmm6
	movdqu	%xmm11,80(%rdi)
	movdqu	16(%rsi),%xmm11
	movdqu	%xmm2,96(%rdi)
	movdqu	32(%rsi),%xmm2
	movdqu	%xmm7,112(%rdi)
	leaq	128(%rdi),%rdi
	movdqu	48(%rsi),%xmm7
	pxor	32(%rsp),%xmm6
	pxor	%xmm10,%xmm11
	pxor	%xmm14,%xmm2
	pxor	%xmm8,%xmm7

	movdqu	%xmm6,0(%rdi)
	movdqu	64(%rsi),%xmm6
	movdqu	%xmm11,16(%rdi)
	movdqu	80(%rsi),%xmm11
	movdqu	%xmm2,32(%rdi)
	movdqu	96(%rsi),%xmm2
	movdqu	%xmm7,48(%rdi)
	movdqu	112(%rsi),%xmm7
	leaq	128(%rsi),%rsi
	pxor	48(%rsp),%xmm6
	pxor	%xmm15,%xmm11
	pxor	%xmm9,%xmm2
	pxor	%xmm3,%xmm7
	movdqu	%xmm6,64(%rdi)
	movdqu	%xmm11,80(%rdi)
	movdqu	%xmm2,96(%rdi)
	movdqu	%xmm7,112(%rdi)
	leaq	128(%rdi),%rdi

	subq	$256,%rdx
	jnz	L$oop_outer4x

	jmp	L$done4x

L$tail4x:
	cmpq	$192,%rdx
	jae	L$192_or_more4x
	cmpq	$128,%rdx
	jae	L$128_or_more4x
	cmpq	$64,%rdx
	jae	L$64_or_more4x


	xorq	%r10,%r10

	movdqa	%xmm12,16(%rsp)
	movdqa	%xmm4,32(%rsp)
	movdqa	%xmm0,48(%rsp)
	jmp	L$oop_tail4x

.p2align	5
L$64_or_more4x:
	movdqu	0(%rsi),%xmm6
	movdqu	16(%rsi),%xmm11
	movdqu	32(%rsi),%xmm2
	movdqu	48(%rsi),%xmm7
	pxor	0(%rsp),%xmm6
	pxor	%xmm12,%xmm11
	pxor	%xmm4,%xmm2
	pxor	%xmm0,%xmm7
	movdqu	%xmm6,0(%rdi)
	movdqu	%xmm11,16(%rdi)
	movdqu	%xmm2,32(%rdi)
	movdqu	%xmm7,48(%rdi)
	je	L$done4x

	movdqa	16(%rsp),%xmm6
	leaq	64(%rsi),%rsi
	xorq	%r10,%r10
	movdqa	%xmm6,0(%rsp)
	movdqa	%xmm13,16(%rsp)
	leaq	64(%rdi),%rdi
	movdqa	%xmm5,32(%rsp)
	subq	$64,%rdx
	movdqa	%xmm1,48(%rsp)
	jmp	L$oop_tail4x

.p2align	5
L$128_or_more4x:
	movdqu	0(%rsi),%xmm6
	movdqu	16(%rsi),%xmm11
	movdqu	32(%rsi),%xmm2
	movdqu	48(%rsi),%xmm7
	pxor	0(%rsp),%xmm6
	pxor	%xmm12,%xmm11
	pxor	%xmm4,%xmm2
	pxor	%xmm0,%xmm7

	movdqu	%xmm6,0(%rdi)
	movdqu	64(%rsi),%xmm6
	movdqu	%xmm11,16(%rdi)
	movdqu	80(%rsi),%xmm11
	movdqu	%xmm2,32(%rdi)
	movdqu	96(%rsi),%xmm2
	movdqu	%xmm7,48(%rdi)
	movdqu	112(%rsi),%xmm7
	pxor	16(%rsp),%xmm6
	pxor	%xmm13,%xmm11
	pxor	%xmm5,%xmm2
	pxor	%xmm1,%xmm7
	movdqu	%xmm6,64(%rdi)
	movdqu	%xmm11,80(%rdi)
	movdqu	%xmm2,96(%rdi)
	movdqu	%xmm7,112(%rdi)
	je	L$done4x

	movdqa	32(%rsp),%xmm6
	leaq	128(%rsi),%rsi
	xorq	%r10,%r10
	movdqa	%xmm6,0(%rsp)
	movdqa	%xmm10,16(%rsp)
	leaq	128(%rdi),%rdi
	movdqa	%xmm14,32(%rsp)
	subq	$128,%rdx
	movdqa	%xmm8,48(%rsp)
	jmp	L$oop_tail4x

.p2align	5
L$192_or_more4x:
	movdqu	0(%rsi),%xmm6
	movdqu	16(%rsi),%xmm11
	movdqu	32(%rsi),%xmm2
	movdqu	48(%rsi),%xmm7
	pxor	0(%rsp),%xmm6
	pxor	%xmm12,%xmm11
	pxor	%xmm4,%xmm2
	pxor	%xmm0,%xmm7

	movdqu	%xmm6,0(%rdi)
	movdqu	64(%rsi),%xmm6
	movdqu	%xmm11,16(%rdi)
	movdqu	80(%rsi),%xmm11
	movdqu	%xmm2,32(%rdi)
	movdqu	96(%rsi),%xmm2
	movdqu	%xmm7,48(%rdi)
	movdqu	112(%rsi),%xmm7
	leaq	128(%rsi),%rsi
	pxor	16(%rsp),%xmm6
	pxor	%xmm13,%xmm11
	pxor	%xmm5,%xmm2
	pxor	%xmm1,%xmm7

	movdqu	%xmm6,64(%rdi)
	movdqu	0(%rsi),%xmm6
	movdqu	%xmm11,80(%rdi)
	movdqu	16(%rsi),%xmm11
	movdqu	%xmm2,96(%rdi)
	movdqu	32(%rsi),%xmm2
	movdqu	%xmm7,112(%rdi)
	leaq	128(%rdi),%rdi
	movdqu	48(%rsi),%xmm7
	pxor	32(%rsp),%xmm6
	pxor	%xmm10,%xmm11
	pxor	%xmm14,%xmm2
	pxor	%xmm8,%xmm7
	movdqu	%xmm6,0(%rdi)
	movdqu	%xmm11,16(%rdi)
	movdqu	%xmm2,32(%rdi)
	movdqu	%xmm7,48(%rdi)
	je	L$done4x

	movdqa	48(%rsp),%xmm6
	leaq	64(%rsi),%rsi
	xorq	%r10,%r10
	movdqa	%xmm6,0(%rsp)
	movdqa	%xmm15,16(%rsp)
	leaq	64(%rdi),%rdi
	movdqa	%xmm9,32(%rsp)
	subq	$192,%rdx
	movdqa	%xmm3,48(%rsp)

L$oop_tail4x:
	movzbl	(%rsi,%r10,1),%eax
	movzbl	(%rsp,%r10,1),%ecx
	leaq	1(%r10),%r10
	xorl	%ecx,%eax
	movb	%al,-1(%rdi,%r10,1)
	decq	%rdx
	jnz	L$oop_tail4x

L$done4x:
	leaq	(%r9),%rsp

L$4x_epilogue:
	ret


.global	_chacha20_avx2

.p2align	5
_chacha20_avx2:

L$chacha20_avx2:
	movq	%rsp,%r9

	subq	$0x280+8,%rsp
	andq	$-32,%rsp
	vzeroupper

	vbroadcasti128	L$sigma(%rip),%ymm11
	vbroadcasti128	(%rcx),%ymm3
	vbroadcasti128	16(%rcx),%ymm15
	vbroadcasti128	(%r8),%ymm7
	leaq	256(%rsp),%rcx
	leaq	512(%rsp),%rax
	leaq	L$rot16(%rip),%r10
	leaq	L$rot24(%rip),%r11

	vpshufd	$0x00,%ymm11,%ymm8
	vpshufd	$0x55,%ymm11,%ymm9
	vmovdqa	%ymm8,128-256(%rcx)
	vpshufd	$0xaa,%ymm11,%ymm10
	vmovdqa	%ymm9,160-256(%rcx)
	vpshufd	$0xff,%ymm11,%ymm11
	vmovdqa	%ymm10,192-256(%rcx)
	vmovdqa	%ymm11,224-256(%rcx)

	vpshufd	$0x00,%ymm3,%ymm0
	vpshufd	$0x55,%ymm3,%ymm1
	vmovdqa	%ymm0,256-256(%rcx)
	vpshufd	$0xaa,%ymm3,%ymm2
	vmovdqa	%ymm1,288-256(%rcx)
	vpshufd	$0xff,%ymm3,%ymm3
	vmovdqa	%ymm2,320-256(%rcx)
	vmovdqa	%ymm3,352-256(%rcx)

	vpshufd	$0x00,%ymm15,%ymm12
	vpshufd	$0x55,%ymm15,%ymm13
	vmovdqa	%ymm12,384-512(%rax)
	vpshufd	$0xaa,%ymm15,%ymm14
	vmovdqa	%ymm13,416-512(%rax)
	vpshufd	$0xff,%ymm15,%ymm15
	vmovdqa	%ymm14,448-512(%rax)
	vmovdqa	%ymm15,480-512(%rax)

	vpshufd	$0x00,%ymm7,%ymm4
	vpshufd	$0x55,%ymm7,%ymm5
	vpaddd	L$incy(%rip),%ymm4,%ymm4
	vpshufd	$0xaa,%ymm7,%ymm6
	vmovdqa	%ymm5,544-512(%rax)
	vpshufd	$0xff,%ymm7,%ymm7
	vmovdqa	%ymm6,576-512(%rax)
	vmovdqa	%ymm7,608-512(%rax)

	jmp	L$oop_enter8x

.p2align	5
L$oop_outer8x:
	vmovdqa	128-256(%rcx),%ymm8
	vmovdqa	160-256(%rcx),%ymm9
	vmovdqa	192-256(%rcx),%ymm10
	vmovdqa	224-256(%rcx),%ymm11
	vmovdqa	256-256(%rcx),%ymm0
	vmovdqa	288-256(%rcx),%ymm1
	vmovdqa	320-256(%rcx),%ymm2
	vmovdqa	352-256(%rcx),%ymm3
	vmovdqa	384-512(%rax),%ymm12
	vmovdqa	416-512(%rax),%ymm13
	vmovdqa	448-512(%rax),%ymm14
	vmovdqa	480-512(%rax),%ymm15
	vmovdqa	512-512(%rax),%ymm4
	vmovdqa	544-512(%rax),%ymm5
	vmovdqa	576-512(%rax),%ymm6
	vmovdqa	608-512(%rax),%ymm7
	vpaddd	L$eight(%rip),%ymm4,%ymm4

L$oop_enter8x:
	vmovdqa	%ymm14,64(%rsp)
	vmovdqa	%ymm15,96(%rsp)
	vbroadcasti128	(%r10),%ymm15
	vmovdqa	%ymm4,512-512(%rax)
	movl	$10,%eax
	jmp	L$oop8x

.p2align	5
L$oop8x:
	vpaddd	%ymm0,%ymm8,%ymm8
	vpxor	%ymm4,%ymm8,%ymm4
	vpshufb	%ymm15,%ymm4,%ymm4
	vpaddd	%ymm1,%ymm9,%ymm9
	vpxor	%ymm5,%ymm9,%ymm5
	vpshufb	%ymm15,%ymm5,%ymm5
	vpaddd	%ymm4,%ymm12,%ymm12
	vpxor	%ymm0,%ymm12,%ymm0
	vpslld	$12,%ymm0,%ymm14
	vpsrld	$20,%ymm0,%ymm0
	vpor	%ymm0,%ymm14,%ymm0
	vbroadcasti128	(%r11),%ymm14
	vpaddd	%ymm5,%ymm13,%ymm13
	vpxor	%ymm1,%ymm13,%ymm1
	vpslld	$12,%ymm1,%ymm15
	vpsrld	$20,%ymm1,%ymm1
	vpor	%ymm1,%ymm15,%ymm1
	vpaddd	%ymm0,%ymm8,%ymm8
	vpxor	%ymm4,%ymm8,%ymm4
	vpshufb	%ymm14,%ymm4,%ymm4
	vpaddd	%ymm1,%ymm9,%ymm9
	vpxor	%ymm5,%ymm9,%ymm5
	vpshufb	%ymm14,%ymm5,%ymm5
	vpaddd	%ymm4,%ymm12,%ymm12
	vpxor	%ymm0,%ymm12,%ymm0
	vpslld	$7,%ymm0,%ymm15
	vpsrld	$25,%ymm0,%ymm0
	vpor	%ymm0,%ymm15,%ymm0
	vbroadcasti128	(%r10),%ymm15
	vpaddd	%ymm5,%ymm13,%ymm13
	vpxor	%ymm1,%ymm13,%ymm1
	vpslld	$7,%ymm1,%ymm14
	vpsrld	$25,%ymm1,%ymm1
	vpor	%ymm1,%ymm14,%ymm1
	vmovdqa	%ymm12,0(%rsp)
	vmovdqa	%ymm13,32(%rsp)
	vmovdqa	64(%rsp),%ymm12
	vmovdqa	96(%rsp),%ymm13
	vpaddd	%ymm2,%ymm10,%ymm10
	vpxor	%ymm6,%ymm10,%ymm6
	vpshufb	%ymm15,%ymm6,%ymm6
	vpaddd	%ymm3,%ymm11,%ymm11
	vpxor	%ymm7,%ymm11,%ymm7
	vpshufb	%ymm15,%ymm7,%ymm7
	vpaddd	%ymm6,%ymm12,%ymm12
	vpxor	%ymm2,%ymm12,%ymm2
	vpslld	$12,%ymm2,%ymm14
	vpsrld	$20,%ymm2,%ymm2
	vpor	%ymm2,%ymm14,%ymm2
	vbroadcasti128	(%r11),%ymm14
	vpaddd	%ymm7,%ymm13,%ymm13
	vpxor	%ymm3,%ymm13,%ymm3
	vpslld	$12,%ymm3,%ymm15
	vpsrld	$20,%ymm3,%ymm3
	vpor	%ymm3,%ymm15,%ymm3
	vpaddd	%ymm2,%ymm10,%ymm10
	vpxor	%ymm6,%ymm10,%ymm6
	vpshufb	%ymm14,%ymm6,%ymm6
	vpaddd	%ymm3,%ymm11,%ymm11
	vpxor	%ymm7,%ymm11,%ymm7
	vpshufb	%ymm14,%ymm7,%ymm7
	vpaddd	%ymm6,%ymm12,%ymm12
	vpxor	%ymm2,%ymm12,%ymm2
	vpslld	$7,%ymm2,%ymm15
	vpsrld	$25,%ymm2,%ymm2
	vpor	%ymm2,%ymm15,%ymm2
	vbroadcasti128	(%r10),%ymm15
	vpaddd	%ymm7,%ymm13,%ymm13
	vpxor	%ymm3,%ymm13,%ymm3
	vpslld	$7,%ymm3,%ymm14
	vpsrld	$25,%ymm3,%ymm3
	vpor	%ymm3,%ymm14,%ymm3
	vpaddd	%ymm1,%ymm8,%ymm8
	vpxor	%ymm7,%ymm8,%ymm7
	vpshufb	%ymm15,%ymm7,%ymm7
	vpaddd	%ymm2,%ymm9,%ymm9
	vpxor	%ymm4,%ymm9,%ymm4
	vpshufb	%ymm15,%ymm4,%ymm4
	vpaddd	%ymm7,%ymm12,%ymm12
	vpxor	%ymm1,%ymm12,%ymm1
	vpslld	$12,%ymm1,%ymm14
	vpsrld	$20,%ymm1,%ymm1
	vpor	%ymm1,%ymm14,%ymm1
	vbroadcasti128	(%r11),%ymm14
	vpaddd	%ymm4,%ymm13,%ymm13
	vpxor	%ymm2,%ymm13,%ymm2
	vpslld	$12,%ymm2,%ymm15
	vpsrld	$20,%ymm2,%ymm2
	vpor	%ymm2,%ymm15,%ymm2
	vpaddd	%ymm1,%ymm8,%ymm8
	vpxor	%ymm7,%ymm8,%ymm7
	vpshufb	%ymm14,%ymm7,%ymm7
	vpaddd	%ymm2,%ymm9,%ymm9
	vpxor	%ymm4,%ymm9,%ymm4
	vpshufb	%ymm14,%ymm4,%ymm4
	vpaddd	%ymm7,%ymm12,%ymm12
	vpxor	%ymm1,%ymm12,%ymm1
	vpslld	$7,%ymm1,%ymm15
	vpsrld	$25,%ymm1,%ymm1
	vpor	%ymm1,%ymm15,%ymm1
	vbroadcasti128	(%r10),%ymm15
	vpaddd	%ymm4,%ymm13,%ymm13
	vpxor	%ymm2,%ymm13,%ymm2
	vpslld	$7,%ymm2,%ymm14
	vpsrld	$25,%ymm2,%ymm2
	vpor	%ymm2,%ymm14,%ymm2
	vmovdqa	%ymm12,64(%rsp)
	vmovdqa	%ymm13,96(%rsp)
	vmovdqa	0(%rsp),%ymm12
	vmovdqa	32(%rsp),%ymm13
	vpaddd	%ymm3,%ymm10,%ymm10
	vpxor	%ymm5,%ymm10,%ymm5
	vpshufb	%ymm15,%ymm5,%ymm5
	vpaddd	%ymm0,%ymm11,%ymm11
	vpxor	%ymm6,%ymm11,%ymm6
	vpshufb	%ymm15,%ymm6,%ymm6
	vpaddd	%ymm5,%ymm12,%ymm12
	vpxor	%ymm3,%ymm12,%ymm3
	vpslld	$12,%ymm3,%ymm14
	vpsrld	$20,%ymm3,%ymm3
	vpor	%ymm3,%ymm14,%ymm3
	vbroadcasti128	(%r11),%ymm14
	vpaddd	%ymm6,%ymm13,%ymm13
	vpxor	%ymm0,%ymm13,%ymm0
	vpslld	$12,%ymm0,%ymm15
	vpsrld	$20,%ymm0,%ymm0
	vpor	%ymm0,%ymm15,%ymm0
	vpaddd	%ymm3,%ymm10,%ymm10
	vpxor	%ymm5,%ymm10,%ymm5
	vpshufb	%ymm14,%ymm5,%ymm5
	vpaddd	%ymm0,%ymm11,%ymm11
	vpxor	%ymm6,%ymm11,%ymm6
	vpshufb	%ymm14,%ymm6,%ymm6
	vpaddd	%ymm5,%ymm12,%ymm12
	vpxor	%ymm3,%ymm12,%ymm3
	vpslld	$7,%ymm3,%ymm15
	vpsrld	$25,%ymm3,%ymm3
	vpor	%ymm3,%ymm15,%ymm3
	vbroadcasti128	(%r10),%ymm15
	vpaddd	%ymm6,%ymm13,%ymm13
	vpxor	%ymm0,%ymm13,%ymm0
	vpslld	$7,%ymm0,%ymm14
	vpsrld	$25,%ymm0,%ymm0
	vpor	%ymm0,%ymm14,%ymm0
	decl	%eax
	jnz	L$oop8x

	leaq	512(%rsp),%rax
	vpaddd	128-256(%rcx),%ymm8,%ymm8
	vpaddd	160-256(%rcx),%ymm9,%ymm9
	vpaddd	192-256(%rcx),%ymm10,%ymm10
	vpaddd	224-256(%rcx),%ymm11,%ymm11

	vpunpckldq	%ymm9,%ymm8,%ymm14
	vpunpckldq	%ymm11,%ymm10,%ymm15
	vpunpckhdq	%ymm9,%ymm8,%ymm8
	vpunpckhdq	%ymm11,%ymm10,%ymm10
	vpunpcklqdq	%ymm15,%ymm14,%ymm9
	vpunpckhqdq	%ymm15,%ymm14,%ymm14
	vpunpcklqdq	%ymm10,%ymm8,%ymm11
	vpunpckhqdq	%ymm10,%ymm8,%ymm8
	vpaddd	256-256(%rcx),%ymm0,%ymm0
	vpaddd	288-256(%rcx),%ymm1,%ymm1
	vpaddd	320-256(%rcx),%ymm2,%ymm2
	vpaddd	352-256(%rcx),%ymm3,%ymm3

	vpunpckldq	%ymm1,%ymm0,%ymm10
	vpunpckldq	%ymm3,%ymm2,%ymm15
	vpunpckhdq	%ymm1,%ymm0,%ymm0
	vpunpckhdq	%ymm3,%ymm2,%ymm2
	vpunpcklqdq	%ymm15,%ymm10,%ymm1
	vpunpckhqdq	%ymm15,%ymm10,%ymm10
	vpunpcklqdq	%ymm2,%ymm0,%ymm3
	vpunpckhqdq	%ymm2,%ymm0,%ymm0
	vperm2i128	$0x20,%ymm1,%ymm9,%ymm15
	vperm2i128	$0x31,%ymm1,%ymm9,%ymm1
	vperm2i128	$0x20,%ymm10,%ymm14,%ymm9
	vperm2i128	$0x31,%ymm10,%ymm14,%ymm10
	vperm2i128	$0x20,%ymm3,%ymm11,%ymm14
	vperm2i128	$0x31,%ymm3,%ymm11,%ymm3
	vperm2i128	$0x20,%ymm0,%ymm8,%ymm11
	vperm2i128	$0x31,%ymm0,%ymm8,%ymm0
	vmovdqa	%ymm15,0(%rsp)
	vmovdqa	%ymm9,32(%rsp)
	vmovdqa	64(%rsp),%ymm15
	vmovdqa	96(%rsp),%ymm9

	vpaddd	384-512(%rax),%ymm12,%ymm12
	vpaddd	416-512(%rax),%ymm13,%ymm13
	vpaddd	448-512(%rax),%ymm15,%ymm15
	vpaddd	480-512(%rax),%ymm9,%ymm9

	vpunpckldq	%ymm13,%ymm12,%ymm2
	vpunpckldq	%ymm9,%ymm15,%ymm8
	vpunpckhdq	%ymm13,%ymm12,%ymm12
	vpunpckhdq	%ymm9,%ymm15,%ymm15
	vpunpcklqdq	%ymm8,%ymm2,%ymm13
	vpunpckhqdq	%ymm8,%ymm2,%ymm2
	vpunpcklqdq	%ymm15,%ymm12,%ymm9
	vpunpckhqdq	%ymm15,%ymm12,%ymm12
	vpaddd	512-512(%rax),%ymm4,%ymm4
	vpaddd	544-512(%rax),%ymm5,%ymm5
	vpaddd	576-512(%rax),%ymm6,%ymm6
	vpaddd	608-512(%rax),%ymm7,%ymm7

	vpunpckldq	%ymm5,%ymm4,%ymm15
	vpunpckldq	%ymm7,%ymm6,%ymm8
	vpunpckhdq	%ymm5,%ymm4,%ymm4
	vpunpckhdq	%ymm7,%ymm6,%ymm6
	vpunpcklqdq	%ymm8,%ymm15,%ymm5
	vpunpckhqdq	%ymm8,%ymm15,%ymm15
	vpunpcklqdq	%ymm6,%ymm4,%ymm7
	vpunpckhqdq	%ymm6,%ymm4,%ymm4
	vperm2i128	$0x20,%ymm5,%ymm13,%ymm8
	vperm2i128	$0x31,%ymm5,%ymm13,%ymm5
	vperm2i128	$0x20,%ymm15,%ymm2,%ymm13
	vperm2i128	$0x31,%ymm15,%ymm2,%ymm15
	vperm2i128	$0x20,%ymm7,%ymm9,%ymm2
	vperm2i128	$0x31,%ymm7,%ymm9,%ymm7
	vperm2i128	$0x20,%ymm4,%ymm12,%ymm9
	vperm2i128	$0x31,%ymm4,%ymm12,%ymm4
	vmovdqa	0(%rsp),%ymm6
	vmovdqa	32(%rsp),%ymm12

	cmpq	$512,%rdx
	jb	L$tail8x

	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	leaq	128(%rsi),%rsi
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	leaq	128(%rdi),%rdi

	vpxor	0(%rsi),%ymm12,%ymm12
	vpxor	32(%rsi),%ymm13,%ymm13
	vpxor	64(%rsi),%ymm10,%ymm10
	vpxor	96(%rsi),%ymm15,%ymm15
	leaq	128(%rsi),%rsi
	vmovdqu	%ymm12,0(%rdi)
	vmovdqu	%ymm13,32(%rdi)
	vmovdqu	%ymm10,64(%rdi)
	vmovdqu	%ymm15,96(%rdi)
	leaq	128(%rdi),%rdi

	vpxor	0(%rsi),%ymm14,%ymm14
	vpxor	32(%rsi),%ymm2,%ymm2
	vpxor	64(%rsi),%ymm3,%ymm3
	vpxor	96(%rsi),%ymm7,%ymm7
	leaq	128(%rsi),%rsi
	vmovdqu	%ymm14,0(%rdi)
	vmovdqu	%ymm2,32(%rdi)
	vmovdqu	%ymm3,64(%rdi)
	vmovdqu	%ymm7,96(%rdi)
	leaq	128(%rdi),%rdi

	vpxor	0(%rsi),%ymm11,%ymm11
	vpxor	32(%rsi),%ymm9,%ymm9
	vpxor	64(%rsi),%ymm0,%ymm0
	vpxor	96(%rsi),%ymm4,%ymm4
	leaq	128(%rsi),%rsi
	vmovdqu	%ymm11,0(%rdi)
	vmovdqu	%ymm9,32(%rdi)
	vmovdqu	%ymm0,64(%rdi)
	vmovdqu	%ymm4,96(%rdi)
	leaq	128(%rdi),%rdi

	subq	$512,%rdx
	jnz	L$oop_outer8x

	jmp	L$done8x

L$tail8x:
	cmpq	$448,%rdx
	jae	L$448_or_more8x
	cmpq	$384,%rdx
	jae	L$384_or_more8x
	cmpq	$320,%rdx
	jae	L$320_or_more8x
	cmpq	$256,%rdx
	jae	L$256_or_more8x
	cmpq	$192,%rdx
	jae	L$192_or_more8x
	cmpq	$128,%rdx
	jae	L$128_or_more8x
	cmpq	$64,%rdx
	jae	L$64_or_more8x

	xorq	%r10,%r10
	vmovdqa	%ymm6,0(%rsp)
	vmovdqa	%ymm8,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$64_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	je	L$done8x

	leaq	64(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm1,0(%rsp)
	leaq	64(%rdi),%rdi
	subq	$64,%rdx
	vmovdqa	%ymm5,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$128_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	je	L$done8x

	leaq	128(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm12,0(%rsp)
	leaq	128(%rdi),%rdi
	subq	$128,%rdx
	vmovdqa	%ymm13,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$192_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	vpxor	128(%rsi),%ymm12,%ymm12
	vpxor	160(%rsi),%ymm13,%ymm13
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	vmovdqu	%ymm12,128(%rdi)
	vmovdqu	%ymm13,160(%rdi)
	je	L$done8x

	leaq	192(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm10,0(%rsp)
	leaq	192(%rdi),%rdi
	subq	$192,%rdx
	vmovdqa	%ymm15,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$256_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	vpxor	128(%rsi),%ymm12,%ymm12
	vpxor	160(%rsi),%ymm13,%ymm13
	vpxor	192(%rsi),%ymm10,%ymm10
	vpxor	224(%rsi),%ymm15,%ymm15
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	vmovdqu	%ymm12,128(%rdi)
	vmovdqu	%ymm13,160(%rdi)
	vmovdqu	%ymm10,192(%rdi)
	vmovdqu	%ymm15,224(%rdi)
	je	L$done8x

	leaq	256(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm14,0(%rsp)
	leaq	256(%rdi),%rdi
	subq	$256,%rdx
	vmovdqa	%ymm2,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$320_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	vpxor	128(%rsi),%ymm12,%ymm12
	vpxor	160(%rsi),%ymm13,%ymm13
	vpxor	192(%rsi),%ymm10,%ymm10
	vpxor	224(%rsi),%ymm15,%ymm15
	vpxor	256(%rsi),%ymm14,%ymm14
	vpxor	288(%rsi),%ymm2,%ymm2
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	vmovdqu	%ymm12,128(%rdi)
	vmovdqu	%ymm13,160(%rdi)
	vmovdqu	%ymm10,192(%rdi)
	vmovdqu	%ymm15,224(%rdi)
	vmovdqu	%ymm14,256(%rdi)
	vmovdqu	%ymm2,288(%rdi)
	je	L$done8x

	leaq	320(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm3,0(%rsp)
	leaq	320(%rdi),%rdi
	subq	$320,%rdx
	vmovdqa	%ymm7,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$384_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	vpxor	128(%rsi),%ymm12,%ymm12
	vpxor	160(%rsi),%ymm13,%ymm13
	vpxor	192(%rsi),%ymm10,%ymm10
	vpxor	224(%rsi),%ymm15,%ymm15
	vpxor	256(%rsi),%ymm14,%ymm14
	vpxor	288(%rsi),%ymm2,%ymm2
	vpxor	320(%rsi),%ymm3,%ymm3
	vpxor	352(%rsi),%ymm7,%ymm7
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	vmovdqu	%ymm12,128(%rdi)
	vmovdqu	%ymm13,160(%rdi)
	vmovdqu	%ymm10,192(%rdi)
	vmovdqu	%ymm15,224(%rdi)
	vmovdqu	%ymm14,256(%rdi)
	vmovdqu	%ymm2,288(%rdi)
	vmovdqu	%ymm3,320(%rdi)
	vmovdqu	%ymm7,352(%rdi)
	je	L$done8x

	leaq	384(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm11,0(%rsp)
	leaq	384(%rdi),%rdi
	subq	$384,%rdx
	vmovdqa	%ymm9,32(%rsp)
	jmp	L$oop_tail8x

.p2align	5
L$448_or_more8x:
	vpxor	0(%rsi),%ymm6,%ymm6
	vpxor	32(%rsi),%ymm8,%ymm8
	vpxor	64(%rsi),%ymm1,%ymm1
	vpxor	96(%rsi),%ymm5,%ymm5
	vpxor	128(%rsi),%ymm12,%ymm12
	vpxor	160(%rsi),%ymm13,%ymm13
	vpxor	192(%rsi),%ymm10,%ymm10
	vpxor	224(%rsi),%ymm15,%ymm15
	vpxor	256(%rsi),%ymm14,%ymm14
	vpxor	288(%rsi),%ymm2,%ymm2
	vpxor	320(%rsi),%ymm3,%ymm3
	vpxor	352(%rsi),%ymm7,%ymm7
	vpxor	384(%rsi),%ymm11,%ymm11
	vpxor	416(%rsi),%ymm9,%ymm9
	vmovdqu	%ymm6,0(%rdi)
	vmovdqu	%ymm8,32(%rdi)
	vmovdqu	%ymm1,64(%rdi)
	vmovdqu	%ymm5,96(%rdi)
	vmovdqu	%ymm12,128(%rdi)
	vmovdqu	%ymm13,160(%rdi)
	vmovdqu	%ymm10,192(%rdi)
	vmovdqu	%ymm15,224(%rdi)
	vmovdqu	%ymm14,256(%rdi)
	vmovdqu	%ymm2,288(%rdi)
	vmovdqu	%ymm3,320(%rdi)
	vmovdqu	%ymm7,352(%rdi)
	vmovdqu	%ymm11,384(%rdi)
	vmovdqu	%ymm9,416(%rdi)
	je	L$done8x

	leaq	448(%rsi),%rsi
	xorq	%r10,%r10
	vmovdqa	%ymm0,0(%rsp)
	leaq	448(%rdi),%rdi
	subq	$448,%rdx
	vmovdqa	%ymm4,32(%rsp)

L$oop_tail8x:
	movzbl	(%rsi,%r10,1),%eax
	movzbl	(%rsp,%r10,1),%ecx
	leaq	1(%r10),%r10
	xorl	%ecx,%eax
	movb	%al,-1(%rdi,%r10,1)
	decq	%rdx
	jnz	L$oop_tail8x

L$done8x:
	vzeroall
	leaq	(%r9),%rsp

L$8x_epilogue:
	ret


