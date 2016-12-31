package Perl::Critic::Policy::Subroutines::ProhibitExcessCognitiveComplexity;
use strict;
use warnings;

use Readonly;
use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

our $VERSION = '0.1';

Readonly::Scalar my $DESC => q{Avoid excessive cognitive complexity};
Readonly::Scalar my $EXPL =>
q{See https://blog.sonarsource.com/cognitive-complexity-because-testability-understandability/};

sub supported_parameters {
    return ();
}

sub default_severity {
    return $SEVERITY_MEDIUM;
}

sub default_themes {
    return qw( complexity maintenance );
}

sub applies_to { 
    return 'PPI::Statement::Sub';
}

sub violates {
    my ( $self, $elem, undef ) = @_;
    return;
}

1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::Subroutines::ProhibitExcessCognitiveComplexity - Minimize cognitive complexity by factoring code into smaller subroutines.

=head1 AUTHOR

Oliver Trosien <mailacc.67890+cpan@gmail.com>

=cut