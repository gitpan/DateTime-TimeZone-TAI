use Module::Build;
my $build = Module::Build->new(
        module_name => 'DateTime::TimeZone::TAI',
        license     => 'perl',
        requires    => {
                         'DateTime' => '0.24',
                       },
        build_requires => { 'Test::More' => 0, },
        recommends  => { 'Test::Pod' => 1, },
        create_makefile_pl => 'passthrough',
        dist_author => 'Eugene van der Pijll',
        dist_abstract => 'Implements the TAI timescale for DateTime objects',
);
$build->create_build_script;
