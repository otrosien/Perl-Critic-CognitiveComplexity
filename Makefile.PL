use inc::Module::Install;

# Define metadata
name 'Perl-Critic-Policy-Subroutines-ProhibitExcessCognitiveComplexity';
all_from 'lib/Perl/Critic/Policy/Subroutines/ProhibitExcessCognitiveComplexity.pm';

# Specific dependencies
requires 'Perl::Critic::Policy'      => 1.082;
requires 'Perl::Critic::Utils'       => 1.082;
requires 'PPI::Document'             => 0;

test_requires 'Test::More';
test_requires 'Perl::Critic::TestUtils' => 1.082;

WriteAll;
