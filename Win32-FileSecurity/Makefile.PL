use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    'NAME'		=> 'Win32::FileSecurity',
    'VERSION_FROM'	=> 'FileSecurity.pm',
    'dist'		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Monte Mitzelfelt <monte@conchas.nm.org>',
	'ABSTRACT_FROM'	=> 'FileSecurity.pm',
      )),
);
