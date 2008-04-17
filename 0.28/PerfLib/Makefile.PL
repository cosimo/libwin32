use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
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
