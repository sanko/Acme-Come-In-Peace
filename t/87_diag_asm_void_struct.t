use strict;
use Test::More 0.98;
for (
    'rm blank.c',
    'touch blank.c',
    'echo "typedef struct { char alpha; } I; void return_void( I in ) { char a = in.alpha; return; } int main( ) { I out = { \'b\'}; return_void(out); }" >> blank.c',
    'gcc -S blank.c',
) {
    system($_);
}
diag `cat blank.s`;
pass 'diag only';
done_testing;
