use strict;
use Test::More;
use Perl::Critic::TestUtils qw( pcritique pcritique_with_violations );
use Perl::Critic::Utils qw{ :severities };

my $policy = 'Perl::Critic::Policy::CognitiveComplexity::ProhibitExcessCognitiveComplexity';

### simple check

my $code = <<'END_CODE';
sub a { }
END_CODE
my $violation_count = pcritique( $policy, \$code );
is( $violation_count, 0, 'No violation' );

### example 1
$code = <<'END_CODE';
use experimental qw(switch);
                                # Cyclomatic Complexity    Cognitive Complexity

sub getWords {                  #          +1
    my ($number) = @_;
    given ($number) {           #                                  +1
      when (1)                  #          +1
        { return "one"; }
      when (2)                  #          +1
        { return "a couple"; }
      default                   #          +1
        { return "lots"; }
    }
}                               #          =4                      =1
END_CODE
my @violations = pcritique_with_violations( $policy, \$code );
is(scalar @violations, 1, 'Found 1 violation');

my $violation = $violations[0];
is($violation->severity(), $SEVERITY_LOWEST, 'getWords: Violation is info-level');
is($violation->description(), 'Subroutine "getWords" with high complexity score (1)', 'getWords: Violation description');

### example 2
$code = <<'END_CODE';

sub sumOfPrimes {
    my ($max) = @_;
    my $total = 0;
    OUT: for (my $i = 1; $i <= $max; ++$i) {
        for (my $j = 2; $j < $i; ++$j) {
            if ($i % $j == 0) {
                 last OUT;
            }
        }
        $total += $i;
    }
    return $total;
}

END_CODE
my @violations = pcritique_with_violations( $policy, \$code );
is(scalar @violations, 1, 'Found 1 violation');

my $violation = $violations[0];
is($violation->severity(), $SEVERITY_LOWEST, 'sumOfPrimes: Violation is info-level');
is($violation->description(), 'Subroutine "sumOfPrimes" with high complexity score (7)', 'sumOfPrimes: Violation description');

done_testing();
