use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    NAME         => 'libwin32',
    VERSION_FROM => 'libwin32.pm',
);
