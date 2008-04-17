use ExtUtils::MakeMaker;
use Config;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Win32API::Registry',
    'VERSION_FROM'	=> 'Registry.pm',	# finds $VERSION
    ($Config{'archname'} !~ /-object$/i ? () :
      (
	'CAPI'		=> 'TRUE'
      )),
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Tye McQueen <tye@metronet.com>',
	'ABSTRACT_FROM'	=> 'Registry.pm',
      )),
);
