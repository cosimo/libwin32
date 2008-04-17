use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::FileSecurity',
    'VERSION_FROM' => 'FileSecurity.pm',
    'dist'	=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);
