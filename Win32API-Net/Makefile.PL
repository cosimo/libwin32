use strict;
use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

my @libs;
push @libs, '-L/lib/w32api -lnetapi32' if $^O eq "cygwin";

WriteMakefile(
    'NAME'		=> 'Win32API::Net',
    'LIBS'		=> \@libs,
    'VERSION_FROM'	=> 'Net.pm',
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Bret Giddings <bret@essex.ac.uk>',
	'ABSTRACT_FROM'	=> 'Net.pm',
      )),
);
