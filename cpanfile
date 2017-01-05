requires 'perl', '5.010001';
requires 'Perl::Critic', '1.121';
requires 'Readonly', '2.00';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Perl::Critic', '1.03';
};

on 'build' => sub {
    requires 'Devel::Cover', '1.23';
    requires 'Devel::Cover::Report::Clover', '1.01';
    requires 'TAP::Harness::Archive', '0.18';
    requires 'Module::Build::Tiny', '0.039';
    requires 'experimental';
    requires 'Minilla', '3.0.0';
}
