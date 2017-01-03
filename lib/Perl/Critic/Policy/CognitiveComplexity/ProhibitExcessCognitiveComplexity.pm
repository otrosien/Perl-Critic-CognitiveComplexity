package Perl::Critic::Policy::CognitiveComplexity::ProhibitExcessCognitiveComplexity;
use strict;
use warnings;

use Readonly;
use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

our $VERSION = '0.1';

Readonly::Scalar my $DESC => q{Avoid excessive cognitive complexity};
Readonly::Scalar my $EXPL => q{See https://blog.sonarsource.com/cognitive-complexity-because-testability-understandability/};

sub supported_parameters {
    return ( {
            name            => 'warn_level',
            description     => 'The complexity score allowed before warning starts.',
            default_string  => '10',
            behavior        => 'integer',
            integer_minimum => 1,
        },
    );
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

    my @viols = ();

    # minimum complexity is 0
    my $score = $self->nested_complexity( $elem->find_first('PPI::Structure::Block'), 0);

    if ( $score > 0 ) {
        my $desc;
        if ( my $name = $elem->name() ) {
            $desc = qq<Subroutine "$name" with high complexity score ($score)>;
        }
        else {
            $desc = qq<Anonymous subroutine with high complexity score ($score)>;
        }

        push @viols, Perl::Critic::Violation->new( $desc, $EXPL, $elem, ( $score >= $self->{'_warn_level'} ? $self->get_severity() : $SEVERITY_LOWEST ) );
    }

    return @viols;
}

sub nested_complexity {
    my $self = shift;
    my ( $elem, $nesting ) = @_;

    return 0 unless ( $elem->can('schildren') );

    my $complexity = 0;

    for my $child ( $elem->schildren() ) {
        #my $inc = 0;
        if (   $child->isa('PPI::Structure::Given')
            || $child->isa('PPI::Structure::For')
            || $child->isa('PPI::Structure::Condition') )
        {
            $complexity += $nesting + 1; # aniticipate nesting increment
        }
        elsif ( $child->isa('PPI::Statement::Break') && ! scalar $child->find( sub { $_[1]->content eq 'return' }) ) {
            $complexity++;
        }
        $complexity += $self->nested_complexity( $child, $nesting + $child->isa('PPI::Statement::Compound') ? 1 : 0 );
    }
    return $complexity;
}

1;
