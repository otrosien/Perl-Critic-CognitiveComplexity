use strict;
use Test::More 0.98;

use_ok $_ for qw(
    Perl::Critic::CognitiveComplexity
    Perl::Critic::Policy::CognitiveComplexity::ProhibitExcessCognitiveComplexity
);

done_testing;

