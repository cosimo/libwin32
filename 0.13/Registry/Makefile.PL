use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Registry',
    'VERSION_FROM' => 'Registry.pm', # finds $VERSION
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);
