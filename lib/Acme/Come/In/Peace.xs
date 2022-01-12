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

// Platform defines
#if defined(WIN64) || defined(_WIN64) || defined(__WIN64__)
#  define OS_Win64
#elif defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__) || defined(__WINDOWS__) || defined(_WINDOWS)
#  define OS_Win32
#elif defined(__APPLE__) || defined(__Darwin__)
#  define OS_Darwin
#  if defined(__ENVIRONMENT_IPHONE_OS_VERSION_MIN_REQUIRED__)
#    define OS_IOS
#  else /* defined(__ENVIRONMENT_MAC_OS_X_VERSION_MIN_REQUIRED__) */
#    define OS_MacOSX
#  endif
#elif defined(__linux__) || defined(__linux) || defined(__gnu_linux__)
#  define OS_Linux
#elif defined(__FreeBSD__) || defined(__FreeBSD_kernel__) /* latter is (also) used by systems using FreeBSD kernel, e.g. Debian/kFreeBSD, which could be detected specifically by also checking for __GLIBC__ */
#  define OS_FreeBSD
#elif defined(__OpenBSD__)
#  define OS_OpenBSD
#elif defined(__NetBSD__)
#  define OS_NetBSD
#elif defined(__DragonFly__)
#  define OS_DragonFlyBSD
#elif defined(__sun__) || defined(__sun) || defined(sun)
#  define OS_SunOS
#elif defined(__CYGWIN__)
#  define OS_Cygwin
#elif defined(__MINGW__)
#  define OS_MinGW
#elif defined(__nds__)
#  define OS_NDS
#elif defined(__psp__) || defined(PSP)
#  define OS_PSP
#elif defined(__HAIKU__) || defined(__BEOS__)
#  define OS_BeOS
#elif defined(Plan9) || defined(__Plan9__)
#  define OS_Plan9
#elif defined(__vms)
#  define OS_VMS
#elif defined(__minix)
#  define OS_Minix
#else
#  define OS_Unknown
#endif

/** Platforms. */

#if defined(__ANDROID__)
#  define OS_Android
#endif

#if defined(OS_Win32) || defined(OS_Win64)
#define OSFAMILY_Windows
#elif defined(OS_NDS) || defined(OS_PSP)
#define OSFAMILY_GameConsole
#else
#define OSFAMILY_Unix
#endif


#if defined(OS_Win32) || defined(OS_Win64) || defined(OS_Cygwin) || defined(OS_MinGW)
#define ABI_PE
#elif defined(OS_Darwin)
#define ABI_Mach
#elif !defined(OS_Minix) || defined(__ELF__) /* Minix >= 3.2 (2012) uses ELF */
#define ABI_ELF
# if defined(__LP64__) || defined(_LP64)
#   define ABI_ELF64
# else
#   define ABI_ELF32
# endif
#else
#define ABI_Unknown
#endif

/* Compiler specific defines. Do not change the order, because  */
/* some of the compilers define flags for compatible ones, too. */

#if defined(__INTEL_COMPILER)
#define CC_INTEL
#elif defined(_MSC_VER)
#define CC_MSVC
#elif defined(__clang__) || defined(__llvm__)
#define CC_CLANG
#elif defined(__GNUC__)
#define CC_GNU
#elif defined(__WATCOMC__)
#define CC_WATCOM
#elif defined(__PCC__)
#define CC_PCC
#elif defined(__SUNPRO_C)
#define CC_SUN
#endif


/* Check architecture. */
#if defined(_M_X64_) || defined(_M_AMD64) || defined(__amd64__) || defined(__amd64) || defined(__x86_64__) || defined(__x86_64)
# define ARCH_X64
#elif defined(_M_IX86) || defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__) || defined(__386__) || defined(__i386)
# define ARCH_X86
#elif defined(_M_IA64) || defined(__ia64__)
# define ARCH_IA64
#elif defined(_M_PPC) || defined(__powerpc__) || defined(__powerpc) || defined(__POWERPC__) || defined(__ppc__) || defined(__power__)
# if defined(__ppc64__) || defined(_ARCH_PPC64) || defined(__power64__) || defined(__powerpc64__)
#   define ARCH_PPC64
# else
#   define ARCH_PPC
# endif
#elif defined(__mips64__) || defined(__mips64)
# define ARCH_MIPS64
#elif defined(_M_MRX000) || defined(__mips__) || defined(__mips) || defined(_mips)
# define ARCH_MIPS
#elif defined(__arm__)
# define ARCH_ARM
# if defined(__thumb__)
#   define ARCH_THUMB
# endif
#elif defined(_M_ARM64) || defined(__aarch64__) || defined(__arm64) || defined(__arm64__)
# define ARCH_ARM64
#elif defined(__sh__)
# define ARCH_SH
#elif defined(__sparc) || defined(__sparc__)
# if defined(__sparcv9) || defined(__sparc_v9__) || defined(__sparc64__) || defined(__arch64__)
#  define ARCH_SPARC64
# else
#  define ARCH_SPARC
# endif
#endif

struct t {
    int a, b, c, d;    // a is at offset 0, b at 4, c at 8, d at 0ch
    char e;            // e is at 10h
    short f;           // f is at 12h (naturally aligned)
    long g;            // g is at 14h
    char h;            // h is at 18h
    long i;            // i is at 1ch (naturally aligned)
};

int /*__attribute__((cdecl))*/ foo(struct t a) { return 1; }

void _cdecl_foo() {
    struct t s = {0, -1, 2, -3, -4, 5, -6, 7, -8};
    foo(s);
}

void _cdecl_foo_asm() {
    struct t s = {0, -1, 2, -3, -4, 5, -6, 7, -8};
    //asm( "push DWORD 0fffffff8h" );
    //asm( "call foo");
    //asm( "add esp, 20h");

//push DWORD 0fffffff8h    ; i (-8)
//push DWORD 0badbad07h    ; h (7), pushed as DWORD to naturally align i, upper bytes can be garbage
//push DWORD 0fffffffah    ; g (-6)
//push WORD 5              ; f (5)
//push WORD 033fch         ; e (-4), pushed as WORD to naturally align f, upper byte can be garbage
//push DWORD 0fffffffdh    ; d (-3)
//push DWORD 2             ; c (2)
//push DWORD 0ffffffffh    ; b (-1)
//push DWORD 0             ; a (0)
//call foo
//add esp, 20h
}

int _add(int a, int b) { return a + b; }
int return_one( int (*in)(int, int), int, int );

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
    /*asm( "addl  %%ebx, %%eax;" : "=a" (add) : "a" (val1) , "b" (val2) );
    asm( "subl  %%ebx, %%eax;" : "=a" (sub) : "a" (val1) , "b" (val2) );
    asm( "imull %%ebx, %%eax;" : "=a" (mul) : "a" (val1) , "b" (val2) );
    printf( "%d + %d = %d\r\n", val1, val2, add );
    printf( "%d - %d = %d\r\n", val1, val2, sub );
    printf( "%d * %d = %d\r\n", val1, val2, mul );*/
    RETVAL = return_one(_add, val1, val2);
OUTPUT:
    RETVAL
