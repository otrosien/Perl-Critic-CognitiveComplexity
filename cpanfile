requires 'perl', '5.008001';
requires 'Perl::Critic', '1.121';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Perl::Critic', '1.03';
    requires 'File::Spec', '3.56';
};

