use strict;
use Test::More;
use Perl::Critic::TestUtils qw( pcritique pcritique_with_violations );

my $policy = 'Perl::Critic::Policy::Subroutines::ProhibitExcessCognitiveComplexity';

### simple check

my $code = <<'END_CODE';
sub a { }
END_CODE
my $violation_count = pcritique( $policy, \$code );
is($violation_count, 0, 'No violation');


### example 1
$code = <<'END_CODE';
use feature 'switch';
                                # Cyclomatic Complexity    Cognitive Complexity
  sub getWords { #             +1
    my ($number) = @_;
    given ($number) {           #                                  +1
      when 1:                   #          +1
        { return "one"; }
      when 2:                   #          +1
        { return "a couple"; }
      default:                  #          +1
        { return "lots"; }
    }
  }                             #          =4                      =1

END_CODE
my $aViolations = pcritique_with_violations( $policy, \$code );
# WIP
# is(scalar $aViolations, 1, 'Info-level violation');


done_testing();