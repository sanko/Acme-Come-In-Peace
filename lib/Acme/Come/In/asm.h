#define MOV(A, B) % rdi, % rax
#define RET ret

#if defined __WIN32

#elsif defined __APPLE__

#endif

#if defined(__alpha__)
/* CPU(ALPHA) - DEC Alpha */
#define CPU_ALPHA 1
#elsif defined(__hppa__) || defined(__hppa64__)
/* CPU(HPPA) - HP PA-RISC */
#define CPU_HPPA 1
#define CPU_BIG_ENDIAN 1
/* CPU(IA64) - Itanium / IA-64 */
#if defined(__ia64__)
#define CPU_IA64 1
/* 32-bit mode on Itanium */
#if !defined(__LP64__)
#define CPU_IA64_32 1
#endif
#endif
#endif

#if defined __APPLE__
#define GLOBAL_C(X) .globl _##X
#define ENTRY_C(X) _##X:
#else
#define GLOBAL_C(X) .globl X
#define ENTRY_C(X)                                                                                 \
    X:
#endif

#if defined __aarch64__ || defined _M_ARM64
// ARM64
// https://pkg.go.dev/cmd/internal/obj/ppc64
#define MOVQ(X, Y) mov X, Y
#define MOVL(X, Y) mov X, Y
#else
#define MOVQ(X, Y) movq X, Y
#define MOVL(X, Y) movl X, Y
#endif

/*

hello.c:10: Error: unrecognized symbol type ""
hello.c:13: Error: bad instruction `pushq %rbp'
hello.c:14: Error: bad instruction `movq %rsp,%rbp'
hello.c:15: Error: bad instruction `movl $1,%eax'
hello.c:16: Error: bad instruction `popq %rbp'
hello.c:17: Error: bad instruction `ret'

*/
