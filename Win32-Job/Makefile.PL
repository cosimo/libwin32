use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    NAME		=> 'Win32::Job',
    VERSION_FROM	=> 'Job.pm',
);
