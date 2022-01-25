use strict;
use Test::More;
use Perl::Critic::TestUtils qw( pcritique );

my $policy = 'Perl::Critic::Policy::CognitiveComplexity::ProhibitExcessCognitiveComplexity';

my $code_sub_declaration_without_body = <<'END_CODE';
sub some_sub ($);
END_CODE
ok( _ensure_no_error($code_sub_declaration_without_body), "Should not fail on sub declaration without body" );

my $code_signature_sub_call = <<'END_CODE';
use feature qw(signatures);
sub my_sub () {}
sub call_in_default_arg ($arg = my_sub()) {}
END_CODE
ok( _ensure_no_error($code_signature_sub_call), "Should not fail on function call in sub signatures" );

sub _ensure_no_error {
    my $code = shift;
    return eval {
        pcritique( $policy, \$code );
        1;
    };
}

done_testing();
