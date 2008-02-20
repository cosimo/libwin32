use ExtUtils::MakeMaker;

unless ($^O eq "MSWin32" || $^O eq "cygwin") {
    die "OS unsupported\n";
}

WriteMakefile(
    'NAME'		=> 'Win32::PerfLib',
    'VERSION_FROM'	=> 'PerfLib.pm', # finds $VERSION
    'dist'		=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
    'LIBS'		=> [''],   # e.g., '-lm' 
    'DEFINE'		=> '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'		=> '',     # e.g., '-I/usr/include/other'
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Jutta M. Klebe <jmk@bybyte.de>',
	'ABSTRACT_FROM'	=> 'PerfLib.pm',
      )),
);
