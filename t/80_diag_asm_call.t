use strict;
use Test::More 0.98;
use warnings;
my $filename = 'temp.c';
open( my $fh, '>', $filename ) or die "Could not open file '$filename' $!";
print $fh <<'END'; close $fh; `gcc -S $filename`; diag `cat temp.s`;
extern int sum (int num1, int num2);

int test( int (*in)(int, int), int a, int b ) {
    return in( a, b );
}
int main() {
    int (*f2p) (int, int);
    f2p = sum;
    //Calling function using function pointer
    //int op1 = f2p(10, 13);

    //Calling function in normal way using function name
    //int op2 = sum(10, 13);

    test(f2p, 100, 200);

    return 0;
}
END
pass 'diag only';
done_testing;
