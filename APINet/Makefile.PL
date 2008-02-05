use strict;
use ExtUtils::MakeMaker;

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
