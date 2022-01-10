#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT /* we want efficiency */
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifdef __cplusplus
} /* extern "C" */
#endif

#define NEED_newSVpvn_flags
#include "ppport.h"

MODULE = Acme::Come::In::Peace    PACKAGE = Acme::Come::In::Peace

PROTOTYPES: DISABLE

void
hello()
CODE:
{
    ST(0) = newSVpvs_flags("Hello, world!", SVs_TEMP);
}

int
add(int val1, int val2)
CODE:
    int add, sub, mul;
    asm( "addl  %%ebx, %%eax;" : "=a" (add) : "a" (val1) , "b" (val2) );
    asm( "subl  %%ebx, %%eax;" : "=a" (sub) : "a" (val1) , "b" (val2) );
    asm( "imull %%ebx, %%eax;" : "=a" (mul) : "a" (val1) , "b" (val2) );
    printf( "%d + %d = %d\r\n", val1, val2, add );
    printf( "%d - %d = %d\r\n", val1, val2, sub );
    printf( "%d * %d = %d\r\n", val1, val2, mul );
    RETVAL = add;
OUTPUT:
    RETVAL
