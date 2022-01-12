#define MOV(A, B) % rdi, % rax
#define RET ret

#if defined __WIN32

#elsif defined __APPLE__

#endif

#if defined __APPLE__
#define GLOBAL_C(X) .globl _##X
#define ENTRY_C(X) _##X:
#else
#define GLOBAL_C(X) .globl X
#define ENTRY_C(X)                                                                                 \
    X:
#endif

#if defined __aarch64__
#define MOVQ    mov
#define MOVL    mov
#else
#define MOVQ    movq
#define MOVL    movl
#endif