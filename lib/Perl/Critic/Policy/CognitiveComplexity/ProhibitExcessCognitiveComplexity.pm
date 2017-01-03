package Perl::Critic::Policy::CognitiveComplexity::ProhibitExcessCognitiveComplexity;
use strict;
use warnings;

use Readonly;
use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';

our $VERSION = '0.01';

Readonly::Scalar my $EXPL => q{Avoid code that is nested, and thus difficult to grasp.};

sub supported_parameters {
    return ( {
            name            => 'warn_level',
            description     => 'The complexity score allowed before warning starts.',
            default_string  => '10',
            behavior        => 'integer',
            integer_minimum => 1,
        },
        {
            name            => 'info_level',
            description     => 'The complexity score allowed before informational reporting starts.',
            default_string  => '1',
            behavior        => 'integer',
            integer_minimum => 1,
        }
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

    # only report complexity for named subs.
    my $name = $elem->name() or return;

    # start with complexity of 0
    my $score = $self->nested_complexity( $elem->find_first('PPI::Structure::Block'), 0);

    return if($score < $self->{'_info_level'});
    return ($self->new_violation($elem, $score));
}

sub new_violation {
    my $self = shift;
    my ($elem, $score) = @_;
    my $name = $elem->name();
    my $desc = qq<Subroutine '$name' with complexity score of '$score'>;

    return Perl::Critic::Violation->new( $desc, $EXPL, $elem,
        ($score >= $self->{'_warn_level'} ? $self->get_severity() : $SEVERITY_LOWEST ));
}

sub nested_complexity {
    my $self = shift;
    my ( $elem, $nesting ) = @_;

    return 0 unless ( $elem->can('schildren') );

    my $complexity = 0;

    for my $child ( $elem->schildren() ) {
        #my $inc = 0;
        if (   $child->isa('PPI::Statement::Given')
            || $child->isa('PPI::Statement::Compound'))
        {
            $complexity += $nesting + 1; # aniticipate nesting increment
        }
        # 'return' is a break-statement, but does not count in terms of cognitive complexity.
        elsif ( $child->isa('PPI::Statement::Break') && ! $self->is_return_statement($child)) {
            $complexity++;
        }
        $complexity += $self->nested_complexity( $child, $nesting + $self->nesting_increase($child) );
    }
    return $complexity;
}

sub is_return_statement {
    my $self = shift;
    my ($child) = @_;
    scalar $child->find( sub { $_[1]->content eq 'return' });
}

sub nesting_increase {
    my $self = shift;
    my ($child) = @_;

    # if/when/for...
    return 1 if ($child->isa('PPI::Statement::Compound'));
    # anonymous sub
    return 1 if ($child->isa('PPI::Statement') && $child->find( sub { $_[1]->content eq 'sub' }));

    return 0;
}

1;
