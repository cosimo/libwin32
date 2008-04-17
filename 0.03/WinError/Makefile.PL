use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::WinError',
    'VERSION_FROM' => 'WinError.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
);
