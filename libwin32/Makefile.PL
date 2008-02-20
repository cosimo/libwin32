use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

my %param = (
    NAME         => 'libwin32',
    VERSION_FROM => 'libwin32.pm',
);
$param{NO_META} = 1 if $ExtUtils::MakeMaker::VERSION >= 6.10_03;

WriteMakefile(%param);
