#include "asm.h"

	.file	"hello.c"
	.text
	GLOBAL_C(return_one)

ENTRY_C(return_one)
#if defined __WIN32 || defined __APPLE__
#else
	.type	return_one, @function
#endif
.LFB0:
	pushq	%rbp
	MOVQ	%rsp, %rbp
	MOVL	$1, %eax
	popq	%rbp
	RET
