use strict;
use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

my @libs;
push @libs, '-L/lib/w32api -lmpr -lnetapi32 -lntdll' if $^O eq "cygwin";

WriteMakefile(
    'NAME'		=> 'Win32::NetResource',
    'LIBS'		=> \@libs,
    'VERSION_FROM'	=> 'NetResource.pm',
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Jesse Dougherty',
	'ABSTRACT_FROM'	=> 'NetResource.pm',
      )),
);
