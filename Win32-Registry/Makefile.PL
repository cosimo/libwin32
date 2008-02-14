use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Win32::Registry',
    'VERSION_FROM'	=> 'Registry.pm', # finds $VERSION
    'dist'		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
    ($] < 5.005 ? () :
      (
	'AUTHOR'	=> 'Unknown',
	'ABSTRACT'	=> 'An object oriented interface to the Win32 Registry.',
      )),
);
