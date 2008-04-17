use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::FileSecurity',
    'VERSION_FROM' => 'FileSecurity.pm', # finds $VERSION
    'dynamic_lib' => { OTHERLDFLAGS => 'advapi32.lib' },
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);
