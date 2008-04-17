use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Win32API::Registry',
    'VERSION_FROM'	=> 'Registry.pm',	# finds $VERSION
    ($] < 5.005 ? () : ('CAPI' => 'TRUE')),
);
