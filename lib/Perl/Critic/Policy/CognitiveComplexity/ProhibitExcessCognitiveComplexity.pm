package Perl::Critic::Policy::CognitiveComplexity::ProhibitExcessCognitiveComplexity;
use strict;
use warnings;

use Readonly;
use Readonly qw (Scalar);
use Perl::Critic::Utils qw{ :severities :classification :ppi };
use Perl::Critic::Violation;
use base 'Perl::Critic::Policy';

our $VERSION = '0.02';

Scalar my $EXPL => q{Avoid code that is nested, and thus difficult to grasp.};
Readonly my %BOOLEAN_OPS => map { $_ => 1 } qw( && || and or );

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
    my $score = 0;
    my $block = $elem->find_first('PPI::Structure::Block');

    $score += $self->structure_score($block , 0);
    $score += $self->operator_score($block);

    # return no violation
    return if($score < $self->{'_info_level'});
    # return violation
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

sub structure_score {
    my $self = shift;
    my ( $elem, $nesting ) = @_;

    return 0 unless ( $elem->can('schildren') );

    my $complexity = 0;

    for my $child ( $elem->schildren() ) {
        #my $inc = 0;
        if (   $child->isa('PPI::Structure::Given')
            || $child->isa('PPI::Structure::Condition')
            || $child->isa('PPI::Structure::For')
            )
        {
            if($self->nesting_increase($child->parent)) {
                $complexity += $nesting;
            } else {
                # missing compound statement / increment on postfix operator_score
                $complexity += $nesting + 1;
            }
        }
        # 'return' is a break-statement, but does not count in terms of cognitive complexity.
        elsif ( $child->isa('PPI::Statement::Break') && ! $self->is_return_statement($child)) {
            $complexity++;
        }
        $complexity += $self->structure_score( $child, $nesting + $self->nesting_increase($child) );
    }
    return $complexity;
}

sub operator_score {
    my $self = shift;
    my ($sub) = @_;
    my $by_parent = {};
    my $elems = $sub->find('PPI::Token::Operator');
    my $sum = 0;
    if($elems) {
        map { push @{$by_parent->{$_->parent}}, $_->content }
            grep { exists $BOOLEAN_OPS{$_->content} } @$elems;
        for my $parent (keys %{$by_parent}) {
            my @ops = @{$by_parent->{$parent}};
            OP: for(my $i = 0; $i < scalar @ops; ++$i) {
                if($i > 0 && $ops[$i-1] eq $ops[$i]) {
                    next OP;
                }
                $sum++;
            }
        }
    }
    return $sum;
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
    return 1 if ($child->isa('PPI::Statement::Given'));
    # anonymous sub
    return 1 if ($child->isa('PPI::Statement') && $child->find( sub { $_[1]->content eq 'sub' }));

    return 0;
}

1;
