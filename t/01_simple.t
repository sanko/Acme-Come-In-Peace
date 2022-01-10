use strict;
use Test::More;
use Acme::Come::In::Peace;
is( Acme::Come::In::Peace::hello(),     'Hello, world!' );
is( Acme::Come::In::Peace::add( 2, 3 ), 5 );
done_testing;
