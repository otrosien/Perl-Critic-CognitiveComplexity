requires 'perl', '5.008001';
requires 'Perl::Critic', '1.121';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Perl::Critic', '1.03';
    requires 'Devel::Cover', '1.23';
    requires 'Devel::Cover::Report::Clover', '1.01';
    requires 'TAP::Harness::Archive', '0.18';
};

