use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	=> 'Win32::NetResource',
    'VERSION_FROM' => 'NetResource.pm',
    'dist'	=> {COMPRESS => 'gzip -9f', SUFFIX => 'gz'}, 
);
