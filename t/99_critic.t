use strict;
use warnings;
use File::Spec;
use Test::More;
use Test::Perl::Critic (-profile => File::Spec->catfile('..','..','.perlcriticrc'));

if ( not $ENV{TEST_AUTHOR} ) {
    my $msg = 'Author test.  Set $ENV{TEST_AUTHOR} to a true value to run.'; ## no critic(RequireInterpolationOfMetachars)
    plan( skip_all => $msg );
}

all_critic_ok( 'lib', 't' );
