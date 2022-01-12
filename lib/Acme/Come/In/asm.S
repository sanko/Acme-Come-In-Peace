#include "asm.h"

	.file	"hello.c"
	.text
	GLOBAL_C(return_one)

ENTRY_C(return_one)
#if defined __WIN32 || defined __APPLE__
#elif defined _ARCH
	//.type	return_one, %function
#else
    //.type	return_one, @function
#endif
.LFB0:

#if defined __aarch64__ || defined _M_ARM64
#warning "__aarch64__"
 	stp	x29, x30, [sp, -32]!
 	mov	x29, sp
 	str	x0, [sp, 24]
 	str	w1, [sp, 20]
 	str	w2, [sp, 16]
 	ldr	x2, [sp, 24]
 	ldr	w1, [sp, 16]
 	ldr	w0, [sp, 20]
 	blr	x2
 	ldp	x29, x30, [sp], 32
    RET
#elif defined __ARM_ARCH_6__ \
    || defined __ARM_ARCH_6J__ \
    || defined __ARM_ARCH_6K__ \
    || defined __ARM_ARCH_6Z__ \
    || defined __ARM_ARCH_6ZK__ \
    || defined __ARM_ARCH_6T2__ \
    || defined __ARMV6__
#warning "__ARMV6__"
 	push	{fp, lr}
 	add	fp, sp, #4
 	sub	sp, sp, #16
 	str	r0, [fp, #-8]
 	str	r1, [fp, #-12]
 	str	r2, [fp, #-16]
 	ldr	r3, [fp, #-8]
 	ldr	r1, [fp, #-16]
 	ldr	r0, [fp, #-12]
 	blx	r3
 	mov	r3, r0
 	mov	r0, r3
 	sub	sp, fp, #4
 	@ sp needed
 	pop	{fp, pc}
#elif  defined __ARM_ARCH_7__ \
    || defined __ARM_ARCH_7A__ \
    || defined __ARM_ARCH_7R__ \
    || defined __ARM_ARCH_7M__ \
    || defined __ARM_ARCH_7S__ \
    || defined __ARM_ARCH_7K__ \
    || defined __arm__
#warning "__ARM_ARCH_7__"
 	push	{r7, lr}
 	sub	sp, sp, #16
 	add	r7, sp, #0
 	str	r0, [r7, #12]
 	str	r1, [r7, #8]
 	str	r2, [r7, #4]
 	ldr	r3, [r7, #12]
 	ldr	r1, [r7, #4]
 	ldr	r0, [r7, #8]
 	blx	r3
 	mov	r3, r0
 	mov	r0, r3
 	adds	r7, r7, #16
 	mov	sp, r7
 	@ sp needed
 	pop	{r7, pc}
#elif defined(__s390x__)
#warning "__s390x__"
 	stmg	%r11,%r15,88(%r15)
 	lay	%r15,-176(%r15)
 	lgr	%r11,%r15
 	stg	%r2,168(%r11)
 	lgr	%r1,%r3
 	lgr	%r2,%r4
 	st	%r1,164(%r11)
 	lr	%r1,%r2
 	st	%r1,160(%r11)
 	lgf	%r3,160(%r11)
 	lgf	%r2,164(%r11)
 	lg	%r1,168(%r11)
 	basr	%r14,%r1
 	lgr	%r1,%r2
 	lgfr	%r1,%r1
 	lgr	%r2,%r1
 	lmg	%r11,%r15,264(%r11)
 	br	%r14
#elif  defined(__ppc64__)     \
    || defined(__PPC64__)      \
    || defined(__ppc64le__)    \
    || defined(__PPC64LE__)
/* CPU(PPC64) - PowerPC 64-bit Little Endian */
#warning "__ppc64__"
 //0:	addis 2,12,.TOC.-.LCF0@ha
 	//addi 2,2,.TOC.-.LCF0@l
 	mflr 0
 	std 0,16(1)
 	std 31,-8(1)
 	stdu 1,-64(1)
 	mr 31,1
 	std 2,24(1)
 	std 3,40(31)
 	mr 10,4
 	mr 9,5
 	mtvsrwz 0,10
 	addi 10,31,36
 	stfiwx 0,0,10
 	mtvsrwz 0,9
 	addi 9,31,32
 	stfiwx 0,0,9
 	lwa 8,32(31)
 	lwa 10,36(31)
 	ld 9,40(31)
 	mr 4,8
 	mr 3,10
 	mr 12,9
 	mtctr 12
 	bctrl
 	ld 2,24(1)
 	mr 9,3
 	mr 3,9
 	addi 1,31,64
 	ld 0,16(1)
 	mtlr 0
 	ld 31,-8(1)
 	blr
#elif  defined(__WIN32)
 	pushq	%rbp
 	movq	%rsp, %rbp
 	subq	$32, %rsp
 	movq	%rcx, 16(%rbp)
 	movl	%edx, 24(%rbp)
 	movl	%r8d, 32(%rbp)
 	movl	32(%rbp), %edx
 	movl	24(%rbp), %ecx
 	movq	16(%rbp), %rax
 	call	*%rax
 	addq	$32, %rsp
 	popq	%rbp
 	ret
#else
#warning "Fallback!"
 	pushq	%rbp
 	MOVQ	%rsp, %rbp
 	subq	$16, %rsp
 	MOVQ	%rdi, -8(%rbp)
 	MOVL	%esi, -12(%rbp)
 	MOVL	%edx, -16(%rbp)
 	MOVL	-16(%rbp), %edx
 	MOVL	-12(%rbp), %eax
 	MOVQ	-8(%rbp), %rcx
 	MOVL	%edx, %esi
 	MOVL	%eax, %edi
 	call	*%rcx
 	leave
 	RET
#endif