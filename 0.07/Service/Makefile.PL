use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::Service',
    'VERSION_FROM' => 'Service.pm', # finds $VERSION
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
);
