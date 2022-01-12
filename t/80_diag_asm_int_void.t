use strict;
use Test::More 0.98;
for (
    'rm blank.c',
    'touch blank.c',
    'echo "int return_int( ) { return 1; }" >> blank.c',
    'gcc -S blank.c',
) {
    system($_);
}
diag `cat blank.s`;
pass 'diag only';
done_testing;
