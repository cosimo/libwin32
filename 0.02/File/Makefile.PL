use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::File',
    'VERSION_FROM' => 'File.pm', # finds $VERSION
    'dist' => {COMPRESS => 'gzip -9f', SUFFIX => 'gz'},
);
