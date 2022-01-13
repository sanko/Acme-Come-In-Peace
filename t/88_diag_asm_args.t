use strict;
use Test::More 0.98;
use warnings;
my $filename = 'temp.c';
open( my $fh, '>', $filename ) or die "Could not open file '$filename' $!";
print $fh <<'END'; close $fh; `gcc -S -masm=intel -fverbose-asm $filename`; diag `cat temp.s`;
int sum ( int i, ... ) {

};

struct fun { char alpha; };

int main() {
    int i = 199;
    struct fun blah = { 'z' };
    int _sum199 = sum( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, i, i, i, i, i, 1000000, blah, 5000, blah );


    int _sum7x = sum( 56, blah, 3, 2,  32, 321, 11 );
    int _sum7 = sum( 56, 33, 3, 2,  32, 321, 11 );
    int _sum6 = sum( 56, 33, 3, 2,  32, 321 );
    int _sum5 = sum( 56, 33, 7, 23, 32 );
    int _sum4 = sum( 56, 33, 4, 5 );
    int _sum3 = sum( 56, 33, 2 );
    int _sum2 = sum( 56, 33 );
    int _sum1 = sum( 65 );
}


END
pass 'diag only';
done_testing;
