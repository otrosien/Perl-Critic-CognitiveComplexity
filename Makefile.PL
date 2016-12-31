use inc::Module::Install;

# Define metadata
name 'Perl-Critic-Policy-Subroutines-ProhibitExcessCognitiveComplexity';
all_from 'lib/Perl/Critic/Policy/Subroutines/ProhibitExcessCognitiveComplexity.pm';

# Specific dependencies
requires 'Perl::Critic' => 0;
test_requires 'Test::More';

WriteAll;
